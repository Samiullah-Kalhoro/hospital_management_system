import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hospital_management_system/models/doctor_info.dart';
import 'package:hospital_management_system/models/appointment.dart';
import 'package:hospital_management_system/models/service_appointment.dart';
import 'package:hospital_management_system/models/service_info.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime? _selectedDate = DateTime.now();

  int numberOfPatients = 0;
  int numberOfServices = 0;

  List<DoctorInfo> doctorInfos = [];

  List<ServiceInfo> services = [];

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onSubmit() async {
    if (_selectedDate == null) {
      // show error message
      return;
    }

    final patientsBox = Hive.box<Appointment>('patients');
    final filteredPatients = patientsBox.values.where((patient) {
      final appointmentDate =
          DateFormat.yMMMMd('en_US').format(patient.appointmentDate);
      final selectedDate = DateFormat.yMMMMd('en_US').format(_selectedDate!);
      return appointmentDate == selectedDate;
    }).toList();

    final doctors = filteredPatients.map((patient) => patient.doctor).toList();

    final servicesBox = Hive.box<ServiceAppointment>('serviceAppointments');
    final filteredServices = servicesBox.values.where((service) {
      final appointmentDate =
          DateFormat.yMMMMd('en_US').format(service.serviceAvailedDate);
      final selectedDate = DateFormat.yMMMMd('en_US').format(_selectedDate!);
      return appointmentDate == selectedDate;
    }).toList();

    final doctorPatientMap = <String, int>{};
    for (final doctor in doctors) {
      doctorPatientMap.update(
        doctor,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    doctorInfos = doctorPatientMap.entries.map((entry) {
      final doctorName = entry.key;
      final patientCount = entry.value;
      return DoctorInfo(
        doctorName: doctorName,
        patientCount: patientCount,
      );
    }).toList();

    final servicesList =
        filteredServices.map((service) => service.selectedService).toList();
    final servicePatientMap = <String, int>{};
    for (final service in servicesList) {
      servicePatientMap.update(
        service,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    services = servicePatientMap.entries.map((entry) {
      final serviceName = entry.key;
      final serviceCount = entry.value;
      return ServiceInfo(
        serviceName: serviceName,
        serviceCount: serviceCount,
      );
    }).toList();

    numberOfPatients = filteredPatients.length;
    numberOfServices = filteredServices.length;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _onSubmit();
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  _onDateSelected(selectedDate);
                }
              },
              child: Text(DateFormat.yMMMMd().format(_selectedDate!)),
            ),
            const Divider(
              color: Colors.white10,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Text(
                      'Total Patients & Services Entertained',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white54,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .3,
                      child: Card(
                        child: ListTile(
                          title: const Text('Total Patients Appointed'),
                          trailing: Text(numberOfPatients.toString()),
                          subtitle:
                              Text(DateFormat.yMMMMd().format(_selectedDate!)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .3,
                      child: Card(
                        child: ListTile(
                          title: const Text('Number of Services Availed'),
                          trailing: Text(numberOfServices.toString()),
                          subtitle:
                              Text(DateFormat.yMMMMd().format(_selectedDate!)),
                        ),
                      ),
                    ),
                    const Text(
                      'Service Wise Patient Count',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white54,
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .3,
                        child: services.isEmpty
                            ? const Center(
                                child: Text(
                                  'No Data Available',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: services.length,
                                itemBuilder: (context, index) {
                                  final service = services[index];
                                  return Card(
                                    child: ListTile(
                                      title: Text(service.serviceName),
                                      trailing:
                                          Text(service.serviceCount.toString()),
                                    ),
                                  );
                                },
                              )),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Doctor Wise Patient Count',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white54,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .3,
                      child: doctorInfos.isEmpty
                          ? const Center(
                              child: Text(
                                'No Data Available',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: doctorInfos.length,
                              itemBuilder: (context, index) {
                                final doctorInfo = doctorInfos[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(doctorInfo.doctorName),
                                    trailing: Text(
                                        doctorInfo.patientCount.toString()),
                                    subtitle: Text(DateFormat.yMMMMd()
                                        .format(_selectedDate!)),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
