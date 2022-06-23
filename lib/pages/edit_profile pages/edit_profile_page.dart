import 'package:flutter/material.dart';

import 'package:gaigai_planner/pages/profile_page.dart';
import '../../models/user.dart';
import 'edit_email.dart';
import 'edit_username.dart';
import 'package:gaigai_planner/pages/edit_profile%20pages/edit_bio.dart';
import 'package:gaigai_planner/pages/edit_profile%20pages/edit_displayname.dart';
import 'package:gaigai_planner/pages/edit_profile%20pages/edit_mobileNo.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage(
      {Key? key,
      required this.user,
      required this.displayName,
      required this.bio})
      : super(key: key);
  final User user;
  final String displayName, bio;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late String username, email, mobileNo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                user: widget.user,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text('Edit Your Profile'),
      ),
      body: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(150),
          1: IntrinsicColumnWidth(),
        },
        children: [
          TableRow(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: const Text('Username'),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 30, 20, 20),
                child: GestureDetector(
                  child: Text(widget.user.username),
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUsername(
                          user: widget.user, username: widget.user.username),
                    ),
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(20),
                child: const Text('Display Name'),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 20, 20),
                child: GestureDetector(
                  child: Text(widget.displayName),
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDisplayName(
                        user: widget.user,
                        displayName: widget.displayName,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(20),
                child: const Text('Mobile Number'),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 20, 20),
                child: GestureDetector(
                  child: Text(widget.user.mobileNo),
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditMobileNo(
                        user: widget.user,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(20),
                child: const Text(
                  'Email',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 20, 20),
                child: GestureDetector(
                  child: Text(widget.user.email),
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditEmail(user: widget.user),
                    ),
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(20),
                child: const Text('Bio'),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 20, 20),
                child: GestureDetector(
                  child: Text(widget.bio),
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditBio(user: widget.user, bio: widget.bio)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
