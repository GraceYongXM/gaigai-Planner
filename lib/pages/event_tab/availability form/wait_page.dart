import 'package:flutter/material.dart';
import 'package:gaigai_planner/models/event_details.dart';
import 'package:gaigai_planner/models/user.dart';
import 'package:gaigai_planner/pages/event_tab/availability%20form/datepicker_form.dart';
import 'package:gaigai_planner/pages/event_tab/availability%20form/update_date.dart';
import 'package:gaigai_planner/services/form_service.dart';

class WaitPage extends StatefulWidget {
  const WaitPage({super.key, required this.user, required this.eventDetails});
  final User user;
  final EventDetails eventDetails;

  @override
  State<WaitPage> createState() => _WaitPageState();
}

class _WaitPageState extends State<WaitPage> {
  FormService formClient = FormService();
  final _locationController = TextEditingController();

  void updateLocation(String userID, String eventID, String location) {
    formClient.updateLocation(userID, eventID, location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Waiting for other members to fill up their availabilities...',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Text(
            'Change of details?',
            style: TextStyle(fontSize: 18),
          ),
        ),
        ElevatedButton(
            onPressed: (() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateDate(
                    user: widget.user,
                    eventDetails: widget.eventDetails,
                  ),
                ),
              );
            }),
            child: const Text('Edit your availabilities')),
        ElevatedButton(
            onPressed: (() {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Enter your location (optional)'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _locationController,
                        minLines: 1,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'Location',
                          labelText: 'Location',
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        updateLocation(
                            widget.user.id,
                            widget.eventDetails.eventID,
                            _locationController.text);
                        Navigator.pop(context);
                      },
                      child: const Text('Update'),
                    ),
                  ],
                ),
              );
            }),
            child: const Text('Edit your location'))
      ],
    ));
  }
}
