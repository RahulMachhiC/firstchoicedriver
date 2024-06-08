import 'dart:developer';

import 'package:first_choice_driver/common/app_image.dart';
import 'package:first_choice_driver/controller/ride_provider.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/sizedbox.dart';

Widget driverarrived({
  required RideProvider provider,
  required Set<Marker> markers,
  required String rideid,
  required BuildContext context,
  required String latitude,
}) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Waiting for user",
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
              Container(
                height: 40.h,
                width: 40.h,
                color: AppColors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${provider.minutes} min",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          sizedBoxWithHeight(20),
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
                sizedBoxWithHeight(10),
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
                            provider.currentRide != null
                                ? provider.currentRide!.customerName
                                : provider.driverArrived!.customerName,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
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
                                provider.currentRide != null
                                    ? provider.currentRide!.customerRating
                                    : provider.driverArrived!.customerRating,
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
                      Row(
                        children: [
                          sizedBoxWithWidth(20),
                          InkWell(
                            onTap: () async {
                              String telephoneNumber =
                                  provider.currentRide != null
                                      ? provider.currentRide!.customerMobile
                                      : provider.driverArrived!.customerMobile;
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
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        separatorBuilder: (context, index) => Divider(
                              color: AppColors.black,
                            ),
                        itemCount: provider.currentRide!.dropLocation.length,
                        itemBuilder: (context, index) {
                          return Text(
                            "Drop Location : ${provider.currentRide?.dropLocation.elementAt(index).address ?? provider.driverArrived!.dropLocation.elementAt(index).address}",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500),
                          );
                        })),
                SizedBox(
                  height: 5.h,
                ),
                InkWell(
                  onTap: () {
                    context.read<RideProvider>().startride(
                          context: context,
                          markers: markers,
                        );
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
                        "Start",
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
