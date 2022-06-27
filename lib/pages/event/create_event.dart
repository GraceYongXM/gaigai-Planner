import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gaigai_planner/models/event_details.dart';
import 'package:gaigai_planner/pages/event/send_event_invites/send_event_invite.dart';
import 'package:gaigai_planner/services/event_service.dart';
import 'package:intl/intl.dart';

import '../../models/friend.dart';
import '../../models/user.dart';
import '../../services/friend_service.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key, required this.user});
  final User user;

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final _supabaseClient = FriendService();
  final eventService = EventService();
  List<String> friendIDs = [];
  List<Friend> friends = [];
  List<User> friendInfo = [];

  @override
  void initState() {
    super.initState();
    getFriends(widget.user.id);
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

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 30)),
  );

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDateRange: dateRange,
    );

    if (newDateRange == null) return;

    setState(() {
      dateRange = newDateRange;
    });
  }

  Future<List<EventDetails>> createEvent(String name, String ownerID,
      String? description, DateTime startDate, DateTime endDate) async {
    var eventID = await eventService.createEvent(
        name, ownerID, description, startDate, endDate);
    return eventService.getEventDetails(eventID);
  }

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;
    final expansionTileTheme =
        Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Creation Form'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Event name',
                    labelText: 'Event name',
                    prefixIcon: const Icon(Icons.event),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter event name';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Event description',
                    labelText: 'Event description',
                    prefixIcon: const Icon(Icons.info_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  minLines: 1,
                  maxLines: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Pick your event date range',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: pickDateRange,
                      icon: const Icon(
                        Icons.calendar_month_outlined,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Start date: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      TextButton(
                        onPressed: pickDateRange,
                        child: Text(
                          DateFormat('yMMMd').format(start),
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'End date: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      TextButton(
                        onPressed: pickDateRange,
                        child: Text(
                          DateFormat('yMMMd').format(end),
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var eventDetails = (await createEvent(
                      nameController.text,
                      widget.user.id,
                      descriptionController.text,
                      start,
                      end,
                    ))[0];
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => sendEventInvite(
                          user: widget.user,
                          friendIDs: friendIDs,
                          friends: friends,
                          friendInfo: friendInfo,
                          event: eventDetails,
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
