import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hospital_management_system/models/patient.dart';
import 'package:hospital_management_system/models/service_appointment.dart';
import 'package:intl/intl.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    final patientsBox = Hive.box<Patient>('patients');

    final now = DateFormat.yMMMMd('en_US').format(DateTime.now());
    final filteredPatients =
        patientsBox.values.where((patient) => patient.appointmentDate == now);

    final servicesBox = Hive.box<ServiceAppointment>('serviceAppointments');
    final filteredServices = servicesBox.values
        .where((service) => service.serviceAvailedDate == now);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              // height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width * .3,
              child: Card(
                child: ListTile(
                  title: const Text('Total Patients Appointed Today'),
                  trailing: Text(filteredPatients.length.toString()),
                  subtitle: Text(now),
                ),
              ),
            ),
            SizedBox(
              // height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width * .3,
              child: Card(
                child: ListTile(
                  title: const Text('Total Services Availed Today'),
                  trailing: Text(filteredServices.length.toString()),
                  subtitle: Text(now),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
