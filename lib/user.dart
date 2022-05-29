class User {
  late int accountNo, mobileNo;
  late String username, email, password;

  User(
    this.accountNo,
    this.username,
    this.email,
    this.mobileNo,
    this.password,
  );

  User.fromMap(dynamic obj) {
    accountNo = obj['accountNo'];
    username = obj['username'];
    email = obj['email'];
    mobileNo = obj['mobileNo'];
    password = obj['password'];
  }

  Map<String, dynamic> toMap() {
    return {
      "accountNo": accountNo,
      "username": username,
      "email": email,
      "mobileNo": mobileNo,
      "password": password,
    };
  }
}
