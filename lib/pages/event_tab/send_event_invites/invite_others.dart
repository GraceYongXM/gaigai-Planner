import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gaigai_planner/services/invite_service.dart';

import '../../../models/event_details.dart';
import '../../../models/user.dart';
import '../../../services/user_service.dart';

class inviteOthers extends StatefulWidget {
  const inviteOthers({super.key, required this.event, required this.user});
  final EventDetails event;
  final User user;

  @override
  State<inviteOthers> createState() => _inviteOthersState();
}

class _inviteOthersState extends State<inviteOthers> {
  final _controller = TextEditingController();
  final _userService = UserService();
  final _inviteService = InviteService();
  List<User> invitedFriends = [];
  late User friend;

  @override
  void initState() {
    super.initState();
    getInvitedUsers(widget.event.eventID);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  getInvitedUsers(String eventID) async {
    var _invitedFriends = await _inviteService.getInvitedUsers(eventID);
    setState(() {
      invitedFriends = _invitedFriends;
    });
  }

  String dropdownValue = 'Username';
  Future<void> inviteOthers() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Invite others'),
        content: SizedBox(
          height: 110,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Invite by '),
                  DropdownButton(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    items: const [
                      DropdownMenuItem(
                        value: 'Username',
                        child: Text('Username'),
                      ),
                      DropdownMenuItem(
                        value: 'Mobile number',
                        child: Text('Mobile number'),
                      ),
                    ],
                    onChanged: (String? value) async {
                      setState(() {
                        dropdownValue = value!;
                      });
                      Navigator.pop(context);
                      await inviteOthers();
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 210,
                    height: 50,
                    child: TextField(
                      controller: _controller,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: dropdownValue == 'Username'
                            ? 'Username'
                            : 'Mobile number',
                        labelText: dropdownValue == 'Username'
                            ? 'Username'
                            : 'Mobile number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _controller.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              bool exists;

              bool inviteExists;
              String text = _controller.text;

              if (dropdownValue == 'Username') {
                exists = !(await _userService.uniqueUsername(text));
              } else {
                exists = !(await _userService.uniqueNumber(text));
              }
              if (!exists) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Error'),
                    content: text == ''
                        ? Text('Please enter the $dropdownValue')
                        : SizedBox(
                            height: 50,
                            child: Column(
                              children: [
                                const Text('Cannot find user with'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('$dropdownValue: $text'),
                              ],
                            ),
                          ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else {
                inviteExists = dropdownValue == 'Username'
                    ? await _inviteService.inviteExists(
                        eventID: widget.event.eventID, username: text)
                    : await _inviteService.inviteExists(
                        eventID: widget.event.eventID, mobileNo: text);
                if (inviteExists) {
                  Navigator.pop(context);
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Error'),
                      content: const Text('You have sent the invite.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  late bool invitedSent;
                  if (dropdownValue == 'Username') {
                    invitedSent = await sendEventInvite(username: text);
                  } else {
                    invitedSent = await sendEventInvite(mobileNo: text);
                  }
                  log('invitedSent: $invitedSent');
                  if (invitedSent) {
                    var _invitedFriends =
                        await getInvitedUsers(widget.event.eventID);
                    setState(() {
                      invitedFriends = _invitedFriends;
                    });
                    Navigator.pop(context);
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Success'),
                        content: const Text('You have sent the invite.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                }
              }
              _controller.clear();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool> sendEventInvite({String? username, String? mobileNo}) async {
    late String userID;
    if (username != null) {
      userID = (await _inviteService.fromUsernameToFriend(username))[0].id;
    } else if (mobileNo != null) {
      userID = (await _inviteService.fromMobileNoToFriend(mobileNo))[0].id;
    }

    _inviteService.sendEventInvite(
        userID, widget.event.eventID, widget.user.id, 'pending');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: invitedFriends.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('You have not invited others.',
                        style: TextStyle(fontSize: 18)),
                    TextButton(
                      onPressed: inviteOthers,
                      child: const Text(
                        'Invite others',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                )
              : Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'You have invited',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: invitedFriends.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(invitedFriends[index].displayName),
                        );
                      },
                    ),
                  ],
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: inviteOthers,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
