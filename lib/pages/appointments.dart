import 'package:flutter/material.dart';
import 'package:hospital_management_system/widgets/appointment_form.dart';

import '../widgets/services_form.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'Patient Appointment',
              ),
              Tab(
                text: 'Services',
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AppointmentForm(),
          ServicesForm(),
        ],
      ),
    );
  }
}
