// To parse this JSON data, do
//
//     final rideHistory = rideHistoryFromJson(jsonString);

import 'dart:convert';

RideHistory rideHistoryFromJson(String str) =>
    RideHistory.fromJson(json.decode(str));

String rideHistoryToJson(RideHistory data) => json.encode(data.toJson());

class RideHistory {
  int code;
  String message;
  List<Booking> bookings;

  RideHistory({
    required this.code,
    required this.message,
    required this.bookings,
  });

  factory RideHistory.fromJson(Map<String, dynamic> json) => RideHistory(
        code: json["code"],
        message: json["message"],
        bookings: List<Booking>.from(
            json["bookings"].map((x) => Booking.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "bookings": List<dynamic>.from(bookings.map((x) => x.toJson())),
      };
}

class Booking {
  String customerId;
  String customerName;
  String customerEmail;
  String bookingId;
  String bookingDate;
  String amount;
  String rating;
  String review;
  String timing;
  PLocation pickupLocation;
  List<PLocation> dropLocation;

  Booking({
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.bookingId,
    required this.bookingDate,
    required this.timing,
    required this.amount,
    required this.rating,
    required this.review,
    required this.pickupLocation,
    required this.dropLocation,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        customerEmail: json["customer_email"],
        bookingId: json["booking_id"],
        bookingDate: json["booking_date"],
        timing: json["timing"],
        amount: json["amount"],
        rating: json["rating"],
        review: json["review"],
        pickupLocation: PLocation.fromJson(json["pickup_location"]),
        dropLocation: List<PLocation>.from(
            json["drop_location"].map((x) => PLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "customer_name": customerName,
        "customer_email": customerEmail,
        "booking_id": bookingId,
        "booking_date": bookingDate,
        "amount": amount,
        "rating": rating,
        "review": review,
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
