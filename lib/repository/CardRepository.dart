import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_leitner/util/DateTimeUtil.dart';

import '../entity/CardEntity.dart';

class CardRepository {
  static const boxId = "card";

  ValueListenable<Box> listenable() {
    var box = Hive.box(boxId);
    return box.listenable();
  }

  Future<int> persist(CardEntity cardEntity) async {
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

  void removeAll() async {
    var box = Hive.box(boxId);
    await box.clear();
  }

  Future<void> merge(CardEntity cardEntity) async {
    var box = Hive.box(boxId);
    await box.put(cardEntity.id, cardEntity);
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

    // categorize based on the group level
    Map<int, dynamic> groupLevel = {};
    for (var element in box.values) {
      if (groupLevel[element.level] == null) {
        groupLevel[element.level] = {
          "dates": {},
          "items": [],
        };
      }
      if (element.level == 1 ||
          DateTimeUtil.daysBetween(element.modified) >= 1) {
        var date = DateTimeUtil.format('yyyy-MM-dd', element.modified);
        groupLevel[element.level]['dates'][date] = date;
        groupLevel[element.level]['items'].add(element);
      }
    }

    // descending sort based on the group level
    var sortedKeys = groupLevel.keys.toList()
      ..sort((e1, e2) => e2.compareTo(e1));

    // prepare result
    var result = [];
    for (var key in sortedKeys) {
      var item = groupLevel[key];
      if (item['dates'].length >= pow(2, key - 1)) {
        var orders = item['items']
          ..sort((e1, e2) {
            return Comparable.compare(e1.order, e2.order);
          });
        result.addAll(orders);
      }
    }
    return result;
  }
}
