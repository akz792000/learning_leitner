import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_leitner/enums/CountryEnum.dart';
import 'package:learning_leitner/util/DateTimeUtil.dart';

import '../entity/CardEntity.dart';
import '../repository/CardRepository.dart';
import '../util/ListUtil.dart';

class CardService {

  final CardRepository _cardRepository = Get.find<CardRepository>();

  List findAllBasedOnLeitner(LanguageEnum languageEnum) {
    var elements = _cardRepository.findAllByCountry(languageEnum);

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
      if (key == CardEntity.initLevel) {
        addedItems.addAll(items);
      } else {
        /**
         * consider each item if exist more then one day discrepancy
         * if it is in the last sub level, it means we have to consider it and
         * if not we have to increase the sub level till to the maximum sub level
         */
        var maxSubLevelCount = pow(2, key - 1);
        for (var item in items) {
          if (DateTimeUtil.daysToNowWithoutTime(item.modified) >= 1) {
            if (item.subLevel < maxSubLevelCount) {
              item.subLevel = item.subLevel + 1;
              item.modified = DateTimeUtil.now();
              _cardRepository.merge(item);
            } else {
              addedItems.add(item);
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
