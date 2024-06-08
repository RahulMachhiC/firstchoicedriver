// To parse this JSON data, do
//
//     final driverArrived = driverArrivedFromJson(jsonString);

import 'dart:convert';

DriverArrived driverArrivedFromJson(String str) =>
    DriverArrived.fromJson(json.decode(str));

String driverArrivedToJson(DriverArrived data) => json.encode(data.toJson());

class DriverArrived {
  int code;
  String mesage;
  String timestamp;
  String customerId;
  String customerName;
  String customerMobile;
  String customerRating;
  String customerPhoto;
  String pickupNotes;
  PLocation pickupLocation;
  List<PLocation> dropLocation;

  DriverArrived({
    required this.code,
    required this.mesage,
    required this.timestamp,
    required this.customerId,
    required this.customerName,
    required this.customerMobile,
    required this.customerRating,
    required this.customerPhoto,
    required this.pickupNotes,
    required this.pickupLocation,
    required this.dropLocation,
  });

  factory DriverArrived.fromJson(Map<String, dynamic> json) => DriverArrived(
        code: json["code"],
        mesage: json["mesage"],
        timestamp: json["timestamp"],
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        customerMobile: json["customer_mobile"],
        customerRating: json["customer_rating"],
        customerPhoto: json["customer_photo"],
        pickupNotes: json["pickup_notes"],
        pickupLocation: PLocation.fromJson(json["pickup_location"]),
        dropLocation: List<PLocation>.from(
            json["drop_location"].map((x) => PLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "mesage": mesage,
        "timestamp": timestamp,
        "customer_id": customerId,
        "customer_name": customerName,
        "customer_mobile": customerMobile,
        "customer_rating": customerRating,
        "customer_photo": customerPhoto,
        "pickup_notes": pickupNotes,
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
