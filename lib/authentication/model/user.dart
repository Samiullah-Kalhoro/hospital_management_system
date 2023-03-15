import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 4)
class User extends HiveObject {
  User({
    required this.userName,
    required this.password,
  });

  @HiveField(1)
  String password;

  @HiveField(0)
  String userName;

}
