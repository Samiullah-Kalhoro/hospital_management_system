import 'package:flutter/material.dart';

import 'admin_credentials.dart';
import 'doctors.dart';
import 'appointments_list.dart';
import 'services_availed.dart';
import 'services.dart';
import 'user_credentials.dart';

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
    _tabController = TabController(length: 6, vsync: this);
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
              Tab(
                text: 'Admin Credentials',
              ),
              Tab(
                text: 'User Credentials',
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Doctors(),
          Services(),
          AppointmentsList(),
          ServicesAvailed(),
          AdminCredentials(),
          UserCredentials(),
        ],
      ),
    );
  }
}
