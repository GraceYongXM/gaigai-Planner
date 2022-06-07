import 'package:flutter/material.dart';

import '../models/user.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
