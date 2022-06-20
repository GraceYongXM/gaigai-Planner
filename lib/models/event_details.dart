import 'dart:core';

class EventDetails {
  String eventID, ownerID, name;
  String? description;
  DateTime startDate;
  DateTime endDate;

  EventDetails(
    this.eventID,
    this.ownerID,
    this.name,
    this.description,
    this.startDate,
    this.endDate,
  );
}
