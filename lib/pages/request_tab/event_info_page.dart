import 'package:flutter/material.dart';

class EventInfoPage extends StatelessWidget {
  const EventInfoPage(
      {Key? key,
      required this.invitationDate,
      required this.description,
      required this.requesterName,
      required this.name})
      : super(key: key);
  final DateTime invitationDate;
  final String name, description, requesterName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'You have been invited by $requesterName!',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Event name',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              name,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Event description',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              description,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Invitation date',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              invitationDate.toIso8601String().substring(0, 10),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
