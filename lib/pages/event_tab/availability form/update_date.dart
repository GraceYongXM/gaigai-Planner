import 'package:flutter/material.dart';
import 'package:gaigai_planner/models/event_details.dart';
import 'package:gaigai_planner/pages/event_tab/indiv_page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../models/user.dart';
import '../../../services/datepicker_service.dart';

class UpdateDate extends StatefulWidget {
  const UpdateDate({super.key, required this.user, required this.eventDetails});
  final User user;
  final EventDetails eventDetails;

  @override
  State<UpdateDate> createState() => _UpdateDateState();
}

class _UpdateDateState extends State<UpdateDate> {
  DatePickerService datePickerClient = DatePickerService();
  final DateRangePickerController _controller = DateRangePickerController();

  void insertDate(DateTime date) {
    datePickerClient.insertDate(
        widget.eventDetails.eventID, widget.user.id, date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Availability'),
        centerTitle: true,
      ),
      body: SfDateRangePicker(
        selectionMode: DateRangePickerSelectionMode.multiple,
        showActionButtons: true,
        controller: _controller,
        onSubmit: (val) async {
          var done = await datePickerClient.deleteDates(
              widget.user.id, widget.eventDetails.eventID);
          if (done) {
            var dateListString = val.toString();
            var dateList = dateListString
                .substring(1, dateListString.length - 1)
                .split(', ');
            String date = '';
            for (var i in dateList) {
              date = i.split(' ')[0];
              insertDate(DateTime.parse(date));
            }
          }
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
        onCancel: () {
          _controller.selectedDates = null;
        },
        minDate: widget.eventDetails.startDate,
        maxDate: widget.eventDetails.endDate,
      ),
    );
  }
}
