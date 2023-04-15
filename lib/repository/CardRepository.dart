import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_leitner/util/DateTimeUtil.dart';
import 'package:timezone/standalone.dart';

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

  List findAllBasedOnDateDifference() {
    var box = Hive.box(boxId);
    return box.values
        .where((element) =>
            element.level == 1 ||
            DateTimeUtil.daysBetween(element.created) >=
                pow(2, element.level - 1))
        .toList();
  }

  List findAllBasedOnLeitner() {
    var box = Hive.box(boxId);

    // group based on group level
    Map<int, dynamic> groupLevel = {};
    for (var element in box.values) {
      groupLevel[element.level] = groupLevel[element.level] ?? [];
      groupLevel[element.level].add(element);
    }

    // descending sort based on the group level
    var sortedKeys = ListUtil.sortAsc(groupLevel.keys.toList());

    // items should be read
    var result = [];
    for (var key in sortedKeys) {
      var items = groupLevel[key];
      if (key == CardEntity.newbieLevel) {
        result.addAll(items);
      } else {
        var maxSubLevelCount = pow(2, key - 1);
        for (var item in items) {
          if (item.subLevel == maxSubLevelCount) {
            result.add(item);
          } else {
            if (item.subLevel < maxSubLevelCount && DateTimeUtil.daysBetween(item.modified) >= 1) {
              item.subLevel++;
            }
          }
        }
      }
    }

    return result;
  }

  Map<int, int> findAllBasedOnLevel() {
    var box = Hive.box(boxId);

    // categorize based on the group level
    Map<int, int> groupLevel = {};
    for (var element in box.values) {
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
}
