import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'color_schemes.g.dart';

import 'models/doctor.dart';
import 'models/patient.dart';
import 'pages/home.dart';

void main() async {
  final appDocumentDir = await getApplicationDocumentsDirectory();

  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(DoctorAdapter());
  Hive.registerAdapter(PatientAdapter());

  // await Hive.deleteBoxFromDisk('patients');
  // await Hive.deleteBoxFromDisk('doctors');
  await Hive.openBox<Doctor>('doctors');
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
