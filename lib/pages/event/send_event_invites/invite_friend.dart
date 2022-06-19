import 'package:flutter/material.dart';

import '../../../models/friend.dart';
import '../../../models/user.dart';

class inviteFriend extends StatefulWidget {
  const inviteFriend(
      {super.key,
      required this.user,
      required this.friendIDs,
      required this.friends,
      required this.friendInfo});
  final User user;
  final List<String> friendIDs;
  final List<Friend> friends;
  final List<User> friendInfo;

  @override
  State<inviteFriend> createState() => _inviteFriendState();
}

class _inviteFriendState extends State<inviteFriend> {
  List<Friend> friendInvited = [];

  sendEventInvite() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.friendIDs.length,
          itemBuilder: (BuildContext context, int index) {
            if (!friendInvited.contains(widget.friends[index])) {
              return ListTile(
                title: Text(widget.friendInfo[index].displayName),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      // sent event invite
                      onPressed: sendEventInvite,
                      icon: const Icon(
                        Icons.check_rounded,
                        color: Colors.green,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Text('hi');
            }
          },
        ),
      ),
    );
  }
}
