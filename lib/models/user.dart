class User {
  //late int? id;
  late String id, username, mobileNo, email;
  late String? displayName, bio;
  late DateTime createTime;

  User(
    this.id,
    this.username,
    this.mobileNo,
    this.email,
    this.displayName,
    this.bio,
    this.createTime,
  );

  User.fromMap(dynamic obj) {
    id = obj['id'];
    username = obj['username'];
    mobileNo = obj['mobileNo'];
    email = obj['email'];
    displayName = obj['display_name'];
    bio = obj['bio'];
    createTime = DateTime.parse(obj['createTime']);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "mobileNo": mobileNo,
      "email": email,
      "display_name": displayName,
      "bio": bio,
      "createTime": createTime,
    };
  }
}
