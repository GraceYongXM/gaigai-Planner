import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/user.dart';
import '../../models/event_details.dart';

class AboutPage extends StatefulWidget {
  const AboutPage(
      {Key? key,
      required this.eventDetails,
      required this.user,
      required this.ownerName,
      required this.members})
      : super(key: key);
  final EventDetails eventDetails;
  final User user;
  final String ownerName;
  final List<String> members;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool isLoading = true;
  String names = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    for (String name in widget.members) {
      names += widget.user.displayName == name ? 'You' : name;
      names += ', ';
    }
    names = names.substring(0, names.length - 2);
  }

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Event name',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade800,
                ),
              ),
              subtitle: Text(
                widget.eventDetails.name,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'Owner name',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade800,
                ),
              ),
              subtitle: Text(
                widget.user.displayName == widget.ownerName
                    ? 'You'
                    : widget.ownerName,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'Event description',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade800,
                ),
              ),
              subtitle: Text(
                widget.eventDetails.description == ''
                    ? 'No description provided'
                    : widget.eventDetails.description!,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'Members',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade800,
                ),
              ),
              subtitle: Text(
                names,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'Start Date',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade800,
                ),
              ),
              subtitle: Text(
                DateFormat('yMMMd').format(widget.eventDetails.startDate),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'End Date',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade800,
                ),
              ),
              subtitle: Text(
                DateFormat('yMMMd').format(widget.eventDetails.endDate),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
