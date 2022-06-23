import 'package:flutter/material.dart';
import 'package:gaigai_planner/models/event_details.dart';

import '../../../models/friend.dart';
import '../../../models/user.dart';
import 'invite_friend.dart';
import 'invite_others.dart';

class sendEventInvite extends StatefulWidget {
  const sendEventInvite({
    super.key,
    required this.user,
    required this.friendIDs,
    required this.friends,
    required this.friendInfo,
    required this.event,
  });
  final User user;
  final List<String> friendIDs;
  final List<Friend> friends;
  final List<User> friendInfo;
  final EventDetails event;

  @override
  State<sendEventInvite> createState() => _sendEventInviteState();
}

class _sendEventInviteState extends State<sendEventInvite>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Send Event Invites'),
        bottom: TabBar(
          controller: tabController,
          tabs: const <Widget>[
            Tab(
              text: 'Friends',
            ),
            Tab(
              text: 'Other Users',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          inviteFriend(
            user: widget.user,
            friendIDs: widget.friendIDs,
            friends: widget.friends,
            friendInfo: widget.friendInfo,
            event: widget.event,
            tabController: tabController,
          ),
          inviteOthers(
            event: widget.event,
            user: widget.user,
          ),
        ],
      ),
    );
  }
}
