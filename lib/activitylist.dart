import 'package:flutter/material.dart';

import './dbhelper.dart';
import './activity.dart';
import './user.dart';

List<Activity> activityList = [];
List<User> userList = [];

class ActivityListPage extends StatefulWidget {
  const ActivityListPage({Key? key}) : super(key: key);

  @override
  State<ActivityListPage> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    var dbHelper = DBHelper();
    List<Activity> _activityList = await dbHelper.getActivity();
    List<User> _userList = await dbHelper.getUsers();
    setState(() {
      activityList = _activityList;
      userList = _userList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity List!'),
      ),
      body: Container(
        child: Text('activityList.length: ' + activityList.length.toString()),
      ),
    );
  }
}

/* child: Text('activityList.length: ' + activityList.length.toString())
child: ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(15),
                child: Text('hi' + activityList[index].name),
              );
            },
            separatorBuilder: (context, index) => Divider(
                  height: 0.5,
                  color: Colors.purple,
                ),
            itemCount: activityList == null ? 0 : activityList.length),
            */