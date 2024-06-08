// To parse this JSON data, do
//
//     final refreshToken = refreshTokenFromJson(jsonString);

import 'dart:convert';

RefreshToken refreshTokenFromJson(String str) =>
    RefreshToken.fromJson(json.decode(str));

String refreshTokenToJson(RefreshToken data) => json.encode(data.toJson());

class RefreshToken {
  RefreshToken({
    required this.code,
    required this.message,
    required this.refreshToken,
  });

  int code;
  String message;
  String refreshToken;

  factory RefreshToken.fromJson(Map<String, dynamic> json) => RefreshToken(
        code: json["code"],
        message: json["message"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "refresh_token": refreshToken,
      };
}
