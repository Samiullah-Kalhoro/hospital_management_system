import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hospital_management_system/authentication/model/user.dart';

import '../pages/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _userBox = Hive.box<User>('users');

  @override
  void initState() {
    if (_userBox.values.isEmpty) {
      const userName = 'admin';
      const password = 'admin';
      _userBox.add(
        User(userName: userName, password: password),
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final enteredUsername = _userNameController.text.trim();
    final enteredPassword = _passwordController.text.trim();

    if (_userBox.values.any((user) => user.userName == enteredUsername)) {
      // Retrieve the associated password from the box
      final savedPassword = _userBox.values
          .firstWhere(
            (user) => user.userName == enteredUsername,
          )
          .password;

      // Compare the retrieved password with the entered password
      if (savedPassword == enteredPassword) {
        // User is authenticated, log them in
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Home(),
        ));
      } else {
        // Password does not match, show an error message
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
    return Scaffold(
      body: SizedBox(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to Asha Medical Centre',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white60,
                  ),
                ),
                Image.asset(
                  'assets/images/amc.png',
                  width: 300,
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
  }
}
