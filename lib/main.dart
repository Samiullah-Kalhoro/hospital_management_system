import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hospital_management_system/authentication/login_screen.dart';
import 'package:hospital_management_system/pages/login_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

import 'authentication/model/user.dart';
import 'color_schemes.g.dart';

import 'models/doctor.dart';
import 'models/appointment.dart';
import 'models/service.dart';
import 'models/service_appointment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();

  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(DoctorAdapter());
  Hive.registerAdapter(AppointmentAdapter());
  Hive.registerAdapter(ServiceAdapter());
  Hive.registerAdapter(ServiceAppointmentAdapter());
  Hive.registerAdapter(UserAdapter());

  // await Hive.deleteBoxFromDisk('users');
  // await Hive.deleteBoxFromDisk('patients');
  // await Hive.deleteBoxFromDisk('doctors');
  // await Hive.deleteBoxFromDisk('service');
  // await Hive.deleteBoxFromDisk('serviceAppointments');

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
      theme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),

      home: const LoginScreen(),
      // home: const Home(),
    );
  }
}
