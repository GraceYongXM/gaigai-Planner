import 'package:flutter/material.dart';
import 'package:gaigai_planner/models/event_details.dart';
import 'package:gaigai_planner/pages/event_tab/create_event.dart';
import 'indiv_page.dart';
import '../../services/event_service.dart';
import '../../models/user.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _supabaseClient = EventService();
  List<String> eventIDs = [];
  List<EventDetails> events = [];

  final _controller = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    isLoading = true;
    super.initState();
    getEvents(widget.user.id);
  }

  void getEvents(String id) async {
    List<String> _eventIDs = await _supabaseClient.getEventIDs(id);
    List<EventDetails> _events = await _supabaseClient.getEventInfo(_eventIDs);
    setState(() {
      eventIDs = _eventIDs;
      events = _events;
      isLoading = false;
    });
  }

  void newEvent() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: SizedBox(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Text('Would you like to'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateEvent(
                        user: widget.user,
                      ),
                    ),
                  );
                },
                child: const Text('Create new event'),
              ),
              TextButton(
                onPressed: (() {
                  Navigator.pop(context);
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: SizedBox(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text('Input the invitation code:'),
                            ),
                            TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: 'Invitation Code',
                              ),
                            ),
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
                            bool exists = await _supabaseClient
                                .invitationCodeExists(_controller.text.trim());
                            if (_controller.text.trim() == '') {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text(
                                      'Please input the invitation code.'),
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
                            } else if (!exists) {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text('Event does not exist.'),
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
                              bool inEvent =
                                  await _supabaseClient.userAlreadyInEvent(
                                      _controller.text.trim(), widget.user.id);
                              if (inEvent) {
                                Navigator.pop(context);
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'You are already in the event.'),
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
                                bool requestExists =
                                    await _supabaseClient.requestExists(
                                        _controller.text.trim(),
                                        widget.user.id);
                                if (requestExists) {
                                  Navigator.pop(context);
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      content: const Text(
                                          'Please wait for event owner \nto accept your invitation.'),
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
                                  _supabaseClient.insertSelfInvitation(
                                      _controller.text.trim(), widget.user.id);
                                  Navigator.pop(context);
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Success'),
                                      content: const Text(
                                          'Please wait for event owner \nto accept your invitation.'),
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
                          child: const Text('Join'),
                        ),
                      ],
                    ),
                  );
                }),
                child: const Text('Join existing event'),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (eventIDs.isEmpty)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('You have not created any events.',
                          style: TextStyle(fontSize: 18)),
                      TextButton(
                        onPressed: () {
                          newEvent;
                        },
                        child: const Text(
                          'Create new event/Join event',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: events.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(events[index].name),
                    subtitle: Text(events[index].description ?? ''),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndivPage(
                            user: widget.user,
                            eventDetails: events[index],
                          ),
                        ),
                      );
                    },
                  ),
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 1,
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          newEvent();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        tooltip: 'Create/join event',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  int index;
  User user;
  List<EventDetails> eventInfo;

  EventTile(
      {Key? key,
      required this.index,
      required this.user,
      required this.eventInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(eventInfo[index].name),
          subtitle: Text(eventInfo[index].description ?? ''),
          onTap: () {},
        ),
        const Divider(
          thickness: 1,
        ),
      ],
    );
  }
}
