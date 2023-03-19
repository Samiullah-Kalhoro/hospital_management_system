import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:hospital_management_system/authentication/login_screen.dart';

import 'authentication/model/user.dart';
import 'color_schemes.g.dart';
import 'models/appointment.dart';
import 'models/doctor.dart';
import 'models/service.dart';
import 'models/service_appointment.dart';
import 'pages/admin/model/model/admin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();

  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(DoctorAdapter());
  Hive.registerAdapter(AppointmentAdapter());
  Hive.registerAdapter(ServiceAdapter());
  Hive.registerAdapter(ServiceAppointmentAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(AdminAdapter());

  // await Hive.deleteBoxFromDisk('users');
  // await Hive.deleteBoxFromDisk('patients');
  // await Hive.deleteBoxFromDisk('doctors');
  // await Hive.deleteBoxFromDisk('service');
  // await Hive.deleteBoxFromDisk('serviceAppointments');
  // await Hive.deleteBoxFromDisk('admins');

  await Hive.openBox<Admin>('admins');
  await Hive.openBox<User>('users');
  await Hive.openBox<Doctor>('doctors');
  await Hive.openBox<Appointment>('patients');
  await Hive.openBox<Service>('service');
  await Hive.openBox<ServiceAppointment>('serviceAppointments');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.red[400],
          contentTextStyle: const TextStyle(color: Colors.white),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.red[400],
          contentTextStyle: const TextStyle(color: Colors.white),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
