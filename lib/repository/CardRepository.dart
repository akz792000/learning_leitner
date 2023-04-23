import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_leitner/enums/CountryEnum.dart';
import 'package:learning_leitner/util/DateTimeUtil.dart';

import '../entity/CardEntity.dart';
import '../util/ListUtil.dart';

class CardRepository {
  static const boxId = "card";

  ValueListenable<Box> listenable() {
    var box = Hive.box(boxId);
    return box.listenable();
  }

  Future<int> merge(CardEntity cardEntity) async {
    var box = Hive.box(boxId);
    if (cardEntity.id == 0) {
      cardEntity.id = await box.add(cardEntity);
    }
    await box.put(cardEntity.id, cardEntity);
    return cardEntity.id;
  }

  Future<void> remove(CardEntity cardEntity) async {
    var box = Hive.box(boxId);
    await box.delete(cardEntity.id);
  }

  Future<void> removeAll() async {
    var box = Hive.box(boxId);
    await box.deleteAll(box.keys);
  }

  CardEntity? findById(int id) {
    var box = Hive.box(boxId);
    return box.get(id);
  }

  List findAll() {
    var box = Hive.box(boxId);
    return box.values.toList();
  }

  List findAllByCountry(LanguageEnum countryEnum) {
    var box = Hive.box(boxId);
    test(element) {
      if (countryEnum == LanguageEnum.en) {
        return element.fa != "" && element.en != "";
      } else {
        return element.de != "" && element.en != "";
      }
    }
    return box.values.where((element) => test(element)).toList();
  }

  List findAllByLevelAndCountry(int level, LanguageEnum countryEnum) {
    var box = Hive.box(boxId);
    test(element) {
      if (countryEnum == LanguageEnum.en) {
        return element.level == level && element.fa != "" && element.en != "";
      } else {
        return element.level == level && element.de != "" && element.en != "";
      }
    }
    return box.values.where((element) => test(element)).toList();
  }

  List findAllByDateDifference() {
    var box = Hive.box(boxId);
    return box.values
        .where((element) =>
            element.level == 1 ||
            DateTimeUtil.daysToNow(element.created) >=
                pow(2, element.level - 1))
        .toList();
  }

  Map<int, int> findAllLevelBasedByLanguage(LanguageEnum languageEnum) {
    var elements = findAllByCountry(languageEnum);

    // categorize based on the group level
    Map<int, int> groupLevel = {};
    for (var element in elements) {
      var val = groupLevel[element.level] ?? 0;
      groupLevel[element.level] = val + 1;
    }

    // descending sort based on the group level
    var sortedKeys = ListUtil.sortDesc(groupLevel.keys.toList());

    // prepare result
    Map<int, int> result = {};
    for (var key in sortedKeys) {
      result[key] = groupLevel[key]!;
    }
    return result;
  }

  List findAllBaseOnLeitner(LanguageEnum languageEnum) {
    var elements = findAllByCountry(languageEnum);

    // group based on group level
    Map<int, dynamic> groupLevel = {};
    for (var element in elements) {
      groupLevel[element.level] = groupLevel[element.level] ?? [];
      groupLevel[element.level].add(element);
    }

    // descending sort based on the group level
    var sortedKeys = ListUtil.sortAsc(groupLevel.keys.toList());

    // items should be read
    var result = [];
    for (var key in sortedKeys) {
      var addedItems = [];
      var items = groupLevel[key];
      if (key == CardEntity.newbieLevel) {
        addedItems.addAll(items);
      } else {
        /**
         * consider each item if exist more then one day discrepancy
         * if it is in the last sub level, it means we have to consider it and
         * if not we have to increase the sub level till to the maximum sub level
         */
        var maxSubLevelCount = pow(2, key - 1);
        for (var item in items) {
          if (DateTimeUtil.daysToNow(item.modified) >= maxSubLevelCount) {
            if (item.subLevel == maxSubLevelCount) {
              addedItems.add(item);
            } else {
              if (item.subLevel < maxSubLevelCount) {
                item.subLevel++;
              }
            }
          }
        }
      }

      // order the items of each group
      var orders = addedItems
        ..sort((e1, e2) {
          return Comparable.compare(e1.order, e2.order);
        });
      result.addAll(orders);
    }
    return result;
  }

}
