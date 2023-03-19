import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'admin_credentials.dart';
import 'model/model/admin.dart';
import 'user_credentials.dart';
import 'doctors.dart';
import 'appointments_list.dart';
import 'services_availed.dart';
import 'services.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> with TickerProviderStateMixin {
  late TabController _tabController;
  bool isLogin = false;
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _adminBox = Hive.box<Admin>('admins');

  @override
  void initState() {
    if (_adminBox.values.isEmpty) {
      const userName = 'admin';
      const password = 'admin';
      _adminBox.add(
        Admin(userName: userName, password: password),
      );
    }
    _tabController = TabController(length: 6, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final enteredUsername = _userNameController.text.trim();
    final enteredPassword = _passwordController.text.trim();

    if (_adminBox.values.any((admin) => admin.userName == enteredUsername)) {
      // Retrieve the associated password from the box
      final savedPassword = _adminBox.values
          .firstWhere(
            (admin) => admin.userName == enteredUsername,
          )
          .password;

      // Compare the retrieved password with the entered password
      if (savedPassword == enteredPassword) {
        // User is authenticated, log them in
        setState(() {
          isLogin = true;
        });
      } else {
        // Password does not match, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password does not match'),
            duration: Duration(milliseconds: 700),
          ),
        );
      }
    } else {
      // Username does not exist, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username does not exist'),
          duration: Duration(milliseconds: 700),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isLogin) {
      return Scaffold(
        body: SizedBox(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Admin Panel',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value!.isEmpty
                          ? 'Please enter a username'
                          : value.length < 3
                              ? 'Username must be at least 3 characters long'
                              : null,
                      controller: _userNameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value!.isEmpty
                          ? 'Please enter a password'
                          : value.length < 3
                              ? 'Password must be at least 3 characters long'
                              : null,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      onEditingComplete: () => _login(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _login();
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
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
}
