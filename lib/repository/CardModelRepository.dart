import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_leitner/util/DateTimeUtil.dart';

import '../model/CardModel.dart';

class CardModelRepository {
  static const boxId = "card";

  ValueListenable<Box> listenable() {
    var box = Hive.box(boxId);
    return box.listenable();
  }

  Future<int> persist(CardModel cardModel) async {
    var box = Hive.box(boxId);
    if (cardModel.id == 0) {
      cardModel.id = await box.add(cardModel);
    }
    await box.put(cardModel.id, cardModel);
    return cardModel.id;
  }

  Future<void> remove(CardModel cardModel) async {
    var box = Hive.box(boxId);
    await box.delete(cardModel.id);
  }

  void removeAll() async {
    var box = Hive.box(boxId);
    await box.clear();
  }

  Future<void> merge(CardModel cardModel) async {
    var box = Hive.box(boxId);
    await box.put(cardModel.id, cardModel);
  }

  CardModel? findById(int id) {
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
        result.addAll(item['items']);
      }
    }
    return result;
  }
}
