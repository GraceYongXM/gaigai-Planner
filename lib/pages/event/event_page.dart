import 'package:flutter/material.dart';
import 'package:gaigai_planner/pages/event/create_event.dart';

import '../../models/user.dart';

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
          children: [
            Text('You have not created any events.',
                style: TextStyle(fontSize: 18)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateEvent(
                      user: widget.user,
                    ),
                  ),
                );
              },
              child: Text(
                'Create new event',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEvent(
                user: widget.user,
              ),
            ),
          )
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        tooltip: 'Create new event',
        child: const Icon(Icons.add),
      ),
    );
  }
}
