class FriendRequest {
  late String id, fromID, toID, status;
  late DateTime requestDate;

  FriendRequest(
    this.id,
    this.fromID,
    this.toID,
    this.status,
    this.requestDate,
  );

  FriendRequest.fromMap(dynamic obj) {
    id = obj['id'];
    fromID = obj['fromID'];
    toID = obj['toID'];
    status = obj['status'];
    requestDate = obj['requestDate'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "fromID": fromID,
      "toID": toID,
      "status": status,
      "requestDate": requestDate,
    };
  }
}
