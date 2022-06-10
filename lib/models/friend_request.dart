class FriendRequest {
  late int? id;
  late int fromID, toID;
  late DateTime requestDate;

  FriendRequest(
    this.id,
    this.fromID,
    this.toID,
  );

  FriendRequest.fromMap(dynamic obj) {
    id = obj['id'];
    fromID = obj['fromID'];
    toID = obj['toID'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "fromID": fromID,
      "toID": toID,
    };
  }
}
