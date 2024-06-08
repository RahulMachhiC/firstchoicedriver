import 'package:first_choice_driver/common/widgets/nextfloatingbutton.dart';
import 'package:first_choice_driver/controller/login_provider.dart';
import 'package:first_choice_driver/helpers/text_style.dart';
import 'package:first_choice_driver/screens/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../common/sizedbox.dart';
import '../helpers/colors.dart';

class LoginPassword extends StatefulWidget {
  final String mobilenumner;
  final String countrycode;
  const LoginPassword({
    super.key,
    required this.mobilenumner,
    required this.countrycode,
  });

  @override
  State<LoginPassword> createState() => _LoginPasswordState();
}

class _LoginPasswordState extends State<LoginPassword> {
  @override
  void initState() {
    super.initState();
  }

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
      return Scaffold(
        backgroundColor: AppColors.appColor,
        floatingActionButton: InkWell(
            onTap: () {
              if (loginprovider.passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: AppColors.green,
                  content: const Text(
                    "Please Enter Password \n\n",
                  ),
                  duration: const Duration(seconds: 2),
                ));
              } else if (loginprovider.passwordController.text.length < 8) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: AppColors.green,
                  content: const Text(
                    "Minimum 8 Characters Required \n\n",
                  ),
                  duration: const Duration(seconds: 2),
                ));
              } else {
                loginprovider.loginbypassword(
                  context: context,
                  countrycode: widget.countrycode,
                );
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
                  sizedBoxWithHeight(0),
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
                  Text("Welcome back, Signin to\ncontinue",
                          style: AppText.text22w500.copyWith(
                            color: AppColors.black,
                          ))
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .then(delay: 200.ms) // baseline=800ms
                      .slide(),
                  sizedBoxWithHeight(80),
                  Container(
                    color: Colors.grey.shade300,
                    child: TextFormField(
                      controller: loginprovider.passwordController,
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
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPassword(),
                        ),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
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
    });
  }
}
