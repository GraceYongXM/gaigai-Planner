import 'package:flutter/material.dart';
import 'package:gaigai_planner/pages/friend_info_page.dart';
import 'package:gaigai_planner/services/friend_service.dart';

import '../models/user.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  final _supabaseClient = FriendService();
  List<String> friendIDs = [];
  List<DateTime> friendTimes = [];
  List<User> friendInfo = [];

  @override
  void initState() {
    super.initState();
    getFriends(widget.user.id);
  }

  void getFriends(String id) async {
    List<String> _friendIDs = await _supabaseClient.getFriendIDs(id);
    List<DateTime> _friendTimes = await _supabaseClient.getFriendTimes(id);
    List<User> _friendInfo = await _supabaseClient.getFriendInfo(friendIDs);
    setState(() {
      friendIDs = _friendIDs;
      friendTimes = _friendTimes;
      friendInfo = _friendInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (friendIDs.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('You have not added any friends.',
                      style: TextStyle(fontSize: 18)),
                  TextButton(
                    onPressed: null,
                    child: Text(
                      'Add friend',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            )
          : ListView.builder(
              itemCount: friendIDs.length,
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                  child: Text(friendInfo[index].displayName!),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendInfoPage(
                          friendTime: friendTimes[index],
                          displayName: friendInfo[index].displayName!,
                          bio: friendInfo[index].bio,
                          username: friendInfo[index].username,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        backgroundColor: Theme.of(context).colorScheme.primary,
        tooltip: 'Add friend',
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
