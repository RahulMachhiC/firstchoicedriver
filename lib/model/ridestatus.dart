// To parse this JSON data, do
//
//     final rideStatus = rideStatusFromJson(jsonString);

import 'dart:convert';

RideStatus rideStatusFromJson(String str) =>
    RideStatus.fromJson(json.decode(str));

String rideStatusToJson(RideStatus data) => json.encode(data.toJson());

class RideStatus {
  int code;
  String mesage;
  String bookingId;
  String bookingDate;
  String amount;
  String status;
  PLocation pickupLocation;
  List<PLocation> dropLocation;

  RideStatus({
    required this.code,
    required this.mesage,
    required this.bookingId,
    required this.bookingDate,
    required this.amount,
    required this.status,
    required this.pickupLocation,
    required this.dropLocation,
  });

  factory RideStatus.fromJson(Map<String, dynamic> json) => RideStatus(
        code: json["code"],
        mesage: json["mesage"],
        bookingId: json["booking_id"],
        bookingDate: json["booking_date"],
        amount: json["amount"],
        status: json["status"],
        pickupLocation: PLocation.fromJson(json["pickup_location"]),
        dropLocation: List<PLocation>.from(
            json["drop_location"].map((x) => PLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "mesage": mesage,
        "booking_id": bookingId,
        "booking_date": bookingDate,
        "amount": amount,
        "status": status,
        "pickup_location": pickupLocation.toJson(),
        "drop_location":
            List<dynamic>.from(dropLocation.map((x) => x.toJson())),
      };
}

class PLocation {
  String lat;
  String long;
  String address;

  PLocation({
    required this.lat,
    required this.long,
    required this.address,
  });

  factory PLocation.fromJson(Map<String, dynamic> json) => PLocation(
        lat: json["lat"],
        long: json["long"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "long": long,
        "address": address,
      };
}
