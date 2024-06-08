// To parse this JSON data, do
//
//     final driverProfile = driverProfileFromJson(jsonString);

import 'dart:convert';

DriverProfile driverProfileFromJson(String str) =>
    DriverProfile.fromJson(json.decode(str));

String driverProfileToJson(DriverProfile data) => json.encode(data.toJson());

class DriverProfile {
  int code;
  String message;
  String name;
  String email;
  String mobileNumber;
  String profilePhoto;
  String licensePhoto;
  String licenseNumber;
  String licenseExpiryDate;

  DriverProfile({
    required this.code,
    required this.message,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.profilePhoto,
    required this.licensePhoto,
    required this.licenseNumber,
    required this.licenseExpiryDate,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) => DriverProfile(
        code: json["code"],
        message: json["message"],
        name: json["name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        profilePhoto: json["profile_photo"],
        licensePhoto: json["license_photo"],
        licenseNumber: json["license_number"],
        licenseExpiryDate: json["license_expiry_date"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "name": name,
        "email": email,
        "mobile_number": mobileNumber,
        "profile_photo": profilePhoto,
        "license_photo": licensePhoto,
        "license_number": licenseNumber,
        // "license_expiry_date":
        //     "${licenseExpiryDate.year.toString().padLeft(4, '0')}-${licenseExpiryDate.month.toString().padLeft(2, '0')}-${licenseExpiryDate.day.toString().padLeft(2, '0')}",
      };
}
