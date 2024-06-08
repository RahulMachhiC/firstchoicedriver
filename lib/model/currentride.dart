// To parse this JSON data, do
//
//     final currentRide = currentRideFromJson(jsonString);

import 'dart:convert';

CurrentRide currentRideFromJson(String str) =>
    CurrentRide.fromJson(json.decode(str));

String currentRideToJson(CurrentRide data) => json.encode(data.toJson());

class CurrentRide {
  int code;
  String message;
  String bookingId;
  String bookingDate;
  String amount;
  String status;
  PickLocation pickupLocation;
  List<PickLocation> dropLocation;
  String customerId;
  String customerName;
  String customerEmail;
  String customerMobile;
  String customerRating;
  String customerPhoto;
  String customerLat;
  String customerLong;

  CurrentRide({
    required this.code,
    required this.message,
    required this.bookingId,
    required this.bookingDate,
    required this.amount,
    required this.status,
    required this.pickupLocation,
    required this.dropLocation,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerMobile,
    required this.customerRating,
    required this.customerPhoto,
    required this.customerLat,
    required this.customerLong,
  });

  factory CurrentRide.fromJson(Map<String, dynamic> json) => CurrentRide(
        code: json["code"],
        message: json["message"],
        bookingId: json["booking_id"],
        bookingDate: json["booking_date"],
        amount: json["amount"],
        status: json["status"],
        pickupLocation: PickLocation.fromJson(json["pickup_location"]),
        dropLocation: List<PickLocation>.from(
            json["drop_location"].map((x) => PickLocation.fromJson(x))),
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        customerEmail: json["customer_email"],
        customerMobile: json["customer_mobile"],
        customerRating: json["customer_rating"],
        customerPhoto: json["customer_photo"],
        customerLat: json["customer_lat"],
        customerLong: json["customer_long"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "booking_id": bookingId,
        "booking_date": bookingDate,
        "amount": amount,
        "status": status,
        "pickup_location": pickupLocation.toJson(),
        "drop_location":
            List<dynamic>.from(dropLocation.map((x) => x.toJson())),
        "customer_id": customerId,
        "customer_name": customerName,
        "customer_email": customerEmail,
        "customer_mobile": customerMobile,
        "customer_rating": customerRating,
        "customer_photo": customerPhoto,
        "customer_lat": customerLat,
        "customer_long": customerLong,
      };
}

class PickLocation {
  String lat;
  String long;
  String address;

  PickLocation({
    required this.lat,
    required this.long,
    required this.address,
  });

  factory PickLocation.fromJson(Map<String, dynamic> json) => PickLocation(
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
