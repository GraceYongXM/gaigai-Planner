import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gaigai_planner/models/event_details.dart';
import 'package:gaigai_planner/pages/home_page.dart';
import 'package:gaigai_planner/services/event_service.dart';
import 'package:gaigai_planner/services/invite_service.dart';

import '../../../models/friend.dart';
import '../../../models/user.dart';

class inviteFriend extends StatefulWidget {
  const inviteFriend({
    super.key,
    required this.user,
    required this.friendIDs,
    required this.friends,
    required this.friendInfo,
    required this.event,
    required this.tabController,
  });
  final User user;
  final List<String> friendIDs;
  final List<Friend> friends;
  final List<User> friendInfo;
  final EventDetails event;
  final TabController tabController;

  @override
  State<inviteFriend> createState() => _inviteFriendState();
}

class _inviteFriendState extends State<inviteFriend> {
  final _inviteService = InviteService();
  List<String> friendInvitedIDs = [];

  sendEventInvite(EventDetails event, String friendID) async {
    _inviteService.sendEventInvite(
      friendID,
      event.eventID,
      event.ownerID,
      'pending',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.friendIDs.length,
          itemBuilder: (BuildContext context, int index) {
            if (!friendInvitedIDs.contains(widget.friendIDs[index])) {
              return ListTile(
                title: Text(widget.friendInfo[index].displayName),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      // sent event invite
                      onPressed: () {
                        sendEventInvite(widget.event, widget.friendIDs[index]);
                        setState(() {
                          friendInvitedIDs.add(widget.friendIDs[index]);
                        });
                      },
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
              Future.delayed(Duration.zero, () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text(
                            'Invites have been sent to all your friends!',
                            textAlign: TextAlign.center,
                          ),
                          content: const SizedBox(
                            height: 20,
                            child: Text(
                              'Invite others?',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                widget.tabController.animateTo(1);
                              },
                              child: const Text('Yes'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(user: widget.user),
                                  ),
                                );
                              },
                              child: const Text('No'),
                            ),
                          ],
                        ));
              });
              return ListTile();
            }
          },
        ),
      ),
    );
  }
}
