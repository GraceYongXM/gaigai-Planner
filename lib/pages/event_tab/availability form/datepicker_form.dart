import 'package:flutter/material.dart';
import 'package:gaigai_planner/models/event_details.dart';
import 'package:gaigai_planner/models/user.dart';
import 'package:gaigai_planner/pages/event_tab/indiv_page.dart';
import 'package:gaigai_planner/services/datepicker_service.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerForm extends StatefulWidget {
  const DatePickerForm({super.key, required this.details, required this.user});
  final EventDetails details;
  final User user;

  @override
  State<DatePickerForm> createState() => _DatePickerFormState();
}

class _DatePickerFormState extends State<DatePickerForm> {
  DatePickerService datePickerClient = DatePickerService();
  final DateRangePickerController _controller = DateRangePickerController();
  final _locationController = TextEditingController();
  bool everyoneSubmitted = false;

  void insertDate(DateTime date) {
    datePickerClient.insertDate(widget.details.eventID, widget.user.id, date);
  }

  void insertLocation(String location) {
    datePickerClient.insertLocation(
        widget.details.eventID, widget.user.id, location);
  }

  void insertActivities() async {
    everyoneSubmitted =
        await datePickerClient.everyoneSubmitted(widget.details.eventID);
    if (everyoneSubmitted) {
      datePickerClient.insertActivities(widget.details.eventID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfDateRangePicker(
        selectionMode: DateRangePickerSelectionMode.multiple,
        showActionButtons: true,
        controller: _controller,
        onSubmit: (val) {
          var dateListString = val.toString();
          var dateList = dateListString
              .substring(1, dateListString.length - 1)
              .split(', ');
          String date = '';
          for (var i in dateList) {
            date = i.split(' ')[0];
            insertDate(DateTime.parse(date));
          }

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
                    insertLocation(_locationController.text);
                    insertActivities();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndivPage(
                            user: widget.user, eventDetails: widget.details),
                      ),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        onCancel: () {
          _controller.selectedDates = null;
        },
        minDate: widget.details.startDate,
        maxDate: widget.details.endDate,
      ),
    );
  }
}
