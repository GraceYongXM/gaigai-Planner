class User {
  late int? id;
  late String username, mobileNo;
  late DateTime createTime;

  User(
    this.id,
    this.username,
    this.mobileNo,
    this.createTime,
  );

  User.fromMap(dynamic obj) {
    id = obj['id'];
    username = obj['username'];
    mobileNo = obj['mobileNo'];
    createTime = obj['createTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "mobileNo": mobileNo,
      "createTime": createTime,
    };
  }
}
