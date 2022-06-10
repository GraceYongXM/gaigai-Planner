class User {
  late String id, username, mobileNo, email, displayName, bio;
  late DateTime createTime;

  User(
    this.id,
    this.username,
    this.mobileNo,
    this.email,
    this.createTime,
    this.displayName,
    this.bio,
  );

  User.fromMap(dynamic obj) {
    id = obj['id'];
    username = obj['username'];
    mobileNo = obj['mobileNo'];
    email = obj['email'];
    createTime = DateTime.parse(obj['createTime']);
    displayName = obj['displayName'];
    bio = obj['bio'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "mobileNo": mobileNo,
      "email": email,
      "createTime": createTime,
      "displayName": displayName,
      "bio": bio,
    };
  }
}
