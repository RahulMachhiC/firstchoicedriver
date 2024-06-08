// To parse this JSON data, do
//
//     final accessToken = accessTokenFromJson(jsonString);

import 'dart:convert';

AccessToken accessTokenFromJson(String str) =>
    AccessToken.fromJson(json.decode(str));

String accessTokenToJson(AccessToken data) => json.encode(data.toJson());

class AccessToken {
  AccessToken({
    required this.code,
    required this.message,
    required this.accessToken,
    required this.expiry,
  });

  int code;
  String message;
  String accessToken;
  DateTime expiry;

  factory AccessToken.fromJson(Map<String, dynamic> json) => AccessToken(
        code: json["code"],
        message: json["message"],
        accessToken: json["access_token"],
        expiry: DateTime.parse(json["expiry"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "access_token": accessToken,
        "expiry": expiry.toIso8601String(),
      };
}
