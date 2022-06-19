import 'dart:core';

class EventDetails {
  String eventID, name;
  String? description;
  DateTime startDate;
  DateTime endDate;

  EventDetails(
    this.eventID,
    this.name,
    this.description,
    this.startDate,
    this.endDate,
  );
}
