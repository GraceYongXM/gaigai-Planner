import 'dart:core';

class EventActivity {
  String activityID, eventID;
  double travelTime;
  bool isConfirmed;

  EventActivity(
    this.activityID,
    this.eventID,
    this.travelTime,
    this.isConfirmed,
  );
}
