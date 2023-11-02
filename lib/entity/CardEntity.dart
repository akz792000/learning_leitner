import 'package:hive/hive.dart';
import 'package:learning_leitner/enums/GroupCode.dart';
import 'package:timezone/timezone.dart' as tz;

part 'CardEntity.g.dart';

@HiveType(typeId: 1)
class CardEntity {
  static const int initLevel = 0;
  static const int initSubLevel = 1;

  @HiveField(0)
  int id;

  @HiveField(1)
  tz.TZDateTime created;

  @HiveField(2)
  tz.TZDateTime modified;

  @HiveField(3)
  int level;

  @HiveField(4)
  int subLevel;

  @HiveField(5)
  int order;

  @HiveField(6)
  String fa;

  @HiveField(7)
  String en;

  @HiveField(8)
  String de;

  @HiveField(9)
  String desc;

  @HiveField(10)
  GroupCode groupCode;

  // generated
  String? levelChanged;

  // generated
  bool orderChanged = false;

  CardEntity(
      {required this.id,
      required this.created,
      required this.modified,
      required this.level,
      required this.subLevel,
      required this.order,
      required this.fa,
      required this.en,
      required this.de,
      required this.desc,
      required this.groupCode});
}
