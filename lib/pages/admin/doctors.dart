import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/doctor.dart';

class Doctors extends StatefulWidget {
  const Doctors({super.key});

  @override
  State<Doctors> createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specializationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  late String _selectedGender;
  final List<String> _gender = ['Male', 'Female'];

  void _resetFields() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _specializationController.clear();
    _phoneController.clear();
    _emailController.clear();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final box = Hive.box<Doctor>('doctors');
      final nextIndex = box.length;
      final doctor = Doctor(
        name: _nameController.text,
        specialization: _specializationController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        gender: _selectedGender,
        index: nextIndex,
      );

      box.add(doctor);
      _resetFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeFocusTraversal(
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                const Text(
                  'Doctors List',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 300) * .5,
                  height: MediaQuery.of(context).size.height - 200,
                  child: ValueListenableBuilder<Box<Doctor>>(
                    valueListenable: Hive.box<Doctor>('doctors').listenable(),
                    builder: (context, box, _) {
                      return ListView.builder(
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          final doctor = box.getAt(index);

                          return Card(
                            child: ListTile(
                              leading: Text((doctor!.index + 1).toString()),
                              title: Text(doctor.name),
                              subtitle: Text(doctor.specialization),
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
          ),
          Column(
            children: [
              const SizedBox(height: 16.0),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Row(
                  children: [
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 300) * .4,
                      child: Column(
                        children: [
                          const Text(
                            'Add Doctor',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white54,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _specializationController,
                            decoration: const InputDecoration(
                              labelText: 'Specialization',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a specialization';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          DropdownButtonFormField(
                            decoration: const InputDecoration(
                              labelText: 'Select Gender',
                              border: OutlineInputBorder(),
                            ),
                            items: _gender.map((gender) {
                              return DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a gender';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          FilledButton(
                            child: const Text('Save'),
                            onPressed: () {
                              _onSubmit();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Doctor?'),
        content: const Text('Are you sure you want to delete this doctor?'),
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
              deleteDoctor(index);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void deleteDoctor(int index) {
    final box = Hive.box<Doctor>('doctors');
    box.deleteAt(index);

// Update the index property of the remaining doctors
    for (var i = 0; i < box.length; i++) {
      final doctor = box.getAt(i);
      doctor!.index = i;
      doctor.save();
    }
  }
}

