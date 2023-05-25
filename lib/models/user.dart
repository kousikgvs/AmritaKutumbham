class User {
  late String _username;
  late String _password;
  late int _userId;
  User(this._userId,this._username, this._password);

  User.map(dynamic obj) {
    _username = obj["username"];
    _password = obj["password"];
    _userId = obj["userId"];
  }

  String get username => _username;
  String get password => _password;
  int get userid => _userId;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["username"] = _username;
    map["password"] = _password;
    map["user_id"] = _userId;

    return map;
  }
}