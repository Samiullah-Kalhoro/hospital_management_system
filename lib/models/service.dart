// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'service.g.dart';

@HiveType(typeId: 2)
class Service extends HiveObject {
  @HiveField(0)
  String serviceName;

  @HiveField(1)
  int index;

  // Constructor
  Service({
    required this.serviceName,
    required this.index,
  });
}
