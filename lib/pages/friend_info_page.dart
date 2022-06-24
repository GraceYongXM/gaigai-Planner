import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/friend_service.dart';
import 'home_page.dart';

class FriendInfoPage extends StatelessWidget {
  FriendInfoPage(
      {Key? key,
      required this.user,
      required this.friendID,
      required this.friendTime,
      required this.displayName,
      required this.mobileNo,
      required this.bio,
      required this.username})
      : super(key: key);
  final DateTime friendTime;
  final User user;
  final String friendID, username, displayName, mobileNo;
  final String? bio;
  final _supabaseClient = FriendService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(username),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                user: user,
                tabIndex: 1,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<String>>[
                const PopupMenuItem<String>(
                  value: 'Delete friend',
                  child: Text('Delete friend'),
                ),
              ];
            },
            onSelected: (String choice) {
              if (choice == 'Delete friend') {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text('Delete friend $displayName?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomePage(
                                user: user,
                              ),
                            ),
                          );
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _supabaseClient.deleteFriend(user.id, friendID);
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                user: user,
                              ),
                            ),
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              title: const Text(
                'Display Name',
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
                'Mobile Number',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                mobileNo,
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
                (bio == null) ? 'nil' : bio!,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Friend Date',
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
