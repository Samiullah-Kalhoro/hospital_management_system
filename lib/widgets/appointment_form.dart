import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:intl/intl.dart';

import '../models/doctor.dart';
import '../models/appointment.dart';
import 'package:hospital_management_system/print_logic.dart';

class AppointmentForm extends StatefulWidget {
  const AppointmentForm({super.key});

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final PrintLogic printLogic = PrintLogic();

  final Map<String, TextEditingController> _controllers = {
    'age': TextEditingController(),
    'amount': TextEditingController(),
    'careOf': TextEditingController(),
    'name': TextEditingController(),
    'phoneNumber': TextEditingController(),
    'reason': TextEditingController(),
  };

  final _formKey = GlobalKey<FormState>();
  final List<String> _gender = ['Male', 'Female'];
  late String _selectedDoctor;
  late String _selectedGender;

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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final patientBox = Hive.box<Appointment>('patients');
      final currentDate = DateTime.now();
      final patientsForToday = patientBox.values.where((p) =>
          DateFormat.yMMMMd('en_US').format(p.appointmentDate) ==
          DateFormat.yMMMMd('en_US').format(currentDate));
      final tokenNumber =
          patientsForToday.isEmpty ? 1 : patientsForToday.length + 1;

      final nextIndex = patientBox.isEmpty ? 1 : patientBox.length + 1;

      final patient = Appointment(
        name: _controllers['name']!.text,
        phone: int.parse(_controllers['phoneNumber']!.text),
        age: int.parse(_controllers['age']!.text),
        amount: double.parse(_controllers['amount']!.text),
        careOf: _controllers['careOf']!.text,
        appointmentDate: currentDate,
        doctor: _selectedDoctor,
        gender: _selectedGender,
        reason: _controllers['reason']!.text,
        tokenNumber: tokenNumber,
        index: nextIndex,
      );

      final profile = await CapabilityProfile.load(name: 'XP-N160I');
      final generator = Generator(PaperSize.mm80, profile);

      var bytes = generator.setGlobalCodeTable('CP1252');

      bytes += generator.text(
        'Asha Medical Center',
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          fontType: PosFontType.fontA,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );

      bytes += generator.hr();
      bytes += generator.text(
        DateFormat.yMMMMd('en_US').format(DateTime.now()),
        styles: const PosStyles(
          align: PosAlign.left,
          fontType: PosFontType.fontB,
          height: PosTextSize.size1,
        ),
      );
      bytes += generator.text(
        DateFormat.jm().format(DateTime.now()),
        styles: const PosStyles(
          align: PosAlign.left,
          fontType: PosFontType.fontB,
          height: PosTextSize.size1,
        ),
      );
      bytes += generator.hr();

      bytes += generator.row([
        PosColumn(
          text: 'Patient Name:',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: _controllers['name']!.text.toUpperCase(), //name
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
          ),
        ),
      ]);

      bytes += generator.row([
        PosColumn(
          text: 'Gender / Age:',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: '$_selectedGender / ${_controllers['age']!.text}',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
          ),
        ),
      ]);

      bytes += generator.row([
        PosColumn(
          text: 'Contact No:',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: _controllers['phoneNumber']!.text,
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
          ),
        ),
      ]);

      bytes += generator.row([
        PosColumn(
          text: 'Care of:',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: _controllers['careOf']!.text,
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
          ),
        ),
      ]);

      bytes += generator.row([
        PosColumn(
          text: 'Reason:',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: _controllers['reason']!.text,
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
          ),
        ),
      ]);

      bytes += generator.row([
        PosColumn(
          text: 'Doctor Name:',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: _selectedDoctor.toUpperCase(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
            bold: true,
            width: PosTextSize.size2,
          ),
        ),
      ]);

      bytes += generator.hr();

      bytes += generator.row([
        PosColumn(
          text: 'Token No:',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.center,
            fontType: PosFontType.fontA,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            bold: true,
          ),
        ),
        PosColumn(
          text: tokenNumber.toString(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.center,
            fontType: PosFontType.fontA,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            bold: true,
          ),
        ),
      ]);

      bytes += generator.hr();

      bytes += generator.row([
        PosColumn(
          text: 'Charges',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            bold: true,
          ),
        ),
        PosColumn(
          text: _controllers['amount']!.text,
          width: 8,
          styles: const PosStyles(
            align: PosAlign.right,
            fontType: PosFontType.fontA,
            height: PosTextSize.size2,
            width: PosTextSize.size3,
            bold: true,
          ),
        ),
      ]);

      bytes += generator.feed(2);
      bytes += generator.text('AMC',
          styles: const PosStyles(
            align: PosAlign.center,
            fontType: PosFontType.fontA,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            bold: true,
          ));
      bytes += generator.feed(1);
      bytes += generator.text('YOUR HEALTH, OUR PRIORITY',
          styles: const PosStyles(
            align: PosAlign.center,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true,
          ));

      await printLogic.printReceipt(bytes, generator);

      patientBox.add(patient);

      resetFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorsBox = Hive.box<Doctor>('doctors');
    final List<String> doctorNames =
        doctorsBox.values.map((e) => e.name).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 300) * .5,
                  child: Column(
                    children: [
                      const Text(
                        'Appointment Form',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _controllers['name'],
                                keyboardType: TextInputType.name,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _controllers['age'],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Age',
                                    border: OutlineInputBorder()),
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
                      ),
                      const SizedBox(height: 16.0),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                controller: _controllers['phoneNumber'],
                                keyboardType: TextInputType.phone,
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
                      ),
                      const SizedBox(height: 16.0),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Select Doctor',
                                    border: OutlineInputBorder()),
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
                                controller: _controllers['careOf'],
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                    labelText: 'Care of',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _controllers['reason'],
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                    labelText: 'Reason',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: TextFormField(
                                controller: _controllers['amount'],
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                      ),
                      const SizedBox(height: 16.0),
                      FilledButton(
                        child: const Text('Submit'),
                        onPressed: () {
                          _submitForm();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Text(
                'Today\'s Patients',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 300) * .5,
                height: MediaQuery.of(context).size.height - 200,
                child: ValueListenableBuilder<Box<Appointment>>(
                  valueListenable:
                      Hive.box<Appointment>('patients').listenable(),
                  builder: (context, box, _) {
                    final today = DateTime.now();
                    final todayPatients = box.values
                        .where((patient) =>
                            DateFormat.yMMMMd('en_US')
                                .format(patient.appointmentDate) ==
                            DateFormat.yMMMMd('en_US').format(today))
                        .toList();

                    return Card(
                      child: ListView.builder(
                        itemCount: todayPatients.length,
                        itemBuilder: (context, index) {
                          final patient = todayPatients[index];
                          return ListTile(
                            leading: Text((patient.tokenNumber).toString()),
                            title: Text("${patient.name} -- 0${patient.phone}"),
                            trailing: Text(patient.amount.toString()),
                            subtitle: Row(
                              children: [
                                Text(patient.doctor),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
