import 'package:flutter/material.dart';

import '../models/user.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
