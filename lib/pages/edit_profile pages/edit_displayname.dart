import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/user_service.dart';
import '../profile_page.dart';
import 'edit_profile_page.dart';

class EditDisplayName extends StatefulWidget {
  const EditDisplayName(
      {Key? key, required this.user, required this.displayName})
      : super(key: key);
  final User user;
  final String displayName;

  @override
  State<EditDisplayName> createState() => _EditDisplayNameState();
}

class _EditDisplayNameState extends State<EditDisplayName> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final newDisplayNameController = TextEditingController();
  final _supabaseClient = UserService();
  User? user;

  void updateDisplayName(String newDisplayName, String oldDisplayName) {
    _supabaseClient.updateDisplayName(newDisplayName, oldDisplayName);
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
            Text('Display Name'),
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
                updateDisplayName(
                    newDisplayNameController.text, widget.displayName);

                user = User(
                    widget.user.id,
                    widget.user.username,
                    widget.user.mobileNo,
                    widget.user.email,
                    newDisplayNameController.text,
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
            controller: newDisplayNameController,
            decoration: InputDecoration(
              hintText: widget.user.displayName,
              helperText: 'Enter your desired display name',
              contentPadding: const EdgeInsets.all(20),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter new display name';
              } else if (value == widget.user.displayName) {
                return 'No change in display name';
              }
              return null;
            }),
      ),
    );
  }
}
