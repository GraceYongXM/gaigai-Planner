import 'package:flutter/material.dart';

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
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<String>>[
                const PopupMenuItem<String>(
                  child: Text('Profile'),
                  value: 'Profile',
                ),
                const PopupMenuItem<String>(
                  child: Text('Log out'),
                  value: 'Log out',
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
              }
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Scaffold(
            body: Center(child: const Text('Home Page')),
          ),
          Scaffold(
            body: Center(child: const Text('Friend Page')),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
        tooltip: 'Create new event',
      ),
    );
  }
}
