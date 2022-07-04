import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/event_details.dart';
import '../../../../models/user.dart';
import '../../indiv_page.dart';
import '../../../../services/chat_service.dart';

class EditFormPage extends StatefulWidget {
  const EditFormPage(
      {Key? key,
      required this.eventDetails,
      required this.user,
      required this.startDate,
      required this.endDate})
      : super(key: key);
  final EventDetails eventDetails;
  final User user;
  final DateTime startDate, endDate;

  @override
  State<EditFormPage> createState() => _EditFormPageState();
}

class _EditFormPageState extends State<EditFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _supabaseClient = ChatService();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  late bool uniqueEventName;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.eventDetails.name;
    startDateController.text =
        DateFormat('yMMMd').format(widget.eventDetails.startDate);
    endDateController.text =
        DateFormat('yMMMd').format(widget.eventDetails.endDate);
    if (widget.eventDetails.description != '') {
      descriptionController.text = widget.eventDetails.description!;
    }
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDateRange:
          DateTimeRange(start: widget.startDate, end: widget.endDate),
    );
    if (newDateRange == null) return;
    setState(() {
      dateRange = newDateRange;
      startDateController.text = DateFormat('yMMMd').format(newDateRange.start);
      endDateController.text = DateFormat('yMMMd').format(newDateRange.end);
    });
  }

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 30)),
  );

  void back() {
    if (nameController.text != widget.eventDetails.name ||
        descriptionController.text != widget.eventDetails.description) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Changes will not be saved!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IndivPage(
                      user: widget.user,
                      eventDetails: widget.eventDetails,
                    ),
                  ),
                );
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => IndivPage(
            user: widget.user,
            eventDetails: widget.eventDetails,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final expansionTileTheme =
        Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Creation Form'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: back,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                print(dateRange.start);
                print(dateRange.end);
                await _supabaseClient.updateEvent(
                    id: widget.eventDetails.eventID,
                    name: nameController.text,
                    description: descriptionController.text,
                    startDate: dateRange.start,
                    endDate: dateRange.end);
                EventDetails event = (await _supabaseClient
                    .getEvent(widget.eventDetails.eventID))!;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IndivPage(
                      user: widget.user,
                      eventDetails: event,
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.done),
          ),
        ],
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
                  onChanged: (text) async {
                    uniqueEventName = await _supabaseClient.uniqueEventName(
                        text, widget.user.id);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter event name';
                    } else if (value != widget.eventDetails.name &&
                        !uniqueEventName) {
                      return 'You currently have an event with this name.';
                    }
                    return null;
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
                      'Event date range',
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
                          startDateController.text,
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
                          endDateController.text,
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
            ],
          ),
        ),
      ),
    );
  }
}
