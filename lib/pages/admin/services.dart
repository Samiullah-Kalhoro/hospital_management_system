import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/service.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: 'Service Name',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20),
              FilledButton(
                child: const Text('Add Service'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final box = Hive.box<Service>('service');

                    final nextIndex = box.length;
                    final service = Service(
                      serviceName: _nameController.text,
                      index: nextIndex,
                    );
                    box.add(service);
                    _nameController.clear();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.4,
            child: ValueListenableBuilder<Box<Service>>(
              valueListenable: Hive.box<Service>('service').listenable(),
              builder: (context, box, _) {
                return box.values.isEmpty
                    ? const Center(
                        child: Text(
                          'Nothing to Show',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 24,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          final service = box.getAt(index);

                          return Card(
                            child: ListTile(
                              leading: Text('${service!.index + 1}'),
                              title: Text(service.serviceName),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDeleteDialog(context, index);
                                },
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service?'),
        content: const Text('Are you sure you want to delete this service?'),
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
              deleteService(index);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void deleteService(int index) {
    final box = Hive.box<Service>('service');

    box.deleteAt(index);

    // Update the index property of the remaining services
    for (var i = 0; i < box.length; i++) {
      final service = box.getAt(i);
      service!.index = i;
      service.save();
    }
  }
}
