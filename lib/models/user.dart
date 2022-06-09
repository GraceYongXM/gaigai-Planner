class User {
  //late int? id;
  late String id, username, mobileNo, email;
  late DateTime createTime;

  User(
    this.id,
    this.username,
    this.mobileNo,
    this.email,
    this.createTime,
  );

  User.fromMap(dynamic obj) {
    id = obj['id'];
    username = obj['username'];
    mobileNo = obj['mobileNo'];
    email = obj['email'];
    createTime = DateTime.parse(obj['createTime']);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "mobileNo": mobileNo,
      "email": email,
      "createTime": createTime,
    };
  }
}
