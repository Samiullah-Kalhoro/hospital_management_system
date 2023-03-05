import 'package:flutter/material.dart';

import 'doctors_list.dart';
import 'patients_list.dart';
import 'services_availed.dart';
import 'services_list.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Doctors',
            ),
            Tab(
              text: 'Services',
            ),
            Tab(
              text: 'Patients Appointed',
            ),
            Tab(
              text: 'Services Availed',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DoctorListScreen(),
          ServicesListScreen(),
          PatientsList(),
          ServicesAvailed(),
        ],
      ),
    );
  }
}
