class Friend {
  late int? id;
  late int userID, friendID;

  Friend(
    this.id,
    this.userID,
    this.friendID,
  );

  Friend.fromMap(dynamic obj) {
    id = obj['id'];
    userID = obj['userID'];
    friendID = obj['friendID'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userID": userID,
      "friendID": friendID,
    };
  }
}
