import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../models/user.dart';
import '../../services/user_service.dart';
import '../profile_page.dart';

class EditBio extends StatefulWidget {
  const EditBio({Key? key, required this.user, required this.bio})
      : super(key: key);
  final User user;
  final String bio;

  @override
  State<EditBio> createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final newBioController = TextEditingController();
  final _supabaseClient = UserService();
  User? user;

  void updateBio(String newBio, String oldBio) {
    _supabaseClient.updateBio(newBio, oldBio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Text('Bio'),
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
                updateBio(newBioController.text, widget.bio);

                user = User(
                    widget.user.id,
                    widget.user.username,
                    widget.user.mobileNo,
                    widget.user.email,
                    widget.user.displayName,
                    newBioController.text,
                    widget.user.createTime);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      user: user!,
                    ),
                  ),
                );
              }
            },
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: TextFormField(
            controller: newBioController,
            decoration: InputDecoration(
              hintText: widget.bio,
              helperText: 'Enter your desired biography',
              contentPadding: EdgeInsets.all(20),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter new biography';
              }
              return null;
            }),
      ),
    );
  }
}
