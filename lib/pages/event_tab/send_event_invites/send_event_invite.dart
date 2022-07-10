import 'package:flutter/material.dart';
import 'package:gaigai_planner/models/event_details.dart';
import 'package:gaigai_planner/pages/event_tab/create_event.dart';
import 'package:gaigai_planner/pages/event_tab/send_event_invites/send_invite.dart';

import '../../../models/friend.dart';
import '../../../models/user.dart';

class sendEventInvite extends StatefulWidget {
  sendEventInvite({
    super.key,
    required this.user,
    required this.uninvited,
    required this.invited,
    required this.friends,
    required this.event,
  });
  final User user;
  List<Map<String, String>> uninvited;
  List<Map<String, String>> invited;
  List<Map<String, String>> friends;
  final EventDetails event;

  @override
  State<sendEventInvite> createState() => _sendEventInviteState();
}

class _sendEventInviteState extends State<sendEventInvite>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
        actions: [
          IconButton(
              onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SendInvite(
                          event: widget.event,
                          user: widget.user,
                          friends: widget.friends,
                          uninvited: widget.uninvited,
                          invited: widget.invited))),
              icon: const Icon(Icons.arrow_forward))
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: 'Friends',
            ),
            Tab(
              text: 'Invited',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Scaffold(
            body: ListView(
              children: widget.uninvited.map((e) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(e['display_name']!),
                      onTap: () {
                        setState(() {
                          widget.uninvited.remove(e);
                          widget.invited.add(e);
                        });
                      },
                    ),
                    const Divider(
                      thickness: 1,
                    )
                  ],
                );
              }).toList(),
            ),
          ),
          Scaffold(
              body: ListView(
            children: widget.invited.map((e) {
              return Column(
                children: [
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e['display_name']!),
                        Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        widget.invited.remove(e);
                        widget.uninvited.add(e);
                      });
                    },
                  ),
                  const Divider(
                    thickness: 1,
                  )
                ],
              );
            }).toList(),
          ))
        ],
      ),
    );
  }
}
