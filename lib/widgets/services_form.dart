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
  final _formKey = GlobalKey<FormState>();

  final List<String> _gender = ['Male', 'Female'];
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _ageController = TextEditingController();
  final _amountController = TextEditingController();
  late String _selectedGender;
  late String _selectedService;

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: (MediaQuery.of(context).size.width - 300) * .7,
              height: (MediaQuery.of(context).size.height) * .7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration:
                              const InputDecoration(labelText: 'Patient Name'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter patient\' name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Age'),
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
                          decoration:
                              const InputDecoration(labelText: 'Select Gender'),
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
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration:
                              const InputDecoration(labelText: 'Phone Number'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
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
                              labelText: 'Select Service'),
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
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _amountController,
                          decoration:
                              const InputDecoration(labelText: 'Amount'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Amount!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 16.0,
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
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            final serviceAppointment = ServiceAppointment(
                              name: _nameController.text,
                              phone: int.parse(_phoneNumberController.text),
                              age: int.parse(_ageController.text),
                              amount: double.parse(_amountController.text),
                              serviceAvailedDate: DateTime.now(),
                              gender: _selectedGender,
                              selectedService: _selectedService,
                            );
                            final box = Hive.box<ServiceAppointment>(
                                'serviceAppointments');
                            box.add(serviceAppointment);
                            resetFields();
                          }
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

  void resetFields() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _phoneNumberController.clear();
    _ageController.clear();
    _amountController.clear();
  }
}
