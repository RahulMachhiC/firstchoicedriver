// To parse this JSON data, do
//
//     final passwordlogin = passwordloginFromJson(jsonString);

import 'dart:convert';

Passwordlogin passwordloginFromJson(String str) =>
    Passwordlogin.fromJson(json.decode(str));

String passwordloginToJson(Passwordlogin data) => json.encode(data.toJson());

class Passwordlogin {
  int code;
  String message;
  String driverId;
  String email;
  bool alreadyRegistered;
  bool licenseVerified;
  String accessToken;

  Passwordlogin({
    required this.code,
    required this.message,
    required this.driverId,
    required this.email,
    required this.alreadyRegistered,
    required this.licenseVerified,
    required this.accessToken,
  });

  factory Passwordlogin.fromJson(Map<String, dynamic> json) => Passwordlogin(
        code: json["code"],
        message: json["message"],
        driverId: json["driver_id"],
        email: json["email"],
        alreadyRegistered: json["already_registered"],
        licenseVerified: json["license_verified"],
        accessToken: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "driver_id": driverId,
        "email": email,
        "already_registered": alreadyRegistered,
        "license_verified": licenseVerified,
        "access_token": accessToken,
      };
}
