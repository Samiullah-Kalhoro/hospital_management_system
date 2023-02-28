import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'color_schemes.g.dart';
import 'controllers/patient_adapter.dart';
import 'models/patient.dart';
import 'pages/home.dart';

void main() async {

    await Hive.initFlutter();
  // Hive.registerAdapter(DoctorAdapter());
  Hive.registerAdapter(PatientAdapter());

  // await Hive.openBox<Doctor>('doctors');
  // await Hive.deleteBoxFromDisk('patients');
  await Hive.openBox<Patient>('patients');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const Home(),
    );
  }
}
