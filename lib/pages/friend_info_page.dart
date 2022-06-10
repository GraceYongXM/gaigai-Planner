import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FriendInfoPage extends StatelessWidget {
  const FriendInfoPage(
      {Key? key,
      required this.friendTime,
      required this.displayName,
      required this.bio,
      required this.username})
      : super(key: key);
  final DateTime friendTime;
  final String username, displayName;
  final String? bio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
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
                'Biography',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                (bio!.isEmpty) ? 'nil' : bio!,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Friend date',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                friendTime.toIso8601String().substring(0, 10),
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
