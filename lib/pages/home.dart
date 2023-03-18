import 'package:flutter/material.dart';
import 'package:hospital_management_system/authentication/login_screen.dart';
import 'package:ionicons/ionicons.dart';

import 'admin/admin_panel.dart';

import 'appointments.dart';
import 'dashboard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<Widget> pages = [
    const Dashboard(),
    const Appointments(),
    const AdminPanel(),
  ];

  int _selectedIndex = 0;

  void _onPageTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: ExcludeFocusTraversal(
            child: Drawer(
              shape: const ContinuousRectangleBorder(),
              child: Column(
                children: [
                  DrawerHeader(
                    child: Image.asset(
                      "assets/images/amc.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        ListTile(
                          selectedColor:
                              Theme.of(context).colorScheme.secondary,
                          style: ListTileStyle.drawer,
                          horizontalTitleGap: 1,
                          leading: const Icon(Icons.home),
                          title: const Text('Dashboard'),
                          selected: _selectedIndex == 0,
                          onTap: () => _onPageTap(0),
                        ),
                        ListTile(
                          selectedColor:
                              Theme.of(context).colorScheme.secondary,
                          style: ListTileStyle.drawer,
                          horizontalTitleGap: 1,
                          leading: const Icon(Ionicons.pencil),
                          title: const Text('Appointments'),
                          selected: _selectedIndex == 1,
                          onTap: () => _onPageTap(1),
                        ),
                        ListTile(
                          selectedColor:
                              Theme.of(context).colorScheme.secondary,
                          style: ListTileStyle.drawer,
                          horizontalTitleGap: 1,
                          leading: const Icon(Icons.admin_panel_settings),
                          title: const Text('Admin Panel'),
                          selected: _selectedIndex == 2,
                          onTap: () => _onPageTap(2),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Divider(),
                      ListTile(
                        selectedColor: Theme.of(context).colorScheme.secondary,
                        style: ListTileStyle.drawer,
                        horizontalTitleGap: 1,
                        leading: const Icon(Icons.logout),
                        title: const Text('Logout'),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Logout'),
                            content:
                                const Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ));
                                },
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: pages.elementAt(_selectedIndex),
        ),
      ],
    );
  }
}
