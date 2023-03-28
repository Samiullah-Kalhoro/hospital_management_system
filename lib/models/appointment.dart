import 'package:hive/hive.dart';

part 'appointment.g.dart';

@HiveType(typeId: 0)
class Appointment extends HiveObject {
  // Constructor
  Appointment({
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.doctor,
    required this.careOf,
    required this.amount,
    required this.appointmentDate,
    required this.reason,
    required this.tokenNumber,
    required this.index,
  });

  @HiveField(1)
  String age;

  @HiveField(6)
  double amount;

  @HiveField(5)
  String careOf;

  @HiveField(7)
  DateTime appointmentDate;

  @HiveField(4)
  String doctor;

  @HiveField(2)
  String gender;

  @HiveField(0)
  String name;

  @HiveField(3)
  int phone;

  @HiveField(8)
  String reason;

  @HiveField(9)
  int tokenNumber;

  @HiveField(10)
  int index;
}
