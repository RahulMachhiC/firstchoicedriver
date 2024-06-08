// To parse this JSON data, do
//
//     final startRide = startRideFromJson(jsonString);

import 'dart:convert';

StartRide startRideFromJson(String str) => StartRide.fromJson(json.decode(str));

String startRideToJson(StartRide data) => json.encode(data.toJson());

class StartRide {
  int code;
  String mesage;
  String timestamp;
  PLocation pickupLocation;
  List<PLocation> dropLocation;
  String distance;
  String timing;

  StartRide({
    required this.code,
    required this.mesage,
    required this.timestamp,
    required this.pickupLocation,
    required this.dropLocation,
    required this.distance,
    required this.timing,
  });

  factory StartRide.fromJson(Map<String, dynamic> json) => StartRide(
        code: json["code"],
        mesage: json["mesage"],
        timestamp: json["timestamp"],
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
