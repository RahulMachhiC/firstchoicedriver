// To parse this JSON data, do
//
//     final driverStatus = driverStatusFromJson(jsonString);

import 'dart:convert';

DriverStatus driverStatusFromJson(String str) =>
    DriverStatus.fromJson(json.decode(str));

String driverStatusToJson(DriverStatus data) => json.encode(data.toJson());

class DriverStatus {
  int code;
  String status;

  DriverStatus({
    required this.code,
    required this.status,
  });

  factory DriverStatus.fromJson(Map<String, dynamic> json) => DriverStatus(
        code: json["code"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
      };
}
