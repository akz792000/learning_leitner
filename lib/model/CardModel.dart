import 'package:hive/hive.dart';
import 'package:timezone/timezone.dart' as tz;

part 'CardModel.g.dart';

@HiveType(typeId: 1)
class CardModel {

  static const int DEFAULT_LEVEL = 1;

  @HiveField(0)
  int id;

  @HiveField(1)
  String fa;

  @HiveField(2)
  String en;

  @HiveField(3)
  int level;

  @HiveField(4)
  tz.TZDateTime created;

  @HiveField(4)
  tz.TZDateTime modified;

  // generated
  bool flag = false;

  CardModel({
    required this.id,
    required this.fa,
    required this.en,
    required this.level,
    required this.created,
    required this.modified,
  });
}
