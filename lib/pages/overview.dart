import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hospital_management_system/models/patient.dart';
import 'package:hospital_management_system/models/service_appointment.dart';
import 'package:intl/intl.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  DateTime? _selectedDate = DateTime.now();

  int numberOfPatients = 0;
  int numberOfServices = 0;

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onSubmit() async {
    if (_selectedDate == null) {
      // show error message
      return;
    }

    final patientsBox = Hive.box<Patient>('patients');
    final filteredPatients = patientsBox.values.where((patient) {
      final appointmentDate =
          DateFormat.yMMMMd('en_US').format(patient.appointmentDate);
      final selectedDate = DateFormat.yMMMMd('en_US').format(_selectedDate!);
      return appointmentDate == selectedDate;
    }).toList();

    final servicesBox = Hive.box<ServiceAppointment>('serviceAppointments');
    final filteredServices = servicesBox.values.where((service) {
      final appointmentDate =
          DateFormat.yMMMMd('en_US').format(service.serviceAvailedDate);
      final selectedDate = DateFormat.yMMMMd('en_US').format(_selectedDate!);
      return appointmentDate == selectedDate;
    }).toList();

    numberOfPatients = filteredPatients.length;
    numberOfServices = filteredServices.length;
  }

  @override
  Widget build(BuildContext context) {


    setState(() {
      _onSubmit();
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      _onDateSelected(selectedDate);
                    }
                  },
                  child: Text(_selectedDate == null
                      ? 'Select a date'
                      : DateFormat.yMMMMd().format(_selectedDate!)),
                ),
              ],
            ),
            SizedBox(
              // height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width * .3,
              child: Card(
                child: ListTile(
                  title: const Text('Total Patients Appointed'),
                  trailing: Text(numberOfPatients.toString()),
                  subtitle: Text(DateFormat.yMMMMd().format(_selectedDate!)),
                ),
              ),
            ),
            SizedBox(
              // height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width * .3,
              child: Card(
                child: ListTile(
                  title: const Text('Number of Services Availed'),
                  trailing: Text(numberOfServices.toString()),
                  subtitle: Text(DateFormat.yMMMMd().format(_selectedDate!)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
