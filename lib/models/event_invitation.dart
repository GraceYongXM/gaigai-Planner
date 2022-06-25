class EventInvitation {
  String id, userID, eventID, requesterID, status;
  DateTime? requestDate;

  EventInvitation(
    this.id,
    this.userID,
    this.eventID,
    this.requesterID,
    this.status,
    this.requestDate,
  );
}
