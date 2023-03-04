import 'package:hive/hive.dart';

part 'doctor.g.dart';

@HiveType(typeId: 1)
class Doctor extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String specialization;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String email;

  @HiveField(4)
  String gender;

  // Constructor
  Doctor({
    required this.name,
    required this.specialization,
    required this.phone,
    required this.email,
    required this.gender,
  });
}
