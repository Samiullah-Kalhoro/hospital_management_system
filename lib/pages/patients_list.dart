import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hospital_management_system/models/patient.dart';
import 'package:intl/intl.dart';

class PatientsList extends StatefulWidget {
  const PatientsList({super.key});

  @override
  State<PatientsList> createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients List'),
      ),
      body: ValueListenableBuilder<Box<Patient>>(
        valueListenable: Hive.box<Patient>('patients').listenable(),
        builder: (context, box, _) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final patient = box.getAt(index);
              final patientIndex = patient!.key;
              return ListTile(
                leading: Text((patientIndex + 1).toString()),
                title: Text(patient.name),
                subtitle: Row(
                  children: [
                    Text(patient.age.toString()),
                    const SizedBox(width: 10),
                    Text(patient.gender),
                    const SizedBox(width: 10),
                    Text(DateFormat.yMMMMd().format(patient.appointmentDate)),
                    const SizedBox(width: 10),
                    Text('Token Number is ${patient.tokenNumber}'),
                    const SizedBox(width: 10),
                    Text('Phone Number is ${patient.phone}')
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDeleteDialog(context, index);
                  },
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
  final box = Hive.box<Patient>('patients');
  box.deleteAt(index);
}
