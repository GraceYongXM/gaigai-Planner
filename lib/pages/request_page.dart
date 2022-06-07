import 'package:flutter/material.dart';

import '../models/user.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('You do not have any requests.',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => {},
          backgroundColor: Theme.of(context).colorScheme.primary,
          tooltip: 'Create new request',
          child: const Icon(Icons.person_add)),
    );
  }
}
