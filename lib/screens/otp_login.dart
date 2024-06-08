import 'package:first_choice_driver/common/widgets/nextfloatingbutton.dart';
import 'package:first_choice_driver/controller/login_provider.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../common/sizedbox.dart';

class OtpLogin extends StatefulWidget {
  final String message;
  final String counterText;
  const OtpLogin({super.key, required this.message, required this.counterText});

  @override
  State<OtpLogin> createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.green,
        content: Text("${widget.message} \n\n"),
        duration: const Duration(seconds: 2),
      ));

      // toast.successToast(context,
      //     alignment: Alignment.bottomCenter, message: widget.message);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<LoginProvider>().otpcontroller.clear();
        Navigator.pop(context);
        return false;
      },
      child: Consumer<LoginProvider>(builder: (context, loginprovider, child) {
        if (loginprovider.isloading) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            OverlayLoadingProgress.start(
              context,
              color: Colors.red,
            );
          });
        } else if (loginprovider.islicenceverified == false) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.warning,
              confirmBtnColor: AppColors.green,
              text:
                  "Your Account is not activited yet\nwe will notify you when its activited",
            );
          });
        } else if (loginprovider.iserror) {
          OverlayLoadingProgress.stop();
        }
        OverlayLoadingProgress.stop();

        //   //  context.loaderOverlay.hide();
        return Scaffold(
          backgroundColor: AppColors.appColor,
          floatingActionButton: InkWell(
            onTap: () {
              if (loginprovider.otpcontroller.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: AppColors.green,
                  content: const Text(
                    "Please Enter OTP \n\n",
                  ),
                  duration: const Duration(seconds: 2),
                ));
                // toast.errorToast(context,
                //     alignment: Alignment.bottomCenter,
                //     message: "");
              } else if (loginprovider.otpcontroller.text.length != 4) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: AppColors.green,
                  content: const Text(
                    "OTP length should be 4 character \n\n",
                  ),
                  duration: const Duration(seconds: 2),
                ));
                // toast.errorToast(context,
                //     alignment: Alignment.bottomCenter,
                //     message: "");
              } else {
                context.read<LoginProvider>().verifyotp(
                    context: context, countryCode: widget.counterText);
              }
            },
            child: const NextFloatingButton(),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizedBoxWithHeight(0),
                    InkWell(
                      onTap: () {
                        loginprovider.otpcontroller.clear();
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.black,
                        size: 20,
                      ),
                    ),
                    sizedBoxWithHeight(10),
                    Text("Verify your phone number",
                        style: AppText.text22w500.copyWith(
                          color: AppColors.black,
                        )).animate()
                      ..flipV(duration: 600.ms)
                          .then(delay: 200.ms) // baseline=800ms
                          .slide(),
                    sizedBoxWithHeight(40),
                    Text(
                      "Enter the 4-digit code sent to you",
                      style: AppText.text16w400.copyWith(
                        color: AppColors.grey500,
                      ),
                    )
                        .animate()
                        .flipH(duration: 600.ms)
                        .then(delay: 200.ms) // baseline=800ms
                        .slide(),
                    sizedBoxWithHeight(15),
                    Container(
                      color: Colors.grey.shade300,
                      child: TextFormField(
                        cursorColor: AppColors.grey500,
                        maxLength: 4,
                        controller: loginprovider.otpcontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: '',
                          isDense: true,
                          hintText: " Enter the OTP code",
                          hintStyle: GoogleFonts.nunito(
                            color: AppColors.hintColor,
                            fontWeight: FontWeight.w400,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: AppColors.black,
                            width: 1,
                          )),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .slideX(duration: 600.ms)
                        .then(delay: 200.ms) // baseline=800ms
                        .slide(),
                    sizedBoxWithHeight(20),
                    InkWell(
                      onTap: () {
                        context
                            .read<LoginProvider>()
                            .resentOTP(context: context);
                      },
                      child: Text(
                        "Resend code via SMS",
                        style: GoogleFonts.nunito(
                          color: Colors.blue.shade800,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .then(delay: 200.ms) // baseline=800ms
                          .slide(),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        // });
      }),
    );
  }
}
