import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'about_page.dart';
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
  List<String> options = ['Edit form', 'Share event', 'Delete event'];
  final _supabaseClient = ChatService();
  String ownerName = '';
  List<String> members = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 1, vsync: this);
    getData();
  }

  void getData() async {
    String name =
        (await _supabaseClient.getOwner(widget.eventDetails.ownerID))!;
    List<String> memberNames =
        await _supabaseClient.getMembers(widget.eventDetails.eventID);
    if (this.mounted) {
      setState(() {
        ownerName = name;
        members = memberNames;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.eventDetails.ownerID != widget.user.id) {
      // check if user is owner of event
      options.removeWhere((element) => element != 'Share event');
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
            /*
            Tab(
              icon: Icon(Icons.list),
              text: 'Activities',
            ),*/
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
              if (choice == 'Edit form') {
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                        SnackBar(
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
          AboutPage(
            eventDetails: widget.eventDetails,
            user: widget.user,
            ownerName: ownerName,
            members: members,
          ),
          ChatPage(
            eventDetails: widget.eventDetails,
            user: widget.user,
          ),
        ],
      ),
    );
  }
}
