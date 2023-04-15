import 'dart:ffi';

import 'package:hive/hive.dart';
import 'package:timezone/timezone.dart' as tz;

part 'CardEntity.g.dart';

@HiveType(typeId: 1)
class CardEntity {
  static const int newbieLevel = 0;
  static const int initLevel = 1;
  static const int initSubLevel = 1;

  @HiveField(0)
  int id;

  @HiveField(1)
  String fa;

  @HiveField(2)
  String en;

  @HiveField(3)
  int level;

  @HiveField(4)
  int subLevel;

  @HiveField(5)
  int order;

  @HiveField(6)
  tz.TZDateTime created;

  @HiveField(7)
  tz.TZDateTime modified;

  // generated
  String? levelChanged;

  // generated
  bool orderChanged = false;

  CardEntity({
    required this.id,
    required this.fa,
    required this.en,
    required this.level,
    required this.subLevel,
    required this.order,
    required this.created,
    required this.modified,
  });
}
