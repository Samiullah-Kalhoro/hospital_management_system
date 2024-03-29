import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../authentication/model/user.dart';

class UserCredentials extends StatefulWidget {
  const UserCredentials({super.key});

  @override
  State<UserCredentials> createState() => _UserCredentialsState();
}

class _UserCredentialsState extends State<UserCredentials> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  void _resetFields() {
    _formKey.currentState!.reset();
    _userNameController.clear();
    _passwordController.clear();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final box = Hive.box<User>('users');

      final user = User(
          userName: _userNameController.text.trim(),
          password: _passwordController.text.trim());

      box.add(user);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User added successfully'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 700),
        ),
      );
      _resetFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeFocusTraversal(
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                const Text(
                  'Users List',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 300) * .5,
                  height: MediaQuery.of(context).size.height - 200,
                  child: ValueListenableBuilder<Box<User>>(
                    valueListenable: Hive.box<User>('users').listenable(),
                    builder: (context, box, _) {
                      return box.values.isEmpty
                          ? const Center(
                              child: Text(
                                "No users found! \nPlease add an user.",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              itemCount: box.length,
                              itemBuilder: (context, index) {
                                final user = box.getAt(index);

                                return Card(
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        const Text(
                                          'Username: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          user!.userName,
                                        ),
                                        const SizedBox(width: 16.0),
                                        const Text(
                                          'Password: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          user.password,
                                        ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            showEditDialog(context, index);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            showDeleteDialog(context, index);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 16.0),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Row(
                  children: [
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 300) * .4,
                      child: Column(
                        children: [
                          const Text(
                            'Add User',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white54,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _userNameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          FilledButton(
                            child: const Text('Save'),
                            onPressed: () {
                              _onSubmit();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User?'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              deleteUser(index);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User Deleted!'),
                  duration: Duration(milliseconds: 700),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void showEditDialog(BuildContext context, int index) {
    final user = Hive.box<User>('users').getAt(index);
    final userNameEditController = TextEditingController()
      ..text = user!.userName;
    final passwordEditController = TextEditingController()
      ..text = user.password;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: userNameEditController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: passwordEditController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an password';
                }
                return null;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              editUser(index, userNameEditController, passwordEditController);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void deleteUser(int index) {
    final box = Hive.box<User>('users');

    box.deleteAt(index);
  }

  void editUser(int index, TextEditingController userNameEditController,
      TextEditingController passwordEditController) {
    final box = Hive.box<User>('users');

    final user = User(
        userName: userNameEditController.text,
        password: passwordEditController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Changes saved!'),
        duration: Duration(milliseconds: 700),
      ),
    );

    box.putAt(index, user);
  }
}
