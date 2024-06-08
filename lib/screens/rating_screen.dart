import 'package:first_choice_driver/common/app_image.dart';
import 'package:first_choice_driver/common/bottomnavigationbar.dart';
import 'package:first_choice_driver/common/commonbottombar.dart';
import 'package:first_choice_driver/common/sizedbox.dart';
import 'package:first_choice_driver/controller/ride_provider.dart';
import 'package:first_choice_driver/helpers/text_style.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/model/payment_collected.dart';
import 'package:first_choice_driver/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';

class RatingScreen extends StatefulWidget {
  final PaymentCollected paymentCollected;
  final String rideid;
  const RatingScreen({
    super.key,
    required this.rideid,
    required this.paymentCollected,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        return WillPopScope(
          onWillPop: () async {
            controller.reset();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PagesWidget(),
              ),
            );
            return false;
          },
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10.r),
                  padding: EdgeInsets.all(10.r),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.green,
                        AppColors.yellow,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: () {
                                  controller.reset();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PagesWidget(),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                        AppImage(
                          "assets/user.png",
                          height: 70.h,
                          width: 70.w,
                        ),
                        sizedBoxWithHeight(15),
                        RatingBar.builder(
                          updateOnDrag: true,
                          initialRating: double.parse(controller.rating),
                          minRating: 1,
                          direction: Axis.horizontal,
                          ignoreGestures: false,
                          allowHalfRating: true,
                          unratedColor: Colors.white,
                          itemCount: 5,
                          itemSize: 19,
                          itemPadding: const EdgeInsets.symmetric(
                            horizontal: 3,
                          ),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 10,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              controller.rating = rating.toString();
                            });
                          },
                        ),
                        sizedBoxWithHeight(15),
                        Text(
                          "Give a compliment?",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        sizedBoxWithHeight(45),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (controller.rating == "0" &&
                        controller.ratingcontroller.text.isEmpty) {
                      controller.reset();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PagesWidget(),
                        ),
                      );
                    } else {
                      controller.riderating(
                        context: context,
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                          top: 100.h,
                        ) +
                        EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                    ),
                    width: double.infinity,
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
                        "Submit",
                        style:
                            AppText.text15Normal.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -150),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.greylight,
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: const Offset(0, 4))
                        ]),
                    clipBehavior: Clip.antiAlias,
                    child: TextFormField(
                      controller: controller.ratingcontroller,
                      readOnly: false,
                      decoration: InputDecoration(
                        hintText: "Type your message hear ...",
                        hintStyle: GoogleFonts.poppins(
                          color: AppColors.hintColor,
                          fontSize: 12.sp,
                        ),
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
