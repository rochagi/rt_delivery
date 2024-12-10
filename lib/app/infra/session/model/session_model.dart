import 'dart:convert';

class SessionModel {
  final String host;
  final String login;
  final String password;

  SessionModel(
      {required this.host, required this.login, required this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'host': host,
      'login': login,
      'password': password,
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      host: map['host'] as String,
      login: map['login'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionModel.fromJson(String source) =>
      SessionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
