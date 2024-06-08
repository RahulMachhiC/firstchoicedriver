import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:first_choice_driver/api/api_base_helper.dart';
import 'package:http/http.dart' as http;

class AppRepository {
  ApiBaseHelper helper = ApiBaseHelper();

  Future<dynamic> douserlogin({
    required String devicetype,
    required String mobilenumber,
    required String fcm,
  }) async {
    final response = await helper.post(
      "driver/login",
      {
        "mobile_number": mobilenumber,
        "device_type": devicetype,
        "fcm_id": fcm,
      },
      {},
    );

    return response;
  }

// Verify OTP
  Future<dynamic> verifyOTP({
    required String mobilenumber,
    required String otp,
  }) async {
    final response = await helper.post(
      "driver/verify_otp",
      {
        "mobile_number": mobilenumber,
        "otp": otp,
      },
      {},
    );

    return response;
  }

  // Resent OTP
  Future<dynamic> resentOTP({
    required String mobilenumber,
  }) async {
    final response = await helper.post(
      "driver/resent_otp",
      {
        "mobile_number": mobilenumber,
      },
      {},
    );

    return response;
  }

  // Update Driver Status
  Future<dynamic> changedriverStatus(
      {required String userid,
      required String stauts,
      required String accesstoken}) async {
    final response = await helper.post(
      "driver/driver_status",
      {"driver_id": userid, "status": stauts},
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  // Forgot Password
  Future<dynamic> forgotpassword({
    required String mobile,
    required String password,
  }) async {
    final response = await helper.post(
      "driver/forgot_password",
      {
        "mobile_number": mobile,
        "password": password,
      },
      {},
    );

    return response;
  }

// Get Driver Status
  Future<dynamic> getdriverStatus(
      {required String userid, required String accesstoken}) async {
    final response = await helper.post(
      "driver/get_driver_status",
      {
        "driver_id": userid,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

// Get Driver Profile
  Future<dynamic> getdriverprofile(
      {required String userid, required String accesstoken}) async {
    final response = await helper.post(
      "driver/get_driver_profile",
      {
        "driver_id": userid,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

// Get Past Ride History
  Future<dynamic> getridehistory({
    required String userid,
    required String accesstoken,
  }) async {
    final response = await helper.post(
      "driver/driver_booking_history",
      {
        "driver_id": userid,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> acceptrejectride({
    required String userid,
    required String accesstoken,
    required String bookingnumber,
    required String status,
  }) async {
    final response = await helper.post(
      "driver/driver_accept_reject_ride",
      {
        "driver_id": userid,
        "booking_number": bookingnumber,
        "status": status,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> driverarrive({
    required String userid,
    required String accesstoken,
    required String bookingnumber,
  }) async {
    final response = await helper.post(
      "driver/driver_arrive",
      {
        "driver_id": userid,
        "booking_number": bookingnumber,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> startride({
    required String userid,
    required String accesstoken,
    required String longitude,
    required String waitingtime,
    required String latitude,
    required String bookingnumber,
  }) async {
    final response = await helper.post(
      "driver/driver_ride_start",
      {
        "driver_id": userid,
        "driver_lat": latitude,
        "driver_long": longitude,
        "waiting_time": waitingtime,
        "booking_number": bookingnumber,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> endrideride({
    required String userid,
    required String accesstoken,
    required String bookingnumber,
  }) async {
    final response = await helper.post(
      "driver/driver_ride_end",
      {
        "driver_id": userid,
        "booking_number": bookingnumber,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> paymentcollected({
    required String userid,
    required String accesstoken,
    required String bookingnumber,
  }) async {
    final response = await helper.post(
      "driver/driver_payment_collected",
      {
        "driver_id": userid,
        "booking_number": bookingnumber,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> updatedriverprofile({
    required File profile_picture,
    required String driver_id,
    required String name,
    required String license_expiry_date,
    required File license_image,
    required String accesstoken,
    required String email,
    required String license_number,
    required String password,
  }) async {
    String url =
        "https://webpristine.com/Dispatch-app/v1/driver/update_driver_profile";
    final request = http.MultipartRequest('POST', Uri.parse(url));

    // Create a multipart file from the file path
    if (profile_picture.path != '') {
      var profile = await http.MultipartFile.fromPath(
          'profile_picture', profile_picture.path);
      request.files.add(profile);
    }
    if (license_image.path != '') {
      var licence = await http.MultipartFile.fromPath(
          'license_image', license_image.path);
      request.files.add(licence);
    }

    // Add the file to the request
    request.headers["access_token"] = accesstoken;
    request.fields["license_number"] = license_number;
    request.fields["driver_id"] = driver_id;
    request.fields["name"] = name;
    request.fields["license_expiry_date"] = license_expiry_date;
    request.fields["email"] = email;

    request.fields["password"] = password;

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseBody);
    } else {
      throw UnimplementedError();
    }
  }

  Future<dynamic> dousersignup({
    // ignore: non_constant_identifier_names
    required File profile_picture,
    required String driver_id,
    required String name,
    required String license_number,
    required String license_expiry_date,
    required String access_token,
    required File license_image,
    required String email,
    required String password,
  }) async {
    String url = "https://webpristine.com/Dispatch-app/v1/driver/driver_signup";
    final request = http.MultipartRequest('POST', Uri.parse(url));

    // Create a multipart file from the file path
    var profile = await http.MultipartFile.fromPath(
        'profile_picture', profile_picture.path);
    var license =
        await http.MultipartFile.fromPath('license_image', license_image.path);

    // Add the file to the request

    request.files.add(profile);
    request.files.add(license);
    request.headers["access_token"] = access_token;

    request.fields["driver_id"] = driver_id;
    request.fields["name"] = name;
    request.fields["license_number"] = license_number;
    request.fields["license_expiry_date"] = license_expiry_date;
    request.fields["email"] = email;
    request.fields["password"] = password;

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseBody);
    } else {
      throw UnimplementedError();
    }
  }

  Future<dynamic> douserlogout({
    required String accesstoken,
    required String userid,
  }) async {
    final response = await helper.post(
      "driver/logout",
      {
        "driver_id": userid,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  // Login By Password
  Future<dynamic> loginbypassword({
    required String mobilenumber,
    required String password,
    required String countrycode,
  }) async {
    final response = await helper.post(
      "driver/login_by_password",
      {
        "mobile_number": "+$countrycode$mobilenumber",
        "password": password,
      },
      {},
    );
    log("response is $response");

    return response;
  }

  Future<dynamic> riderate({
    required String userid,
    required String accesstoken,
    required String bookingnumber,
    required String rating,
    required String review,
  }) async {
    final response = await helper.post(
      "driver/driver_rating",
      {
        "driver_id": userid,
        "booking_number": bookingnumber,
        "rating": rating,
        "review": review,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> updatetoken({
    required String userid,
    required String accesstoken,
    required String fcmtoken,
  }) async {
    final response = await helper.post(
      "driver/update_driver_token",
      {
        "user_id": userid,
        "fcm_id": fcmtoken,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> getcurrentbooking({
    required String userid,
    required String accesstoken,
  }) async {
    final response = await helper.post(
      "driver/current_booking",
      {
        "user_id": userid,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> getridestatus({
    required String userid,
    required String rideid,
    required String accesstoken,
  }) async {
    final response = await helper.post(
      "driver/ride_status",
      {"user_id": userid, "booking_number": rideid},
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> getDriverLatLng({
    required String driverId,
    required String accesstoken,
    required String lat,
    required String long,
  }) async {
    final response = await helper.post(
      "api/udpate_user_lat_long",
      {
        "user_id": driverId,
        "latitude": lat,
        "longitude": long,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> updateRidePayment({
    required String userId,
    required String accessToken,
    required String bookingNumber,
    required List<String> paymentTypeId,
    required List<String> cardNumber,
  }) async {
    final response = await helper.post(
      "driver/update_ride_payment",
      {
        "user_id": userId,
        "booking_number": bookingNumber,
        "payment_type_id": paymentTypeId.toString(),
        "card_number": cardNumber.toString(),
      },
      {
        "access_token": accessToken,
      },
    );

    return response;
  }

  Future<dynamic> addridetip({
    required String userId,
    required String accessToken,
    required String bookingNumber,
    required String amount,
  }) async {
    final response = await helper.post(
      "api/add_ride_tip",
      {
        "user_id": userId,
        "booking_number": bookingNumber,
        "tip_amount": amount,
      },
      {
        "access_token": accessToken,
      },
    );

    return response;
  }
}
