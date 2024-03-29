import 'package:hive/hive.dart';

part 'service_appointment.g.dart';

@HiveType(typeId: 3)
class ServiceAppointment extends HiveObject {
  // Constructor
  ServiceAppointment({
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.selectedService,
    required this.amount,
    required this.serviceAvailedDate,
    required this.tokenNumber,
    required this.index,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String age;

  @HiveField(2)
  String gender;

  @HiveField(3)
  int phone;

  @HiveField(4)
  String selectedService;

  @HiveField(5)
  double amount;

  @HiveField(6)
  DateTime serviceAvailedDate;

  @HiveField(7)
  int tokenNumber;

  @HiveField(8)
  int index;
}
