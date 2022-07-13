import 'package:flutter/material.dart';

import 'self_invitation_info.dart';
import 'package:gaigai_planner/models/event_details.dart';
import 'package:gaigai_planner/models/self_invitation.dart';
import 'package:gaigai_planner/models/user.dart';
import 'package:gaigai_planner/services/event_service.dart';

class EventInvitationsPage extends StatefulWidget {
  const EventInvitationsPage({Key? key, required this.event}) : super(key: key);
  final EventDetails event;

  @override
  State<EventInvitationsPage> createState() => _EventInvitationsPageState();
}

class _EventInvitationsPageState extends State<EventInvitationsPage> {
  final EventService _supabaseClient = EventService();
  bool isLoading = true;
  List<SelfInvitation> selfInvitations = [];
  List<User> invitationInfo = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    List<SelfInvitation> invitations =
        await _supabaseClient.getSelfInvitations(widget.event.eventID);
    List<User> info =
        await _supabaseClient.getInvitationInfo(widget.event.eventID);

    if (this.mounted) {
      setState(() {
        selfInvitations = invitations;
        invitationInfo = info;
        isLoading = false;
      });
    }
  }

  void updateRequest(int index, bool accepted) async {
    _supabaseClient.updateRequest(
        eventID: widget.event.eventID,
        userID: invitationInfo[index].id,
        accepted: accepted,
        invitationID: selfInvitations[index].id);
    setState(() {
      selfInvitations.removeAt(index);
      invitationInfo.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : selfInvitations.isEmpty
              ? const Center(child: Text('No requests'))
              : ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SelfInvitationInfo(
                                requestDate: selfInvitations[index].createTime,
                                displayName: invitationInfo[index].displayName,
                                username: invitationInfo[index].username,
                              ),
                            ),
                          );
                        },
                        title: Text(invitationInfo[index].displayName),
                        subtitle: Text(selfInvitations[index]
                            .createTime
                            .toIso8601String()
                            .substring(0, 10)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                updateRequest(index, true);
                              },
                              icon: const Icon(Icons.check_rounded),
                            ),
                            IconButton(
                              onPressed: () {
                                updateRequest(index, false);
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: selfInvitations.length,
                ),
    );
  }
}
