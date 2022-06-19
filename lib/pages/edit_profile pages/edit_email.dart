import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gaigai_planner/signin_signup/login_page.dart';

import '../../models/user.dart';
import '../../services/services.dart';
import '../../services/user_service.dart';
import '../profile_page.dart';
import 'edit_profile_page.dart';

class EditEmail extends StatefulWidget {
  const EditEmail({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<EditEmail> createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final newEmailController = TextEditingController();
  final _supabaseClient = UserService();
  User? user;
  late bool isUnique;

  Future<void> updateEmail(String newEmail, String oldEmail) async {
    final success =
        await Services.of(context).authService.updateUserEmail(newEmail);
    if (success) {
      log('success email update');
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Update email error')));
    }
    _supabaseClient.updateEmail(newEmail, oldEmail);
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
              builder: (context) => EditProfilePage(
                user: widget.user,
                displayName: widget.user.displayName,
                bio: widget.user.bio,
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Text('Email'),
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
                updateEmail(newEmailController.text, widget.user.email);

                user = User(
                    widget.user.id,
                    widget.user.username,
                    widget.user.mobileNo,
                    newEmailController.text,
                    widget.user.displayName,
                    widget.user.bio,
                    widget.user.createTime);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(
                      title: 'hi',
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
            controller: newEmailController,
            decoration: InputDecoration(
              hintText: widget.user.email,
              helperText: 'Enter your new email',
              contentPadding: EdgeInsets.all(20),
            ),
            onChanged: (text) async {
              var isUniqueAsync = await _supabaseClient.uniqueEmail(text);
              setState(() {
                isUnique = isUniqueAsync;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter new email';
              } else if (!EmailValidator.validate(value)) {
                return 'Please enter a valid email';
              } else if (value == widget.user.email) {
                return 'No change in email';
              } else if (!isUnique) {
                return 'Email is taken';
              }
              return null;
            }),
      ),
    );
  }
}
