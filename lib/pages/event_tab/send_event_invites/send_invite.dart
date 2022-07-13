import 'package:flutter/material.dart';
import 'package:gaigai_planner/models/event_details.dart';
import 'package:gaigai_planner/models/user.dart';
import 'package:gaigai_planner/pages/event_tab/send_event_invites/send_event_invite.dart';
import 'package:gaigai_planner/pages/home_page.dart';
import 'package:gaigai_planner/services/user_service.dart';
import 'package:gaigai_planner/services/invite_service.dart';

class SendInvite extends StatefulWidget {
  SendInvite(
      {Key? key,
      required this.uninvited,
      required this.invited,
      required this.friends,
      required this.event,
      required this.user})
      : super(key: key);
  List<Map<String, String>> uninvited;
  List<Map<String, String>> invited;
  List<Map<String, String>> friends;
  final User user;
  final EventDetails event;

  @override
  State<SendInvite> createState() => _SendInviteState();
}

class _SendInviteState extends State<SendInvite>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _userService = UserService();
  final _inviteService = InviteService();
  String dropdownValue = 'Username';
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  bool containsID(String id) {
    for (Map<String, String> map in widget.invited) {
      if (map['id'] == id) {
        return true;
      }
    }
    return false;
  }

  void inviteFriend(String value, bool name) async {
    bool exists;

    if (value == widget.user.username || value == widget.user.mobileNo) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('You cannot invite yourself.'),
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
      if (dropdownValue == 'Username') {
        exists = !(await _userService.uniqueUsername(value));
      } else {
        exists = !(await _userService.uniqueNumber(value));
      }
      if (!exists) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Error'),
            content: value == ''
                ? Text('Please enter the $dropdownValue')
                : SizedBox(
                    height: 50,
                    child: Column(
                      children: [
                        const Text('Cannot find user with'),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('$dropdownValue: $value'),
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
        //check whether this person is in invited
        String id = (await _inviteService.getID(value, name))!;
        if (containsID(id)) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Error'),
              content: const Text('This person is already invited.'),
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
          String displayName = (await _inviteService.getDisplayName(id))!;
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Success'),
              content: const Text('This person is invited.'),
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
          setState(() {
            widget.invited.add({'display_name': displayName, 'id': id});
          });
        }
      }
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Send Event Invites'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SendEventInvite(
                event: widget.event,
                user: widget.user,
                friends: widget.friends,
                invited: widget.invited,
                uninvited: widget.uninvited,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _inviteService.sendEventInvite(
                    widget.user.id, widget.event.eventID, widget.invited);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(user: widget.user),
                  ),
                );
              },
              icon: const Icon(Icons.check))
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: 'Search',
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Add by '),
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
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => inviteFriend(
                            _controller.text, dropdownValue == 'Username'),
                        child: const Text('Invite'),
                      ),
                    ),
                  ],
                ),
              ],
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
                        const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        widget.invited.remove(e);
                        if (widget.friends.contains(e)) {
                          widget.uninvited.add(e);
                        }
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
