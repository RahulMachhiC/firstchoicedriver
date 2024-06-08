import 'package:first_choice_driver/common/app_image.dart';
import 'package:first_choice_driver/common/sizedbox.dart';
import 'package:first_choice_driver/controller/driverstatus_provider.dart';
import 'package:first_choice_driver/controller/ride_provider.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/model/riderequestnoti.dart';
import 'package:first_choice_driver/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Widget acceptrejectride({
  required BuildContext context,
  required DriverStatusProvider provider,
  required RideRequestModel? rideRequestModel,
  required VoidCallback callback,
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
            bottom: 50.h,
          ),
      color: Colors.white,
      child: Container(
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
                        rideRequestModel == null
                            ? "N/A"
                            : rideRequestModel.customerName,
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
                            "4.8",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            rideRequestModel != null
                ? Text(
                    "Pickup Note: ${rideRequestModel.notes}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500),
                  )
                : const SizedBox(),
            InkWell(
              onTap: callback,
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
                    "Accept",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            sizedBoxWithHeight(10),
            InkWell(
              onTap: () {
                context.read<RideProvider>().rejectride(context: context);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: 8.h,
                ),
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
                child: Center(
                  child: Text(
                    "Decline",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
