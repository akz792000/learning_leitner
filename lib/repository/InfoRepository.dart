import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_leitner/enums/GroupCode.dart';

import '../entity/InfoEntity.dart';

class InfoRepository {
  static const boxId = "info";

  ValueListenable<Box> listenable() {
    var box = Hive.box(boxId);
    return box.listenable();
  }

  Future<int> merge(InfoEntity infoEntity) async {
    var box = Hive.box(boxId);
    if (infoEntity.id == 0) {
      infoEntity.id = await box.add(infoEntity);
    }
    await box.put(infoEntity.id, infoEntity);
    return infoEntity.id;
  }

  Future<void> remove(InfoEntity infoEntity) async {
    var box = Hive.box(boxId);
    await box.delete(infoEntity.id);
  }

  Future<void> removeAll() async {
    var box = Hive.box(boxId);
    await box.deleteAll(box.keys);
  }

  Future<void> removeList(List elements) async {
    var box = Hive.box(boxId);
    for (var element in elements) {
      await box.delete(element.id);
    }
  }

  InfoEntity? findById(int id) {
    var box = Hive.box(boxId);
    return box.get(id);
  }

  List findAll() {
    var box = Hive.box(boxId);
    return box.values.toList();
  }

  List findAllByGroupCode(GroupCode groupCode) {
    var box = Hive.box(boxId);
    return box.values.where((element) {
      return element.groupCode == groupCode;
    }).toList();
  }

  InfoEntity? findByGroupCodeAndKeyUpperCase(GroupCode groupCode, String key) {
    var box = Hive.box(boxId);
    return box.values.length == 0
        ? null
        : box.values.where((element) {
            return element.groupCode == groupCode &&
                element.key.toString().toUpperCase() == key.toUpperCase();
          }).firstOrNull;
  }
}
