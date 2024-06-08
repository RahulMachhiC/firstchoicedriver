import 'dart:developer';

import 'package:first_choice_driver/common/app_image.dart';
import 'package:first_choice_driver/common/sizedbox.dart';
import 'package:first_choice_driver/controller/ride_provider.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/model/riderequestnoti.dart';
import 'package:first_choice_driver/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

Widget arrivingwidget({
  required RideProvider rideProvider,
  RideRequestModel? rideRequestModel,
  required BuildContext context,
}) {
  double distance = calculateDistance(
    LatLng(rideProvider.currentPosition?.latitude ?? 00,
        rideProvider.currentPosition?.longitude ?? 00),
    LatLng(
      double.parse(rideProvider.currentRide?.pickupLocation.lat ??
          rideRequestModel?.pickupLat ??
          "00"),
      double.parse(
        rideProvider.currentRide?.pickupLocation.long ??
            rideRequestModel?.pickupLong ??
            "00",
      ),
    ),
  );

  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 10.h,
          ) +
          EdgeInsets.only(
            bottom: 30.h,
          ),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: 20.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greydark,
                  spreadRadius: 0,
                  blurRadius: 4,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Row(
                    children: [
                      AppImage(
                        "assets/user.png",
                        height: 60.h,
                        width: 60.w,
                      ),
                      sizedBoxWithWidth(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rideProvider.currentRide != null
                                ? rideProvider.currentRide!.customerName
                                : rideProvider.acceptResponse!.customerName,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Mobile No. ${rideProvider.currentRide != null ? rideProvider.currentRide!.customerMobile : rideProvider.acceptResponse!.customerMobile}",
                            style: GoogleFonts.poppins(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: AppColors.green,
                                size: 10,
                              ),
                              Text(
                                rideProvider.currentRide != null
                                    ? rideProvider.currentRide!.customerRating
                                    : rideProvider
                                        .acceptResponse!.customerRating,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          String telephoneNumber =
                              rideProvider.currentRide != null
                                  ? rideProvider.currentRide!.customerMobile
                                  : rideProvider.acceptResponse!.customerMobile;
                          String telephoneUrl = "tel:$telephoneNumber";

                          try {
                            await launchUrl(Uri.parse(telephoneUrl));
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 10.w,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.greylight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.phone_in_talk_sharp,
                            color: AppColors.green,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ) +
                      EdgeInsets.only(
                        bottom: 16.h,
                      ),
                  child: rideProvider.acceptResponse != null
                      ? rideProvider.acceptResponse!.pickupNotes != ""
                          ? Text(
                              "Pickup Note: ${rideProvider.acceptResponse!.pickupNotes}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500),
                            )
                          : const SizedBox()
                      : const SizedBox(),
                ),
                Text(distance.toString()),
                InkWell(
                  onTap: () {
                    context.read<RideProvider>().driverarrive(
                          context: context,
                        );
                    // if (canArrive(distance)) {

                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //     backgroundColor: AppColors.green,
                    //     content: const Text(
                    //       "Not Arrived at your Location yet \n\n",
                    //     ),
                    //     duration: const Duration(seconds: 2),
                    //   ));
                    // }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.green,
                          AppColors.yellow,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Arrive",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

bool canArrive(double distance) {
  return distance <= 100;
}

// Inside your widget
double calculateDistance(LatLng driverLocation, LatLng destination) {
  double distance = Geolocator.distanceBetween(
    driverLocation.latitude,
    driverLocation.longitude,
    destination.latitude,
    destination.longitude,
  );
  return distance;
}
