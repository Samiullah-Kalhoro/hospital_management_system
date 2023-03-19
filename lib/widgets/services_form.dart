import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/service_appointment.dart';

import '../models/service.dart';
import '../print_logic.dart';

class ServicesForm extends StatefulWidget {
  const ServicesForm({super.key});

  @override
  State<ServicesForm> createState() => _ServicesFormState();
}

class _ServicesFormState extends State<ServicesForm> {
  final PrintLogic printLogic = PrintLogic();
  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'phoneNumber': TextEditingController(),
    'age': TextEditingController(),
    'amount': TextEditingController(),
  };
  int? _tappedTileIndex;

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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final serviceBox = Hive.box<ServiceAppointment>('serviceAppointments');
      final currentDate = DateTime.now();
      final servicesForToday = serviceBox.values.where((s) =>
          DateFormat.yMMMMd('en_US').format(s.serviceAvailedDate) ==
          DateFormat.yMMMMd('en_US').format(currentDate));
      final tokenNumber =
          servicesForToday.isEmpty ? 1 : servicesForToday.length + 1;

      final nextIndex = serviceBox.isEmpty ? 1 : serviceBox.length + 1;

      final serviceAppointment = ServiceAppointment(
        name: _controllers['name']!.text,
        phone: int.parse(_controllers['phoneNumber']!.text),
        age: int.parse(_controllers['age']!.text),
        amount: double.parse(_controllers['amount']!.text),
        serviceAvailedDate: currentDate,
        gender: _selectedGender,
        selectedService: _selectedService,
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
          text: 'Service:',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: _selectedService,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Form(
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Row(
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 300) * .5,
                  child: Column(
                    children: [
                      const Text(
                        'Service Form',
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton(
                            onPressed: () => _submitForm(),
                            child: const Text('Submit'),
                          ),
                        ],
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
                'Today\'s Services',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 300) * .5,
                height: MediaQuery.of(context).size.height - 200,
                child: ValueListenableBuilder<Box<ServiceAppointment>>(
                  valueListenable:
                      Hive.box<ServiceAppointment>('serviceAppointments')
                          .listenable(),
                  builder: (context, box, _) {
                    final today = DateTime.now();
                    final serviceAppointments = box.values
                        .where((service) =>
                            DateFormat.yMMMMd('en_US')
                                .format(service.serviceAvailedDate) ==
                            DateFormat.yMMMMd('en_US').format(today))
                        .toList();

                    return Card(
                      child: ListView.builder(
                        itemCount: serviceAppointments.length,
                        itemBuilder: (context, index) {
                          final service =
                              serviceAppointments.reversed.toList()[index];

                          final isTapped = _tappedTileIndex == index;
                          return ListTile(
                            leading: Text(
                              (service.tokenNumber).toString(),
                              textAlign: TextAlign.center,
                            ),
                            title: Row(
                              children: [
                                SizedBox(
                                    width: 130,
                                    child: Text(
                                      service.name,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15,
                                      ),
                                    )),
                                GestureDetector(
                                    child: Text(
                                      isTapped
                                          ? "0${service.phone}"
                                          : 'Tap to show number',
                                      style: TextStyle(
                                        color: isTapped
                                            ? Colors.white60
                                            : Colors.white60,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        if (_tappedTileIndex == index) {
                                          // hide phone number if already tapped
                                          _tappedTileIndex = null;
                                        } else {
                                          // show phone number of tapped tile
                                          _tappedTileIndex = index;
                                        }
                                      });
                                    }),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 60,
                              child: Text(
                                service.amount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(service.selectedService),
                                const SizedBox(width: 8.0),
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
