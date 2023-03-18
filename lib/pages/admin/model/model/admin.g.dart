// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdminAdapter extends TypeAdapter<Admin> {
  @override
  final int typeId = 5;

  @override
  Admin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Admin(
      userName: fields[0] as String,
      password: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Admin obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(0)
      ..write(obj.userName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
