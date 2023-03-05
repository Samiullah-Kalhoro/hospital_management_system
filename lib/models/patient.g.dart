// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientAdapter extends TypeAdapter<Patient> {
  @override
  final int typeId = 0;

  @override
  Patient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Patient(
      name: fields[0] as String,
      age: fields[1] as int,
      gender: fields[2] as String,
      phone: fields[3] as int,
      doctor: fields[4] as String,
      careOf: fields[5] as String,
      amount: fields[6] as double,
      amountPaid: fields[7] as double,
      appointmentDate: fields[8] as String,
      reason: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Patient obj) {
    writer
      ..writeByte(10)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(6)
      ..write(obj.amount)
      ..writeByte(7)
      ..write(obj.amountPaid)
      ..writeByte(5)
      ..write(obj.careOf)
      ..writeByte(8)
      ..write(obj.appointmentDate)
      ..writeByte(4)
      ..write(obj.doctor)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(9)
      ..write(obj.reason);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
