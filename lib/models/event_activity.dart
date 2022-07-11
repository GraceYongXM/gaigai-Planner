import 'dart:core';

class EventActivity {
  String activityID, eventID;
  double distance;
  bool isConfirmed;

  EventActivity(
    this.activityID,
    this.eventID,
    this.distance,
    this.isConfirmed,
  );
}
