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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateEvent(
                                user: widget.user,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Create new event',
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
      /*: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: eventIDs.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(eventIDs.length);
                    return EventTile(
                      user: widget.user,
                      index: index,
                      eventInfo: events,
                    );
                  },
                ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEvent(
                user: widget.user,
              ),
            ),
          )
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        tooltip: 'Create new event',
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
