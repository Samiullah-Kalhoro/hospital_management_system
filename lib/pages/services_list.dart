import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/service.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  @override
  Widget build(BuildContext context) {
    // final doctorsBox = Hive.box<Doctor>('doctors');
    // final List<String> doctorNames =
    //     doctorsBox.values.map((e) => e.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service List'),
      ),
      body: ValueListenableBuilder<Box<Service>>(
        valueListenable: Hive.box<Service>('service').listenable(),
        builder: (context, box, _) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final service = box.getAt(index);
              final serviceIndex = service!.key;
              return ListTile(
                leading: Text((serviceIndex + 1).toString()),
                title: Text(service.serviceName),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ServicesList(),
            ),
          );
        },
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
  }
}

class ServicesList extends StatefulWidget {
  const ServicesList({super.key});

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final service = Service(
                      serviceName: _nameController.text,
                    );
                    final box = Hive.box<Service>('service');
                    box.add(service);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
