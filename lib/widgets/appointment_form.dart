import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

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
  final List<String> _doctors = [
    'Dr. Sami',
    'Dr. Umesh',
    'Dr. Yasir',
    'Dr. Babar',
    'Dr. Talha',
    'Dr. Mubashir',
    'Dr. Inayat'
  ];

  final _formKey = GlobalKey<FormState>();
  final List<String> _gender = ['Male', 'Female'];
  late final _genderController = TextEditingController(text: _selectedGender);
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedDoctor = '';
  late final _selectedDoctorController =
      TextEditingController(text: _selectedDoctor);

  String _selectedGender = 'Male';
  TimeOfDay? _selectedTime;

  // functions for selecting date and time
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: (MediaQuery.of(context).size.width - 300) * .7,
              height: (MediaQuery.of(context).size.height) * .8,
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
                          items: _doctors.map((doctor) {
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
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Selected Date: ${_selectedDate == null ? 'No date selected' : DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            child: const Text('Select Date'),
                            onPressed: () => _selectDate(context),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        children: [
                          Text(
                            'Selected Time: ${_selectedTime == null ? 'No time selected' : _selectedTime!.format(context)}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            child: const Text('Select Time'),
                            onPressed: () => _selectTime(context),
                          ),
                        ],
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
                              date: _selectedDate!,
                              time: _selectedTime!.toString(),
                              doctor: _selectedDoctorController.text,
                              gender: _genderController.text,
                            );
                            final box = Hive.box<Patient>('patients');
                            box.add(patient);
                            // Navigator.pop(context);
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
