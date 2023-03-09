import 'package:hive/hive.dart';

part 'patient.g.dart';

@HiveType(typeId: 0)
class Patient extends HiveObject {
  // Constructor
  Patient({
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.doctor,
    required this.careOf,
    required this.amount,
    required this.amountPaid,
    required this.appointmentDate,
    required this.reason,
    required this.tokenNumber,
  });

  @HiveField(1)
  int age;

  @HiveField(6)
  double amount;

  @HiveField(7)
  double amountPaid;

  @HiveField(5)
  String careOf;

  @HiveField(8)
  DateTime appointmentDate;

  @HiveField(4)
  String doctor;

  @HiveField(2)
  String gender;

  @HiveField(0)
  String name;

  @HiveField(3)
  int phone;

  @HiveField(9)
  String reason;

  @HiveField(10)
  int tokenNumber;
}
