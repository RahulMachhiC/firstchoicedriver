// To parse this JSON data, do
//
//     final endRide = endRideFromJson(jsonString);

import 'dart:convert';

EndRide endRideFromJson(String str) => EndRide.fromJson(json.decode(str));

String endRideToJson(EndRide data) => json.encode(data.toJson());

class EndRide {
  int code;
  String mesage;
  String timestamp;
  String pickupAddress;
  String dropAddress;
  String rideAmount;
  String waitingCharge;
  String rideTotal;
  PLocation pickupLocation;
  List<PLocation> dropLocation;
  String distance;
  String timing;

  EndRide({
    required this.code,
    required this.mesage,
    required this.timestamp,
    required this.pickupAddress,
    required this.dropAddress,
    required this.rideAmount,
    required this.waitingCharge,
    required this.rideTotal,
    required this.pickupLocation,
    required this.dropLocation,
    required this.distance,
    required this.timing,
  });

  factory EndRide.fromJson(Map<String, dynamic> json) => EndRide(
        code: json["code"],
        mesage: json["mesage"],
        timestamp: json["timestamp"],
        pickupAddress: json["pickup_address"],
        dropAddress: json["drop_address"],
        rideAmount: json["ride_amount"],
        waitingCharge: json["waiting_charge"],
        rideTotal: json["ride_total"],
        pickupLocation: PLocation.fromJson(json["pickup_location"]),
        dropLocation: List<PLocation>.from(
            json["drop_location"].map((x) => PLocation.fromJson(x))),
        distance: json["distance"],
        timing: json["timing"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "mesage": mesage,
        "timestamp": timestamp,
        "pickup_address": pickupAddress,
        "drop_address": dropAddress,
        "ride_amount": rideAmount,
        "waiting_charge": waitingCharge,
        "ride_total": rideTotal,
        "pickup_location": pickupLocation.toJson(),
        "drop_location":
            List<dynamic>.from(dropLocation.map((x) => x.toJson())),
        "distance": distance,
        "timing": timing,
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
