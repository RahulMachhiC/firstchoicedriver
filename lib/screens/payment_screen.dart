import 'package:first_choice_driver/common/app_google_map.dart';
import 'package:first_choice_driver/common/sizedbox.dart';
import 'package:first_choice_driver/controller/ride_provider.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/model/endride.dart';
import 'package:first_choice_driver/size_extension.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';

import '../common/commonbottombar.dart';

class PaymentScreen extends StatefulWidget {
  final EndRide endRide;
  final Set<Marker> markers;
  final String rideid;

  const PaymentScreen({
    super.key,
    required this.markers,
    required this.rideid,
    required this.endRide,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        bottomNavigationBar: CommonBottomBar(),
        body: Consumer<RideProvider>(builder: (
          context,
          controller,
          child,
        ) {
          if (controller.isloading) {
            SchedulerBinding.instance.addPostFrameCallback((
              timeStamp,
            ) {
              OverlayLoadingProgress.start(
                context,
              );
            });
          } else if (controller.iserror) {
            OverlayLoadingProgress.stop();
          }

          OverlayLoadingProgress.stop();
          return Stack(
            children: [
              AppGoogleMap(
                currentLocation: LatLng(controller.currentPosition!.latitude,
                    controller.currentPosition!.longitude),
                markers: widget.markers,
                polylines: Set<Polyline>.of(controller.polylines.values),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.greydark,
                        spreadRadius: 0,
                        blurRadius: 4,
                      )
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      sizedBoxWithHeight(25),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sizedBoxWithWidth(20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            //  crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.circle,
                                color: AppColors.black,
                                size: 10,
                              ),
                              SizedBox(
                                height: 60,
                                child: VerticalDivider(
                                  width: 20,
                                  indent: 4,
                                  endIndent: 4,
                                  thickness: 1.6,
                                  color: AppColors.black,
                                ),
                              ),
                              Icon(
                                Icons.location_on,
                                color: AppColors.black,
                                size: 15,
                              ),
                            ],
                          ),
                          sizedBoxWithWidth(4),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "4 min away",
                                  style: GoogleFonts.poppins(
                                    color: AppColors.black,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  widget.endRide.pickupAddress,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.grey500,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                sizedBoxWithHeight(10),
                                Text(
                                  "13 min (10 mi) trip",
                                  style: GoogleFonts.poppins(
                                    color: AppColors.black,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  widget.endRide.dropAddress,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.grey500,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      sizedBoxWithHeight(20),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 10.w,
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         "Waiting Amount",
                      //         textAlign: TextAlign.center,
                      //         style: GoogleFonts.poppins(
                      //           color: Colors.black,
                      //           fontSize: 12.sp,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //       // Text(
                      //       //   "-",
                      //       //   textAlign: TextAlign.center,
                      //       //   style: GoogleFonts.poppins(
                      //       //     color: Colors.black,
                      //       //     fontSize: 12.sp,
                      //       //     fontWeight: FontWeight.w500,
                      //       //   ),
                      //       // ),
                      //       Text(
                      //         "\$10",
                      //         textAlign: TextAlign.center,
                      //         style: GoogleFonts.poppins(
                      //           color: Colors.black,
                      //           fontSize: 12.sp,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 10.w,
                      //   ),
                      //   child: InkWell(
                      //     onTap: () {
                      //       setState(() {
                      //         isvisible = !isvisible;
                      //       });
                      //     },
                      //     child: Visibility(
                      //       visible: !isvisible,
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             "Tip  ",
                      //             style: GoogleFonts.poppins(
                      //               color: Colors.black,
                      //               fontSize: 12.sp,
                      //               fontWeight: FontWeight.w500,
                      //             ),
                      //           ),
                      //           Container(
                      //             decoration: BoxDecoration(
                      //               color: AppColors.green,
                      //               shape: BoxShape.circle,
                      //             ),
                      //             child: const Center(
                      //               child: Icon(
                      //                 Icons.add,
                      //                 color: Colors.white,
                      //                 size: 15,
                      //               ),
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Visibility(
                      //   visible: isvisible,
                      //   child: Padding(
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 10.w, vertical: 10.h),
                      //     child: Row(
                      //       children: [
                      //         Expanded(
                      //           child: TextFormField(
                      //             decoration: InputDecoration(
                      //                 suffixIcon: InkWell(
                      //                   onTap: () {
                      //                     setState(() {
                      //                       isvisible = !isvisible;
                      //                     });
                      //                   },
                      //                   child: const Icon(
                      //                     Icons.close,
                      //                   ),
                      //                 ),
                      //                 hintText: "Add Tip (\$)",
                      //                 isDense: true,
                      //                 border: OutlineInputBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(20))),
                      //           ),
                      //         ),
                      //         sizedBoxWithWidth(5),
                      //         Container(
                      //           padding: EdgeInsets.symmetric(
                      //             horizontal: 8.w,
                      //             vertical: 4.h,
                      //           ),
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(
                      //               20,
                      //             ),
                      //             gradient: LinearGradient(
                      //               colors: [
                      //                 AppColors.green,
                      //                 AppColors.yellow,
                      //               ],
                      //             ),
                      //           ),
                      //           child: const Icon(
                      //             Icons.send_rounded,
                      //             color: Colors.white,
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ride Amount",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Text(
                            //   "-",
                            //   textAlign: TextAlign.center,
                            //   style: GoogleFonts.poppins(
                            //     color: Colors.black,
                            //     fontSize: 12.sp,
                            //   ),
                            // ),
                            Text(
                              "\$${widget.endRide.rideAmount}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Waiting Charges",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Text(
                            //   "-",
                            //   textAlign: TextAlign.center,
                            //   style: GoogleFonts.poppins(
                            //     color: Colors.black,
                            //     fontSize: 12.sp,
                            //   ),
                            // ),
                            Text(
                              "\$${widget.endRide.waitingCharge}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Amount",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Text(
                            //   "-",
                            //   textAlign: TextAlign.center,
                            //   style: GoogleFonts.poppins(
                            //     color: Colors.black,
                            //     fontSize: 12.sp,
                            //   ),
                            // ),
                            Text(
                              "\$${widget.endRide.rideTotal}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      sizedBoxWithHeight(10),
                      InkWell(
                        onTap: () {
                          context.read<RideProvider>().paymentcollected(
                                context: context,
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
                              "Payment Collected",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      sizedBoxWithHeight(5)
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
