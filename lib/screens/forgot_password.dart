import 'package:first_choice_driver/common/sizedbox.dart';
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

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, loginprovider, child) {
      if (loginprovider.isloading) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          OverlayLoadingProgress.start(
            context,
            color: Colors.red,
          );
        });
      } else if (loginprovider.iserror) {
        OverlayLoadingProgress.stop();
      }
      OverlayLoadingProgress.stop();
      return Scaffold(
        backgroundColor: AppColors.appColor,
        floatingActionButton: InkWell(
            onTap: () {
              if (loginprovider.forgotpasswordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: AppColors.green,
                  content: const Text(
                    "Please Enter Password \n\n",
                  ),
                  duration: const Duration(seconds: 2),
                ));
              } else if (loginprovider.forgotMobileController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: AppColors.green,
                  content: const Text(
                    "Please Enter Mobile Number \n\n",
                  ),
                  duration: const Duration(seconds: 2),
                ));
              } else if (loginprovider.forgotpasswordController.text.length <
                  8) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: AppColors.green,
                  content: const Text(
                    "Minimum 8 Characters Required \n\n",
                  ),
                  duration: const Duration(seconds: 2),
                ));
              } else if (loginprovider.forgotpasswordController.text !=
                  loginprovider.forgotCpasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: AppColors.green,
                  content: const Text("Password not match"),
                  duration: const Duration(seconds: 2),
                ));
              } else {
                loginprovider.forgotpassword(context: context);
                // AppEnvironment.navigator.pushNamed(AuthRoutes.signup);
              }
            },
            child: const NextFloatingButton()),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.black,
                      size: 20,
                    ),
                  ),
                  sizedBoxWithHeight(30),
                  Text("Forgotten Password,\nDon't Worry",
                          style: AppText.text22w500.copyWith(
                            color: AppColors.black,
                          ))
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .then(delay: 200.ms) // baseline=800ms
                      .slide(),
                  sizedBoxWithHeight(40),
                  Container(
                    color: Colors.grey.shade300,
                    child: TextFormField(
                      controller: loginprovider.forgotMobileController,
                      cursorColor: AppColors.grey500,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          isDense: true,
                          // fillColor: Colors.grey.shade300,
                          // filled: true,

                          hintText: "Enter Mobile No.",
                          hintStyle: GoogleFonts.nunito(
                            color: AppColors.black,
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
                          ))),
                    ),
                  )
                      .animate()
                      .flip(duration: 600.ms)
                      .then(delay: 200.ms) // baseline=800ms
                      .slide(),
                  sizedBoxWithHeight(20),
                  Container(
                    color: Colors.grey.shade300,
                    child: TextFormField(
                      controller: loginprovider.forgotpasswordController,
                      cursorColor: AppColors.grey500,
                      obscureText: true,
                      decoration: InputDecoration(
                          isDense: true,
                          // fillColor: Colors.grey.shade300,
                          // filled: true,

                          hintText: "Enter password",
                          hintStyle: GoogleFonts.nunito(
                            color: AppColors.black,
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
                          ))),
                    ),
                  )
                      .animate()
                      .flip(duration: 600.ms)
                      .then(delay: 200.ms) // baseline=800ms
                      .slide(),
                  sizedBoxWithHeight(20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                    ),
                    child: TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      controller: loginprovider.forgotCpasswordController,
                      cursorColor: AppColors.grey500,
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: "Confirm Password",
                          hintStyle: GoogleFonts.nunito(
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
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
                          ))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
