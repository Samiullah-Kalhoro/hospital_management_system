import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';

import '../models/doctor.dart';
import '../models/patient.dart';

class AppointmentForm extends StatefulWidget {
  const AppointmentForm({super.key});

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final _ageController = TextEditingController();
  final _amountController = TextEditingController();
  final _amountPaidController = TextEditingController();
  final _careOfController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final List<String> _gender = ['Male', 'Female'];
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _reasonController = TextEditingController();
  // DateTime? _selectedDate;
  late String _selectedDoctor;

  late String _selectedGender;
  // TimeOfDay? _selectedTime;

  // functions for selecting date and time
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime.now(),
  //       lastDate: DateTime(2100));
  //   if (picked != null) {
  //     setState(() {
  //       _selectedDate = picked;
  //     });
  //   }
  // }

  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? picked =
  //       await showTimePicker(context: context, initialTime: TimeOfDay.now());
  //   if (picked != null) {
  //     setState(() {
  //       _selectedTime = picked;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final doctorsBox = Hive.box<Doctor>('doctors');
    final List<String> doctorNames =
        doctorsBox.values.map((e) => e.name).toList();

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
                          decoration:
                              const InputDecoration(labelText: 'Select Doctor'),
                          items: doctorNames.map((doctor) {
                            return DropdownMenuItem(
                              value: doctor,
                              child: Text(doctor),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a doctor';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _selectedDoctor = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          controller: _careOfController,
                          keyboardType: TextInputType.name,
                          decoration:
                              const InputDecoration(labelText: 'Care of'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _reasonController,
                          keyboardType: TextInputType.name,
                          decoration:
                              const InputDecoration(labelText: 'Reason'),
                        ),
                      ),
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
                      Expanded(
                        child: TextFormField(
                          controller: _amountPaidController,
                          decoration:
                              const InputDecoration(labelText: 'Amount Paid'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Paid Amount!';
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
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            final patient = Patient(
                              name: _nameController.text,
                              phone: int.parse(_phoneNumberController.text),
                              age: int.parse(_ageController.text),
                              amount: double.parse(_amountController.text),
                              amountPaid:
                                  double.parse(_amountPaidController.text),
                              careOf: _careOfController.text,
                              appointmentDate: DateFormat.yMMMMd('en_US').format(DateTime.now()),
                              doctor: _selectedDoctor,
                              gender: _selectedGender,
                              reason: _reasonController.text,
                            );
                            final box = Hive.box<Patient>('patients');
                            box.add(patient);
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
}
