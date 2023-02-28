import 'package:hive_flutter/adapters.dart';

import '../models/patient.dart';

class PatientAdapter extends TypeAdapter<Patient> {
  @override
  final int typeId = 1;

  @override
  Patient read(BinaryReader reader) {
    return Patient(
      name: reader.readString(),
      age: reader.readInt(),
      phone: reader.readInt(),
      gender: reader.readString(),
      amount: reader.readDouble(),
      amountPaid: reader.readDouble(),
      date: reader.read(),
      time: reader.read(),
      doctor: reader.readString(),
      careOf: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Patient obj) {
    writer.writeString(obj.name);
    writer.writeInt(obj.age);
    writer.writeString(obj.gender);
    writer.writeInt(obj.phone);
    writer.writeString(obj.doctor);
    writer.writeString(obj.careOf);
    writer.writeDouble(obj.amount);
    writer.writeDouble(obj.amountPaid);
    writer.write(obj.date);
    writer.write(obj.time);

  }
}
