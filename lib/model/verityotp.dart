// To parse this JSON data, do
//
//     final verifyOtp = verifyOtpFromJson(jsonString);

import 'dart:convert';

VerifyOtp verifyOtpFromJson(String str) => VerifyOtp.fromJson(json.decode(str));

String verifyOtpToJson(VerifyOtp data) => json.encode(data.toJson());

class VerifyOtp {
  int code;
  String message;
  String driverId;
  String email;
  bool alreadyRegistered;
  bool licenseVerified;

  VerifyOtp({
    required this.code,
    required this.message,
    required this.driverId,
    required this.email,
    required this.alreadyRegistered,
    required this.licenseVerified,
  });

  factory VerifyOtp.fromJson(Map<String, dynamic> json) => VerifyOtp(
        code: json["code"],
        message: json["message"],
        driverId: json["driver_id"],
        email: json["email"],
        alreadyRegistered: json["already_registered"],
        licenseVerified: json["license_verified"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "driver_id": driverId,
        "email": email,
        "already_registered": alreadyRegistered,
        "license_verified": licenseVerified,
      };
}
