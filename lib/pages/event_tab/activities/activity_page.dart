import 'package:flutter/material.dart';

import 'package:gaigai_planner/models/event_activity.dart';
import 'package:gaigai_planner/models/event_details.dart';
import 'package:gaigai_planner/models/activity.dart';
import 'package:gaigai_planner/pages/event_tab/activities/indiv_activity_page.dart';
import 'package:gaigai_planner/services/datepicker_service.dart';
import 'package:gaigai_planner/services/services.dart';

import '../../../services/activity_service.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key, required this.event});
  final EventDetails event;

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  ActivityService activityClient = ActivityService();
  DatePickerService dateClient = DatePickerService();
  List<EventActivity> list = [];
  String dropDownValue = 'Default';
  final ScrollController _scrollController = ScrollController();
  bool everyoneSubmitted = false;
  bool isLoading = true;

  @override
  void initState() {
    getDefaultActivity();
    super.initState();
  }

  void getDefaultActivity() async {
    bool form = await dateClient.everyoneSubmitted(widget.event.eventID);
    var newList = await activityClient.getDefaultActivity(widget.event.eventID);
    setState(() {
      isLoading = false;
      list = newList;
      everyoneSubmitted = form;
    });
  }

  void scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : everyoneSubmitted
            ? Scaffold(
                body: Column(children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Sort by',
                          style: TextStyle(fontSize: 17.5),
                        ),
                      ),
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
                            setState(() {
                              getDefaultActivity();
                            });
                          } else if (dropDownValue == 'Cost') {
                            setState(() {
                              activityClient.sortByCost(list);
                            });
                          } else if (dropDownValue == 'Distance') {
                            setState(() {
                              activityClient.sortByDistance(list);
                            });
                          }
                        },
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: list.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(list[index].activityName),
                        subtitle: Text(
                            'Cost: \$${list[index].cost} \nDistance: ${double.parse((list[index].distance).toStringAsFixed(1))}km'),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IndivActivityPage(
                                eventActivity: list[index],
                              ),
                            ),
                          );
                        },
                      ),
                      separatorBuilder: (context, index) => const Divider(
                        thickness: 1,
                      ),
                    ),
                  ),
                ]),
                floatingActionButton: Padding(
                  padding: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    onPressed: scrollToTop,
                    backgroundColor: const Color(0xffBB86FC),
                    child: const Icon(Icons.keyboard_arrow_up),
                  ),
                ))
            : const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Waiting for other members to fill up the form',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              );
  }
}
