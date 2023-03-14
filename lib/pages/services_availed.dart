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
        valueListenable:
            Hive.box<ServiceAppointment>('serviceAppointments').listenable(),
        builder: (context, box, _) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final services = box.getAt(index);

              return ListTile(
                leading: Text(services!.index.toString()),
                title: Text(services.selectedService),
                subtitle: Text(
                    'Service Name is ${services.name} and Token Number is ${services.tokenNumber}'),
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
      content:
          const Text('Are you sure you want to delete this Availed Service?'),
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
            deleteAvailedService(index);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

void deleteAvailedService(int index) {
  final box = Hive.box<ServiceAppointment>('serviceAppointments');
  box.deleteAt(index);
  // Update the index property of the remaining services
  for (var i = 0; i < box.length; i++) {
    final service = box.getAt(i);
    service!.index = i;
    service.save();
  }
}
