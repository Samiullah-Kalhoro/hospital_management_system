import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hospital_management_system/models/service_appointment.dart';

import '../models/service.dart';

class ServicesForm extends StatefulWidget {
  const ServicesForm({super.key});

  @override
  State<ServicesForm> createState() => _ServicesFormState();
}

class _ServicesFormState extends State<ServicesForm> {
  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'phoneNumber': TextEditingController(),
    'age': TextEditingController(),
    'amount': TextEditingController(),
  };

  final _formKey = GlobalKey<FormState>();
  final List<String> _gender = ['Male', 'Female'];
  late String _selectedGender;
  late String _selectedService;

  @override
  void dispose() {
    _controllers.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  void resetFields() {
    _formKey.currentState!.reset();
    _controllers.forEach((key, value) {
      value.clear();
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final serviceBox = Hive.box<ServiceAppointment>('serviceAppointments');
      final currentDate = DateTime.now();
      final servicesForToday =
          serviceBox.values.where((s) => s.serviceAvailedDate == currentDate);
      final tokenNumber =
          servicesForToday.isEmpty ? 1 : servicesForToday.length + 1;

      final serviceAppointment = ServiceAppointment(
        name: _controllers['name']!.text,
        phone: int.parse(_controllers['phoneNumber']!.text),
        age: int.parse(_controllers['age']!.text),
        amount: double.parse(_controllers['amount']!.text),
        serviceAvailedDate: currentDate,
        gender: _selectedGender,
        selectedService: _selectedService,
        tokenNumber: tokenNumber,
      );

      serviceBox.add(serviceAppointment);
      resetFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceBox = Hive.box<Service>('service');
    final List<String> serviceNames =
        serviceBox.values.map((e) => e.serviceName).toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            SizedBox(
              width: (MediaQuery.of(context).size.width - 300) * .5,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _controllers['name'],
                          decoration: const InputDecoration(
                              labelText: 'Patient Name',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            } else if (value.length < 3) {
                              return 'Name must be at least 3 characters';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _controllers['age'],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Age', border: OutlineInputBorder()),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter patient\'s age';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                              labelText: 'Select Gender',
                              border: OutlineInputBorder()),
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
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: _controllers['phoneNumber'],
                          keyboardType: TextInputType.phone,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (!RegExp(r'^0[0-9]{10}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                              labelText: 'Select Service',
                              border: OutlineInputBorder()),
                          items: serviceNames.map((service) {
                            return DropdownMenuItem(
                              value: service,
                              child: Text(service),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a service';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _selectedService = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          controller: _controllers['amount'],
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              labelText: 'Amount',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Amount cannot be empty';
                            }

                            if (double.tryParse(value) == null) {
                              return 'Amount must be a number';
                            }

                            if (double.parse(value) <= 0) {
                              return 'Amount must be greater than zero';
                            }

                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                        child: const Text('Submit'),
                        onPressed: () {
                          _submitForm();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
