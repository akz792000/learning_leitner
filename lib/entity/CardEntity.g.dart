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
      id: fields[0] as int,
      fa: fields[1] as String,
      en: fields[2] as String,
      level: fields[3] != null ? fields[3] as int : 0,
      created: fields[4] != null
          ? tz.TZDateTime.from(fields[4], tz.local)
          : tz.TZDateTime.now(tz.local),
      modified: fields[5] != null
          ? tz.TZDateTime.from(fields[5], tz.local)
          : tz.TZDateTime.now(tz.local),
      order: fields[6] != null ? fields[6] as int : 0,
    );
  }

  @override
  void write(BinaryWriter writer, CardEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fa)
      ..writeByte(2)
      ..write(obj.en)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.created)
      ..writeByte(5)
      ..write(obj.modified)
      ..writeByte(6)
      ..write(obj.order);
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
