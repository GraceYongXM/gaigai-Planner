import 'package:flutter/material.dart';

import 'package:gaigai_planner/models/event_details.dart';

import '../../../models/activity.dart';
import '../../../services/activity_service.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key, required this.event});
  final EventDetails event;

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  ActivityService activityClient = ActivityService();
  List<Activity> list = [];
  String dropDownValue = 'Default';

  @override
  void initState() {
    super.initState();
    getDefaultActivity();
  }

  getDefaultActivity() async {
    list = await activityClient.getDefaultActivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Row(
          children: [
            const Text('Sort by'),
            DropdownButton(
              value: dropDownValue,
              icon: const Icon(Icons.arrow_drop_down_rounded),
              items: const [
                DropdownMenuItem(
                  value: 'Default',
                  child: Text('Default'),
                ),
                DropdownMenuItem(
                  value: 'Cost',
                  child: Text('Cost'),
                ),
                DropdownMenuItem(
                  value: 'Distance',
                  child: Text('Distance'),
                ),
              ],
              onChanged: (String? value) async {
                setState(() {
                  dropDownValue = value!;
                });
                if (dropDownValue == 'Default') {
                  getDefaultActivity();
                  setState(() {});
                } else if (dropDownValue == 'Cost') {
                  setState(() {
                    //sortByCost();
                  });
                } else if (dropDownValue == 'Distance') {
                  setState(() {
                    //sortByDistance();
                  });
                }
              },
            )
          ],
        )
      ]),
    );
  }
}
