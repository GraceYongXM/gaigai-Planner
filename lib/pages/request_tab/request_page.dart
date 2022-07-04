import 'package:flutter/material.dart';
import 'package:gaigai_planner/pages/request_tab/requested_friend_info_page.dart';

import 'event_info_page.dart';
import '../../services/request_service.dart';
import '../../models/user.dart';
import '../../models/friend_request.dart';
import '../../models/event_invitation.dart';
import '../../models/event_details.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _supabaseClient = RequestService();

  List<String> requestIDs = [];
  List<FriendRequest> requests = [];
  List<User> friendInfo = [];

  List<String> eventIDs = [];
  List<EventInvitation> invitations = [];
  List<EventDetails> eventInfo = [];
  List<String> ownerIDs = [];
  List<String> ownerNames = [];

  bool isLoading = false;

  @override
  void initState() {
    isLoading = true;
    getData();
    super.initState();
  }

  void getData() async {
    List<String> _requestIDs =
        await _supabaseClient.getIDsOfRequests(widget.user.id);
    List<FriendRequest> _requests =
        await _supabaseClient.getRequests(widget.user.id);
    List<User> _friendInfo =
        await _supabaseClient.getRequesterInfo(_requestIDs);

    List<String> _eventIDs = await _supabaseClient.getEventIDs(widget.user.id);
    List<EventInvitation> _invitations =
        await _supabaseClient.getInvitations(widget.user.id);
    List<EventDetails> _eventInfo =
        await _supabaseClient.getEventInfo(_eventIDs);
    List<String> _ownerIDs = await _supabaseClient.getOwnerIDs(widget.user.id);
    List<String> _ownerNames = await _supabaseClient.getOwnerNames(_ownerIDs);

    setState(() {
      requestIDs = _requestIDs;
      requests = _requests;
      friendInfo = _friendInfo;

      eventIDs = _eventIDs;
      invitations = _invitations;
      eventInfo = _eventInfo;
      ownerIDs = _ownerIDs;
      ownerNames = _ownerNames;

      isLoading = false;
    });
  }

  void updateRequest(String fromID, int index, bool accepted) async {
    _supabaseClient.updateRequest(
        fromID: fromID, toID: widget.user.id, accepted: accepted);
    setState(() {
      requestIDs.removeAt(index);
      requests.removeAt(index);
      friendInfo.removeAt(index);
    });
  }

  void updateInvitation(String eventID, int index, bool accepted) async {
    _supabaseClient.updateInvitation(
        eventID: eventID, userID: widget.user.id, accepted: accepted);
    setState(() {
      eventIDs.removeAt(index);
      invitations.removeAt(index);
      eventInfo.removeAt(index);
      ownerIDs.removeAt(index);
      ownerNames.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  ExpansionTile(
                    tilePadding: const EdgeInsets.all(10),
                    title: Text(
                      'Friend Requests: ${requestIDs.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textColor: Colors.black,
                    iconColor: Colors.black,
                    initiallyExpanded: true,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RequestedFriendInfoPage(
                                      requestDate: requests[index].requestDate,
                                      displayName:
                                          friendInfo[index].displayName,
                                      username: friendInfo[index].username,
                                    ),
                                  ),
                                );
                              },
                              title: Text(friendInfo[index].displayName),
                              subtitle: Text(requests[index]
                                  .requestDate
                                  .toIso8601String()
                                  .substring(0, 10)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      updateRequest(
                                          requestIDs[index], index, true);
                                    },
                                    icon: const Icon(Icons.check_rounded),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      updateRequest(
                                          requestIDs[index], index, false);
                                    },
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: friendInfo.length,
                      ),
                    ],
                  ),
                  ExpansionTile(
                    tilePadding: const EdgeInsets.all(10),
                    title: Text(
                      'Event Invitations: ${eventIDs.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textColor: Colors.black,
                    iconColor: Colors.black,
                    initiallyExpanded: true,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EventInfoPage(
                                      requesterName: ownerNames[index],
                                      invitationDate:
                                          invitations[index].requestDate!,
                                      description:
                                          eventInfo[index].description ?? ' ',
                                      name: eventInfo[index].name,
                                    ),
                                  ),
                                );
                              },
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(eventInfo[index].name),
                                ],
                              ),
                              subtitle: Text(invitations[index]
                                  .requestDate!
                                  .toIso8601String()
                                  .substring(0, 10)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      updateInvitation(
                                          eventIDs[index], index, true);
                                    },
                                    icon: const Icon(Icons.check_rounded),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      updateInvitation(
                                          eventIDs[index], index, false);
                                    },
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: eventIDs.length,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
