import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hospital_management_system/models/appointment.dart';
import 'package:intl/intl.dart';

class AppointmentsList extends StatefulWidget {
  const AppointmentsList({super.key});

  @override
  State<AppointmentsList> createState() => _AppointmentsListState();
}

class _AppointmentsListState extends State<AppointmentsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Box<Appointment>>(
        valueListenable: Hive.box<Appointment>('patients').listenable(),
        builder: (context, box, _) {
          return box.values.isEmpty
              ? const Center(
                  child: Text(
                    "No Patients Record found!.",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final patients = box.values.toList();
                    final patient = patients.reversed.toList()[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        child: ListTile(
                          leading: Text(patient.index.toString()),
                          title: Text(patient.name),
                          subtitle: Row(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Age:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    patient.age.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Row(
                                children: [
                                  const Text(
                                    'Date:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    DateFormat.yMMMMd('en_US')
                                        .format(patient.appointmentDate),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Row(
                                children: [
                                  const Text(
                                    'Phone:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    '0${patient.phone}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Row(
                                children: [
                                  const Text(
                                    'Amount:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    '${patient.amount}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Row(
                                children: [
                                  const Text(
                                    'Treated By:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    patient.doctor,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDeleteDialog(context, index);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}

void showDeleteDialog(BuildContext context, int index) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Patient?'),
      content: const Text('Are you sure you want to delete this patient?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Delete'),
          onPressed: () {
            deletePatient(index);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

void deletePatient(int index) {
  final box = Hive.box<Appointment>('patients');
  box.deleteAt(index);

  // Update the index property of the remaining patients
  for (var i = 0; i < box.length; i++) {
    final patient = box.getAt(i);
    patient!.index = i;
    patient.save();
  }
}
