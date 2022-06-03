import 'package:flutter/material.dart';

import './profile_page.dart';
import '../dbhelper.dart';
import '../models/user.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  var dbHelper = DBHelper();
  late String oldPassword, newPassword, confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Your Password'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(user: widget.user),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your old password";
                        }
                        oldPassword = value;
                        return null;
                      },
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Old password',
                        labelText: 'Old password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your new password';
                        }
                        newPassword = value;
                        return null;
                      },
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'New password',
                        labelText: 'New password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        confirmPassword = value;
                        return null;
                      },
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm password',
                        labelText: 'Confirm password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (oldPassword == widget.user.password) {
                            if (newPassword == confirmPassword) {
                              if (oldPassword != newPassword) {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    content: const Text('Confirm changes?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          User newUser = User(
                                              widget.user.id,
                                              widget.user.username,
                                              widget.user.email,
                                              widget.user.mobileNo,
                                              newPassword);
                                          dbHelper.updateUser(newUser);
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfilePage(user: newUser),
                                            ),
                                          );
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'Please change your password'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text('Passwords do not match'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Error'),
                                content:
                                    const Text('Old password is incorrect'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
