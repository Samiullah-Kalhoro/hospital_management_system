import 'package:hive/hive.dart';

part 'admin.g.dart';

@HiveType(typeId: 5)
class Admin extends HiveObject {
  Admin({
    required this.userName,
    required this.password,
  });

  @HiveField(1)
  String password;

  @HiveField(0)
  String userName;

}
