import 'package:flutter/material.dart';

import '../../../models/friend.dart';
import '../../../models/user.dart';
import '../../../services/friend_service.dart';
import 'invite_friend.dart';
import 'invite_others.dart';

class sendEventInvite extends StatefulWidget {
  const sendEventInvite(
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
  State<sendEventInvite> createState() => _sendEventInviteState();
}

class _sendEventInviteState extends State<sendEventInvite>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _supabaseClient = FriendService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Send Event Invites'),
        bottom: TabBar(
          controller: _tabController,
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
        controller: _tabController,
        children: <Widget>[
          inviteFriend(
            user: widget.user,
            friendIDs: widget.friendIDs,
            friends: widget.friends,
            friendInfo: widget.friendInfo,
          ),
          inviteOthers(),
        ],
      ),
    );
  }
}
