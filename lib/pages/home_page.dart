import 'package:flutter/material.dart';

import 'package:gaigai_planner/pages/profile_page.dart';
import '../services/services.dart';
import 'event/event_page.dart';
import './friend_page.dart';
import './request_page.dart';
import '../models/user.dart';
import 'signin_signup/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  void _signOut() async {
    await Services.of(context).authService.signOut();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Successfully signed out.')));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(title: 'Login UI'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Gaigai Planner',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.home_rounded),
              text: 'Events',
            ),
            Tab(
              icon: Icon(Icons.people_alt_outlined),
              text: 'Friends',
            ),
            Tab(
              icon: Icon(Icons.mail),
              text: 'Requests',
            ),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            tooltip: 'Settings',
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<String>>[
                const PopupMenuItem<String>(
                  value: 'Profile',
                  child: Text('Profile'),
                ),
                const PopupMenuItem<String>(
                  value: 'Log out',
                  child: Text('Log out'),
                ),
              ];
            },
            onSelected: (String choice) {
              if (choice == 'Log out') {
                _signOut();
              } else if (choice == 'Profile') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(user: widget.user),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          EventPage(user: widget.user),
          FriendPage(user: widget.user),
          RequestPage(user: widget.user),
        ],
      ),
    );
  }
}
