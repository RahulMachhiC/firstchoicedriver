// To parse this JSON data, do
//
//     final rideRequestModel = rideRequestModelFromJson(jsonString);

import 'dart:convert';

RideRequestModel rideRequestModelFromJson(String str) =>
    RideRequestModel.fromJson(
      json.decode(str),
    );

String rideRequestModelToJson(RideRequestModel data) => json.encode(
      data.toJson(),
    );

class RideRequestModel {
  String notes;
  String sound;
  String pickupAddress;
  String vibrate;
  String body;
  String title;
  String dropLocation;
  String badge;
  String bookingNumber;
  String pickupLong;
  String customerName;
  String customerId;
  String pickupLat;
  String customerImage;

  RideRequestModel({
    required this.notes,
    required this.sound,
    required this.pickupAddress,
    required this.vibrate,
    required this.body,
    required this.title,
    required this.dropLocation,
    required this.badge,
    required this.bookingNumber,
    required this.pickupLong,
    required this.customerName,
    required this.customerId,
    required this.pickupLat,
    required this.customerImage,
  });

  factory RideRequestModel.fromJson(Map<String, dynamic> json) =>
      RideRequestModel(
        notes: json["notes"],
        sound: json["sound"],
        pickupAddress: json["pickup_address"],
        vibrate: json["vibrate"],
        body: json["body"],
        title: json["title"],
        dropLocation: json["drop_location"],
        // dropLocation: List<DropLocation>.from(
        //   json["drop_location"].map(
        //     (x) => DropLocation.fromJson(jsonDecode(x)),
        //   ),
        // ),
        badge: json["badge"],
        bookingNumber: json["booking_number"],
        pickupLong: json["pickup_long"],
        customerName: json["customer_name"],
        customerId: json["customer_id"],
        pickupLat: json["pickup_lat"],
        customerImage: json["customer_image"],
      );

  Map<String, dynamic> toJson() => {
        "notes": notes,
        "sound": sound,
        "pickup_address": pickupAddress,
        "vibrate": vibrate,
        "body": body,
        "title": title,
        "drop_location": dropLocation,
        //    List<dynamic>.from(dropLocation.map((x) => x.toJson())),
        "badge": badge,
        "booking_number": bookingNumber,
        "pickup_long": pickupLong,
        "customer_name": customerName,
        "customer_id": customerId,
        "pickup_lat": pickupLat,
        "customer_image": customerImage,
      };
}

class DropLocation {
  String address;
  String lat;
  String long;

  DropLocation({
    required this.address,
    required this.lat,
    required this.long,
  });

  factory DropLocation.fromJson(Map<String, dynamic> json) => DropLocation(
        address: json["address"],
        lat: json["lat"],
        long: json["long"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "lat": lat,
        "long": long,
      };
}
