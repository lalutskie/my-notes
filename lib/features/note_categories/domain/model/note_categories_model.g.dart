// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_categories_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteCategoriesModelAdapter extends TypeAdapter<NoteCategoriesModel> {
  @override
  final typeId = 3;

  @override
  NoteCategoriesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteCategoriesModel(
      id: fields[0] as String,
      uid: fields[1] as String,
      name: fields[2] as String,
      createdAt: fields[3] as DateTime?,
      updatedAt: fields[4] as DateTime?,
      deletedAt: fields[5] as DateTime?,
      isDeleted: fields[6] == null ? false : fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NoteCategoriesModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uid)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.deletedAt)
      ..writeByte(6)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteCategoriesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
