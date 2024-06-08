// // To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  int code;
  String message;
  int otp;
  String accessToken;

  LoginResponse({
    required this.code,
    required this.message,
    required this.otp,
    required this.accessToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        code: json["code"],
        message: json["message"],
        otp: json["otp"],
        accessToken: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "otp": otp,
        "access_token": accessToken,
      };
}
