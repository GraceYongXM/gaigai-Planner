import 'dart:core';

class Activity {
  int id;
  String name, type, location;
  double cost;
  double? travelTime;

  Activity(
    this.id,
    this.name,
    this.type,
    this.location,
    this.cost,
    this.travelTime,
  );
}
