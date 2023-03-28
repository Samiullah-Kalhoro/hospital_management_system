// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentAdapter extends TypeAdapter<Appointment> {
  @override
  final int typeId = 0;

  @override
  Appointment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Appointment(
      name: fields[0] as String,
      age: fields[1] as String,
      gender: fields[2] as String,
      phone: fields[3] as int,
      doctor: fields[4] as String,
      careOf: fields[5] as String,
      amount: fields[6] as double,
      appointmentDate: fields[7] as DateTime,
      reason: fields[8] as String,
      tokenNumber: fields[9] as int,
      index: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Appointment obj) {
    writer
      ..writeByte(11)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(6)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.careOf)
      ..writeByte(7)
      ..write(obj.appointmentDate)
      ..writeByte(4)
      ..write(obj.doctor)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(8)
      ..write(obj.reason)
      ..writeByte(9)
      ..write(obj.tokenNumber)
      ..writeByte(10)
      ..write(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
