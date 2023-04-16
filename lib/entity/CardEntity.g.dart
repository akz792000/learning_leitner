// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CardEntity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardEntityAdapter extends TypeAdapter<CardEntity> {
  @override
  final int typeId = 1;

  @override
  CardEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardEntity(
      // id
      id: fields[0] as int,

      // created
      created: fields[1] != null
          ? tz.TZDateTime.from(fields[1], tz.local)
          : tz.TZDateTime.now(tz.local),

      // modified
      modified: fields[2] != null
          ? tz.TZDateTime.from(fields[2], tz.local)
          : tz.TZDateTime.now(tz.local),

      // level
      level: fields[3] != null ? fields[3] as int : 0,

      // subLevel
      subLevel: fields[4] != null ? fields[4] as int : 0,

      // order
      order: fields[5] != null ? fields[5] as int : 0,

      // fa
      fa: fields[6] as String,

      // en
      en: fields[7] as String,

      // desc
      desc: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CardEntity obj) {
    writer
      ..writeByte(9)

      // id
      ..writeByte(0)
      ..write(obj.id)

      // created
      ..writeByte(1)
      ..write(obj.created)

      // modified
      ..writeByte(2)
      ..write(obj.modified)

      // level
      ..writeByte(3)
      ..write(obj.level)

      // subLevel
      ..writeByte(4)
      ..write(obj.subLevel)

      // order
      ..writeByte(5)
      ..write(obj.order)

      // fa
      ..writeByte(6)
      ..write(obj.fa)

      // en
      ..writeByte(7)
      ..write(obj.en)

      // desc
      ..writeByte(8)
      ..write(obj.desc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
