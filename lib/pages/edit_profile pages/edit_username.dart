import 'package:flutter/material.dart';
import 'package:gaigai_planner/pages/edit_profile%20pages/edit_profile_page.dart';
import 'package:gaigai_planner/pages/profile_page.dart';

import '../../models/user.dart';
import '../../services/user_service.dart';

class EditUsername extends StatefulWidget {
  const EditUsername({Key? key, required this.username, required this.user})
      : super(key: key);
  final User user;
  final String username;

  @override
  State<EditUsername> createState() => _EditUsernameState();
}

class _EditUsernameState extends State<EditUsername> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final newUsernameController = TextEditingController();
  final _supabaseClient = UserService();
  User? user;
  late bool isUnique;

  void updateUsername(String newUsername, String oldUsername) {
    _supabaseClient.updateUsername(newUsername, oldUsername);
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
            Text('Username'),
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
                updateUsername(
                    newUsernameController.text, widget.user.username);

                user = User(
                    widget.user.id,
                    newUsernameController.text,
                    widget.user.mobileNo,
                    widget.user.email,
                    widget.user.displayName,
                    widget.user.bio,
                    widget.user.createTime);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      user: user!,
                      tabIndex: 0,
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
            controller: newUsernameController,
            decoration: InputDecoration(
              hintText: widget.username,
              helperText: 'Enter your desired username',
              contentPadding: const EdgeInsets.all(20),
            ),
            onChanged: (text) async {
              var isUniqueAsync = await _supabaseClient.uniqueUsername(text);
              setState(() {
                isUnique = isUniqueAsync;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter new username';
              } else if (value == widget.username) {
                return 'No change in username';
              } else if (!isUnique) {
                return 'Username is taken';
              }
              return null;
            }),
      ),
    );
  }
}
