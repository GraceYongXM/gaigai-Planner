import 'package:flutter/material.dart';

import 'package:gaigai_planner/pages/home_page.dart';
import 'package:gaigai_planner/models/user.dart';
import 'edit_profile pages/edit_password.dart';
import 'edit_profile pages/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.user, required this.tabIndex})
      : super(key: key);
  final User user;
  final int tabIndex;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String displayName(String? displayName) {
    if (displayName == null) return 'Display Name';
    return displayName;
  }

  String bio(String? bio) {
    if (bio == null) return 'Bio';
    return bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.user.username),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomePage(user: widget.user, tabIndex: widget.tabIndex),
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
                    builder: (context) => EditProfilePage(
                      user: widget.user,
                      displayName: displayName(widget.user.displayName),
                      bio: bio(widget.user.bio),
                    ),
                  ),
                );
              } else if (choice == 'Change password') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPassword(user: widget.user),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              title: const Text(
                'Display Name',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                displayName(widget.user.displayName),
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Mobile Number',
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
                'Email Address',
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
            const Divider(),
            ListTile(
              title: const Text(
                'Bio',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                bio(widget.user.bio),
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
