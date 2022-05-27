import 'package:flutter/material.dart';
import 'package:gaigai_planner/profile_page.dart';

import './login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
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
          tabs: <Widget>[
            Tab(icon: Icon(Icons.home_rounded)),
            Tab(icon: Icon(Icons.people_alt_outlined)),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(title: 'Login UI'),
                  ),
                );
              } else if (choice == 'Profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
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
          Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('You have not created any events.',
                      style: TextStyle(fontSize: 18)),
                  TextButton(
                    onPressed: null,
                    child: Text(
                      'Create new event',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => {},
              backgroundColor: Theme.of(context).colorScheme.primary,
              tooltip: 'Create new event',
              child: const Icon(Icons.add),
            ),
          ),
          Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('You have not added any friends.',
                      style: TextStyle(fontSize: 18)),
                  TextButton(
                    onPressed: null,
                    child: Text(
                      'Add friend',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => {},
              backgroundColor: Theme.of(context).colorScheme.primary,
              tooltip: 'Add friend',
              child: const Icon(Icons.person_add),
            ),
          ),
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        backgroundColor: Theme.of(context).colorScheme.primary,
        tooltip: 'Create new event',
        child: const Icon(Icons.add),
      ),*/
    );
  }
}
