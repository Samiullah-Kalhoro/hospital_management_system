import 'package:hive_flutter/hive_flutter.dart';

import '../models/doctor.dart';



class DoctorAdapter extends TypeAdapter<Doctor> {
  @override
  final int typeId = 0;

  @override
  Doctor read(BinaryReader reader) {
    return Doctor(
      name: reader.readString(),
      email: reader.readString(),
      phone: reader.readString(),
      specialization: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Doctor obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.email);
    writer.writeString(obj.phone);
    writer.writeString(obj.specialization);
  }
}
