import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


import '../models/service_appointment.dart';

class ServicesAvailed extends StatefulWidget {
  const ServicesAvailed({super.key});

  @override
  State<ServicesAvailed> createState() => _ServicesAvailedState();
}

class _ServicesAvailedState extends State<ServicesAvailed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services Availed'),
      ),
      body: ValueListenableBuilder<Box<ServiceAppointment>>(
        valueListenable: Hive.box<ServiceAppointment>('serviceAppointments').listenable(),
        builder: (context, box, _) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final services = box.getAt(index);
              final serviceIndex = services!.key;
              return ListTile(
                leading: Text((serviceIndex + 1).toString()),
                title: Text(services.selectedService),
                subtitle: Text(services.name.toString()),
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
      title: const Text('Delete Availed Service?'),
      content: const Text('Are you sure you want to delete this Availed Service?'),
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
  final box = Hive.box<ServiceAppointment>('serviceAppointments');
  box.deleteAt(index);
}
