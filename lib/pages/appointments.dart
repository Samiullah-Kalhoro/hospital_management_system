import 'package:flutter/material.dart';
import 'package:hospital_management_system/widgets/appointment_form.dart';

class Appointments extends StatelessWidget {
  const Appointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Appointments"),
      ),
      body: const AppointmentForm(),
    );
  }
}