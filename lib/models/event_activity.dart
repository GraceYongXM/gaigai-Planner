import 'dart:core';

class EventActivity {
  String activityID, eventID, activityName, activityDescription;
  double distance;
  num cost;
  bool isConfirmed;

  EventActivity(
    this.activityID,
    this.eventID,
    this.activityName,
    this.activityDescription,
    this.distance,
    this.cost,
    this.isConfirmed,
  );
}
