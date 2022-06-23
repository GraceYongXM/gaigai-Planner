import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../models/user.dart';
import '../../services/user_service.dart';
import '../profile_page.dart';
import 'edit_profile_page.dart';

class EditMobileNo extends StatefulWidget {
  const EditMobileNo({super.key, required this.user});
  final User user;

  @override
  State<EditMobileNo> createState() => _EditMobileNoState();
}

class _EditMobileNoState extends State<EditMobileNo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final newMobileNoController = TextEditingController();
  final _supabaseClient = UserService();
  User? user;
  late bool isUnique;

  void updateMobileNo(String newMobileNo, String oldMobileNo) {
    _supabaseClient.updateMobileNo(newMobileNo, oldMobileNo);
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
            Text('Mobile Number'),
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
                updateMobileNo(
                    newMobileNoController.text, widget.user.mobileNo);

                user = User(
                    widget.user.id,
                    widget.user.username,
                    newMobileNoController.text,
                    widget.user.email,
                    widget.user.displayName,
                    widget.user.bio,
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
            controller: newMobileNoController,
            decoration: InputDecoration(
              hintText: widget.user.mobileNo,
              helperText: 'Enter your new mobile number',
              contentPadding: EdgeInsets.all(20),
            ),
            onChanged: (text) async {
              var isUniqueAsync = await _supabaseClient.uniqueNumber(text);
              setState(() {
                isUnique = isUniqueAsync;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter new mobile number';
              } else if (value.length != 8) {
                return "Please enter a valid number";
              } else if (value == widget.user.mobileNo) {
                return 'No change in mobile number';
              } else if (!isUnique) {
                return 'Mobile number is taken';
              }
              return null;
            }),
      ),
    );
  }
}
