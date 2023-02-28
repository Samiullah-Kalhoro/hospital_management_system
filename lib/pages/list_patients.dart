import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/patient.dart';

class PatientsList extends StatelessWidget {
  const PatientsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Patients List"),
      ),
      body: ValueListenableBuilder<Box<Patient>>(
        valueListenable: Hive.box<Patient>('patients').listenable(),
        builder: (context, box, _) {
          final patients = box.values.toList();
          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              return ListTile(
                title: Text(patient.name),
                subtitle: Text(
                    'Age: ${patient.age} -- Phone: ${patient.phone} -- Date: ${patient.date} -- Amount: ${patient.amount} -- Amount Paid: ${patient.amountPaid}  -- Doctor: ${patient.doctor} -- Care Of: ${patient.careOf}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // showDeleteDialog(context, index);
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
