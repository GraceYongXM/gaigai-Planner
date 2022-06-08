class Request {
  late int? id;
  late int fromID, toID;

  Request(
    this.id,
    this.fromID,
    this.toID,
  );

  Request.fromMap(dynamic obj) {
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
