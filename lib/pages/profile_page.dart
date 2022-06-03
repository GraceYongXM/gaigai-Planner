import 'package:flutter/material.dart';
import 'package:gaigai_planner/pages/edit_profile_page.dart';

import './home_page.dart';
import '../models/user.dart';
import './edit_profile_page.dart';
import './edit_password_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(user: widget.user as User),
            ),
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            tooltip: 'Settings',
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<String>>[
                const PopupMenuItem<String>(
                  value: 'Edit your profile',
                  child: Text('Edit your profile'),
                ),
                const PopupMenuItem<String>(
                  value: 'Change password',
                  child: Text('Change password'),
                ),
              ];
            },
            onSelected: (String choice) {
              if (choice == 'Edit your profile') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(user: widget.user),
                  ),
                );
              } else if (choice == 'Change password') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPasswordPage(user: widget.user),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              title: const Text(
                'Username',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                widget.user.username,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Mobile number',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                widget.user.mobileNo,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Email address',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                widget.user.email,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
