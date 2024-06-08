// To parse this JSON data, do
//
//     final paymentCollected = paymentCollectedFromJson(jsonString);

import 'dart:convert';

PaymentCollected paymentCollectedFromJson(String str) =>
    PaymentCollected.fromJson(json.decode(str));

String paymentCollectedToJson(PaymentCollected data) =>
    json.encode(data.toJson());

class PaymentCollected {
  int code;
  String mesage;
  String customerId;
  String customerName;
  String customerPhoto;

  PaymentCollected({
    required this.code,
    required this.mesage,
    required this.customerId,
    required this.customerName,
    required this.customerPhoto,
  });

  factory PaymentCollected.fromJson(Map<String, dynamic> json) =>
      PaymentCollected(
        code: json["code"],
        mesage: json["mesage"],
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        customerPhoto: json["customer_photo"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "mesage": mesage,
        "customer_id": customerId,
        "customer_name": customerName,
        "customer_photo": customerPhoto,
      };
}
