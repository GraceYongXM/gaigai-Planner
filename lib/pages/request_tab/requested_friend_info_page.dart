import 'package:flutter/material.dart';

class RequestedFriendInfoPage extends StatelessWidget {
  const RequestedFriendInfoPage(
      {Key? key,
      required this.requestDate,
      required this.displayName,
      required this.username})
      : super(key: key);
  final DateTime requestDate;
  final String username, displayName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          ListTile(
            title: const Text(
              'Username',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              username,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Display name',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              displayName,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Request date',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              requestDate.toIso8601String().substring(0, 10),
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
