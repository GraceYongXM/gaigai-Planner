import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaigai_planner/pages/event_tab/availability%20form/update_date.dart';
import 'package:intl/intl.dart';

import 'package:gaigai_planner/pages/event_tab/activities/activity_page.dart';
import 'package:gaigai_planner/pages/event_tab/availability%20form/datepicker_form.dart';
import 'package:gaigai_planner/pages/event_tab/send_event_invites/chat_settings/event_invitations_page.dart';
import 'package:gaigai_planner/services/datepicker_service.dart';
import 'package:gaigai_planner/services/form_service.dart';

import 'about_page.dart';
import 'availability form/wait_page.dart';
import 'chat_page.dart';
import '../home_page.dart';
import '../event_tab/send_event_invites/chat_settings/edit_form_page.dart';
import '../../services/chat_service.dart';
import '../../models/user.dart';
import '../../models/event_details.dart';

class IndivPage extends StatefulWidget {
  const IndivPage({Key? key, required this.user, required this.eventDetails})
      : super(key: key);
  final User user;
  final EventDetails eventDetails;

  @override
  State<IndivPage> createState() => _IndivPageState();
}

class _IndivPageState extends State<IndivPage>
    with SingleTickerProviderStateMixin {
  List<String> options = [
    'Edit event form',
    'Edit availability form',
    'View requests',
    'Share event',
    'Delete event'
  ];
  final _supabaseClient = ChatService();
  FormService formClient = FormService();
  DatePickerService datePickerService = DatePickerService();
  bool isFormDone = false;
  bool everyoneSubmitted = false;
  bool isLoading = true;
  String ownerName = '';
  List<String> members = [];
  List<DateTime> commonDates = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, initialIndex: 1, vsync: this);
    getData();
    isFormDoneFunction(widget.user.id, widget.eventDetails.eventID);
  }

  void getData() async {
    String name =
        (await _supabaseClient.getOwner(widget.eventDetails.ownerID))!;
    List<Map<String, String>> memberNames =
        await _supabaseClient.getMembers(widget.eventDetails.eventID);
    bool everyoneCompleted =
        await datePickerService.everyoneSubmitted(widget.eventDetails.eventID);
    List<String> names = [];
    for (Map<String, String> map in memberNames) {
      names.add(map['display_name']!);
    }

    if (this.mounted) {
      setState(() {
        ownerName = name;
        members = names;
        everyoneSubmitted = everyoneCompleted;
      });
    }
    if (everyoneCompleted) {
      List<DateTime> dates = await _supabaseClient.getCommonDates(
          widget.eventDetails.startDate,
          widget.eventDetails.endDate,
          widget.eventDetails.eventID,
          memberNames.length);

      if (this.mounted) {
        setState(() {
          commonDates = dates;
        });
      }
    }
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void isFormDoneFunction(String userID, String eventID) async {
    isFormDone = await formClient.isFormDone(userID, eventID);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.eventDetails.ownerID != widget.user.id) {
      // check if user is owner of event
      options.removeWhere((element) =>
          !(element == 'Share event' || element == 'Edit availability form'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.eventDetails.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(user: widget.user),
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.info_outlined),
              text: 'About',
            ),
            Tab(
              icon: Icon(Icons.chat),
              text: 'Chat',
            ),
            Tab(
              icon: Icon(Icons.list),
              text: 'Activities',
            ),
            Tab(
              icon: Icon(Icons.date_range),
              text: 'Dates',
            )
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            tooltip: 'Settings',
            itemBuilder: (BuildContext context) {
              return options
                  .map((element) => PopupMenuItem<String>(
                      value: element, child: Text(element)))
                  .toList();
            },
            onSelected: (String choice) {
              if (choice == 'Edit event form') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditFormPage(
                      eventDetails: widget.eventDetails,
                      user: widget.user,
                      startDate: widget.eventDetails.startDate,
                      endDate: widget.eventDetails.endDate,
                    ),
                  ),
                );
              } else if (choice == 'Edit availability form') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateDate(
                      user: widget.user,
                      eventDetails: widget.eventDetails,
                    ),
                  ),
                );
              } else if (choice == 'View requests') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventInvitationsPage(
                      event: widget.eventDetails,
                    ),
                  ),
                );
              } else if (choice == 'Share event') {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Input this invitation code',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.eventDetails.eventID,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Color(0xffBB86FC)),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: widget.eventDetails.eventID));
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Copied to clipboard.')));
                                  },
                                  child: const Icon(Icons.copy),
                                ),
                              ],
                            ),
                          ),
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
              } else if (choice == 'Delete event') {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('This action cannot be undone.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await _supabaseClient.deleteEvent(
                              eventID: widget.eventDetails.eventID);
                          Navigator.pop(context);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(user: widget.user),
                            ),
                          );
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              }
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : AboutPage(
                  eventDetails: widget.eventDetails,
                  user: widget.user,
                  ownerName: ownerName,
                  members: members,
                ),
          ChatPage(
            eventDetails: widget.eventDetails,
            user: widget.user,
          ),
          ActivityPage(
            event: widget.eventDetails,
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : everyoneSubmitted
                  ? commonDates.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'No Common Dates',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.separated(
                          itemBuilder: ((context, index) => ListTile(
                              title: Text(DateFormat('yMMMd')
                                  .format(commonDates[index])))),
                          separatorBuilder: ((context, index) =>
                              const Divider(thickness: 1)),
                          itemCount: commonDates.length)
                  : isFormDone
                      ? WaitPage(
                          user: widget.user,
                          eventDetails: widget.eventDetails,
                        )
                      : DatePickerForm(
                          details: widget.eventDetails,
                          user: widget.user,
                        ),
        ],
      ),
    );
  }
}
