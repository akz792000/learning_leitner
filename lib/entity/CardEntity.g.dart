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

      // fa
      fa: fields[1] as String,

      // en
      en: fields[2] as String,

      // level
      level: fields[3] != null ? fields[3] as int : 0,

      // subLevel
      subLevel: fields[4] != null ? fields[4] as int : 0,

      // order
      order: fields[5] != null ? fields[5] as int : 0,

      // created
      created: fields[6] != null
          ? tz.TZDateTime.from(fields[6], tz.local)
          : tz.TZDateTime.now(tz.local),

      // modified
      modified: fields[7] != null
          ? tz.TZDateTime.from(fields[7], tz.local)
          : tz.TZDateTime.now(tz.local),
    );
  }

  @override
  void write(BinaryWriter writer, CardEntity obj) {
    writer
      ..writeByte(7)

      // id
      ..writeByte(0)
      ..write(obj.id)

      // fa
      ..writeByte(1)
      ..write(obj.fa)

      // en
      ..writeByte(2)
      ..write(obj.en)

      // level
      ..writeByte(3)
      ..write(obj.level)

      // subLevel
      ..writeByte(4)
      ..write(obj.subLevel)

      // order
      ..writeByte(5)
      ..write(obj.order)

      // created
      ..writeByte(6)
      ..write(obj.created)

      // modified
      ..writeByte(7)
      ..write(obj.modified);
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
