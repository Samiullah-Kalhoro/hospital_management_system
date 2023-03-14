// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_appointment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceAppointmentAdapter extends TypeAdapter<ServiceAppointment> {
  @override
  final int typeId = 3;

  @override
  ServiceAppointment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceAppointment(
      name: fields[0] as String,
      age: fields[1] as int,
      gender: fields[2] as String,
      phone: fields[3] as int,
      selectedService: fields[4] as String,
      amount: fields[5] as double,
      serviceAvailedDate: fields[6] as DateTime,
      tokenNumber: fields[7] as int,
      index: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceAppointment obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.selectedService)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.serviceAvailedDate)
      ..writeByte(7)
      ..write(obj.tokenNumber)
      ..writeByte(8)
      ..write(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceAppointmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
