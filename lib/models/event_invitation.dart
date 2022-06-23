class EventInvitation {
  String userID, eventID, requesterID, status;
  DateTime? requestDate;

  EventInvitation(
    this.userID,
    this.eventID,
    this.requesterID,
    this.status,
    this.requestDate,
  );
}
