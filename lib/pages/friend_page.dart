import 'package:flutter/material.dart';

import 'package:gaigai_planner/pages/friend_info_page.dart';
import 'package:gaigai_planner/services/friend_service.dart';
import 'package:gaigai_planner/services/request_service.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import '../models/friend.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _userService = UserService();
  final _requestService = RequestService();
  final _supabaseClient = FriendService();
  List<String> friendIDs = [];
  List<Friend> friends = [];
  List<User> friendInfo = [];

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getFriends(widget.user.id);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void getFriends(String id) async {
    List<String> _friendIDs = await _supabaseClient.getFriendIDs(id);
    List<Friend> _friends = await _supabaseClient.getFriends(id);
    List<User> _friendInfo = await _supabaseClient.getFriendInfo(_friendIDs);
    setState(() {
      friendIDs = _friendIDs;
      friends = _friends;
      friendInfo = _friendInfo;
    });
  }

  String dropdownValue = 'Username';

  Future<void> sendRequest() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add friend'),
        content: SizedBox(
          height: 110,
          child: Column(
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
                      Navigator.pop(context);
                      await sendRequest();
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
              bool? requestExists;
              bool friendExists;
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
                friendExists = dropdownValue == 'Username'
                    ? await _requestService.friendExists(
                        friendIDs: friendIDs, username: text)
                    : await _requestService.friendExists(
                        friendIDs: friendIDs, mobileNo: text);
                if (friendExists) {
                  Navigator.pop(context);
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Error'),
                      content: const Text('You are already friends.'),
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
                  requestExists = dropdownValue == 'Username'
                      ? await _requestService.requestExists(
                          fromID: widget.user.id, username: text)
                      : await _requestService.requestExists(
                          fromID: widget.user.id, mobileNo: text);
                  if (requestExists == null) {
                    Navigator.pop(context);
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text('You already have the request.'),
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
                  } else if (requestExists == false) {
                    Navigator.pop(context);
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Request is pending.'),
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
                    dropdownValue == 'Username'
                        ? _requestService.insertRequest(
                            fromID: widget.user.id, username: text)
                        : _requestService.insertRequest(
                            fromID: widget.user.id, mobileNo: text);
                    Navigator.pop(context);
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(friendExists ? 'Error' : 'Success'),
                        content: Text(friendExists
                            ? 'You are already friends.'
                            : 'Friend request has been sent!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: (friendIDs.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You have not added any friends.',
                      style: TextStyle(fontSize: 18)),
                  TextButton(
                    onPressed: () async {
                      await sendRequest();
                    },
                    child: const Text(
                      'Add friend',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: friendIDs.length,
                itemBuilder: (BuildContext context, int index) {
                  return FriendTile(
                    user: widget.user,
                    index: index,
                    friendInfo: friendInfo,
                    friends: friends,
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await sendRequest();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        tooltip: 'Add friend',
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

class FriendTile extends StatelessWidget {
  int index;
  User user;
  List<User> friendInfo;
  List<Friend> friends;

  FriendTile(
      {Key? key,
      required this.index,
      required this.user,
      required this.friendInfo,
      required this.friends})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(friendInfo[index].displayName),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FriendInfoPage(
                  user: user,
                  friendID: friendInfo[index].id,
                  friendTime: friends[index].friendTime,
                  displayName: friendInfo[index].displayName,
                  mobileNo: friendInfo[index].mobileNo,
                  bio: friendInfo[index].bio,
                  username: friendInfo[index].username,
                ),
              ),
            );
          },
        ),
        const Divider(
          thickness: 1,
        ),
      ],
    );
  }
}
