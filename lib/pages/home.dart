import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:window_manager/window_manager.dart';

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
  void initState() {
    windowManager.maximize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // use SizedBox to constrain the AppMenu to a fixed width
        SizedBox(
          width: 200,
          child: ExcludeFocusTraversal(
            child: Drawer(
              shape: const ContinuousRectangleBorder(),
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  DrawerHeader(
                    child: Image.asset(
                      "assets/images/amc.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  ListTile(
                    selectedColor: Theme.of(context).colorScheme.secondary,
                    style: ListTileStyle.drawer,
                    horizontalTitleGap: 1,
                    leading: const Icon(Icons.home),
                    title: const Text('Dashboard'),
                    selected: _selectedIndex == 0,
                    onTap: () => _onPageTap(0),
                  ),
                  ListTile(
                    selectedColor: Theme.of(context).colorScheme.secondary,
                    style: ListTileStyle.drawer,
                    horizontalTitleGap: 1,
                    leading: const Icon(Ionicons.pencil),
                    title: const Text('Appointments'),
                    selected: _selectedIndex == 1,
                    onTap: () => _onPageTap(1),
                  ),
                  ListTile(
                    selectedColor: Theme.of(context).colorScheme.secondary,
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
          ),
        ),
        // vertical black line as separator
        // Container(width: 0.5, color: Colors.black),
        // use Expanded to take up the remaining horizontal space
        Expanded(
          child: pages.elementAt(_selectedIndex),
        ),
      ],
    );
  }
}
