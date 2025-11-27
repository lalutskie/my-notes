// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncSettingsAdapter extends TypeAdapter<SyncSettings> {
  @override
  final typeId = 2;

  @override
  SyncSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncSettings(
      isSyncEnabled: fields[0] == null ? false : fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SyncSettings obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.isSyncEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
