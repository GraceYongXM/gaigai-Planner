class Event {
  late int? id; // primary key
  late int eventID; // same event -> same eventID
  late int userID;
  late String eventName;

  Event(this.id, this.eventName, this.userID);

  Event.fromMap(dynamic obj) {
    id = obj['id'];
    eventID = obj['eventID'];
    userID = obj['userID'];
    eventName = obj['eventName'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "eventID": eventID,
      "userID": userID,
      "eventName": eventName,
    };
  }
}
