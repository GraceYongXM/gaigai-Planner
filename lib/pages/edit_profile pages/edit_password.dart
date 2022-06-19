import 'dart:developer';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/services.dart';
import '../../signin_signup/login_page.dart';
import '../profile_page.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  User? user;

  Future<void> updatePassword(String newPassword) async {
    final success =
        await Services.of(context).authService.updateUserPassword(newPassword);
    if (success) {
      log('success password update');
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Update password error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(
                title: 'pls remove title',
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Text('Password'),
            SizedBox(
              width: 10,
              height: 10,
            ),
            Icon(Icons.edit),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                updatePassword(newPasswordController.text);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(
                      title: 'wheee',
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: TextFormField(
            controller: newPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              helperText: 'Enter your new password',
              contentPadding: EdgeInsets.all(20),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter new password';
              } else if (value.length < 6) {
                return 'Password should be at least 6 characters';
              }
              return null;
            }),
      ),
    );
  }
}
