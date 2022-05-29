class User {
  late int? id;
  late String username, email, mobileNo, password;

  User(
    this.id,
    this.username,
    this.email,
    this.mobileNo,
    this.password,
  );

  User.fromMap(dynamic obj) {
    id = obj['id'];
    username = obj['username'];
    email = obj['email'];
    mobileNo = obj['mobileNo'];
    password = obj['password'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "mobileNo": mobileNo,
      "password": password,
    };
  }
}
