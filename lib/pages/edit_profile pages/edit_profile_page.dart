import 'package:flutter/material.dart';
import 'package:gaigai_planner/pages/edit_profile%20pages/edit_bio.dart';
import 'package:gaigai_planner/pages/edit_profile%20pages/edit_displayname.dart';
import 'package:gaigai_planner/pages/login_page.dart';

import '../../models/user.dart';
import 'edit_email.dart';
import 'edit_username.dart';

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
                child: Text('Username'),
                margin: EdgeInsets.fromLTRB(20, 30, 20, 20),
              ),
              Container(
                child: GestureDetector(
                  child: Text(widget.user.username),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUsername(
                          user: widget.user, username: widget.user.username),
                    ),
                  ),
                ),
                margin: EdgeInsets.fromLTRB(10, 30, 20, 20),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              Container(
                child: Text('Display Name'),
                margin: EdgeInsets.all(20),
              ),
              Container(
                child: GestureDetector(
                  child: Text(widget.displayName),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDisplayName(
                        user: widget.user,
                        displayName: widget.displayName,
                      ),
                    ),
                  ),
                ),
                margin: EdgeInsets.fromLTRB(10, 20, 20, 20),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              Container(
                child: Text('Mobile Number'),
                margin: EdgeInsets.all(20),
              ),
              Container(
                child: GestureDetector(
                  child: Text(widget.user.mobileNo),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        title: 'hi',
                      ),
                    ),
                  ),
                ),
                margin: EdgeInsets.fromLTRB(10, 20, 20, 20),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              Container(
                child: Text(
                  'Email',
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.all(20),
              ),
              Container(
                child: GestureDetector(
                  child: Text(widget.user.email),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditEmail(user: widget.user),
                    ),
                  ),
                ),
                margin: EdgeInsets.fromLTRB(10, 20, 20, 20),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              Container(
                child: Text('Bio'),
                margin: EdgeInsets.all(20),
              ),
              Container(
                child: GestureDetector(
                  child: Text(widget.bio),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditBio(user: widget.user, bio: widget.bio)),
                  ),
                ),
                margin: EdgeInsets.fromLTRB(10, 20, 20, 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
