import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../models/service_appointment.dart';

class ServicesAvailed extends StatefulWidget {
  const ServicesAvailed({super.key});

  @override
  State<ServicesAvailed> createState() => _ServicesAvailedState();
}

class _ServicesAvailedState extends State<ServicesAvailed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Box<ServiceAppointment>>(
        valueListenable:
            Hive.box<ServiceAppointment>('serviceAppointments').listenable(),
        builder: (context, box, _) {
          return box.values.isEmpty
              ? const Center(
                  child: Text(
                    "No Services Record found!.",
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
                    final services = box.getAt(index);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        child: ListTile(
                          leading: Text(services!.index.toString()),
                          title: Text(services.name),
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
                                    services.age.toString(),
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
                                        .format(services.serviceAvailedDate),
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
                                    '0${services.phone}',
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
                                    '${services.amount}',
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
