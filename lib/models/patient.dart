
import 'package:hive/hive.dart';

@HiveType(typeId: 2)
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
    required this.date,
    required this.time,
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
  DateTime date;

  @HiveField(4)
  String doctor;

  @HiveField(2)
  String gender;

  @HiveField(0)
  String name;

  @HiveField(3)
  int phone;

  @HiveField(9)
  String time;
}