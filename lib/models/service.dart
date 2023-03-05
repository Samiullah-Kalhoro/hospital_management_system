import 'package:hive/hive.dart';

part 'service.g.dart';

@HiveType(typeId: 2)
class Service extends HiveObject {
  @HiveField(0)
  String serviceName;

  // Constructor
  Service({
    required this.serviceName,
  });
}
