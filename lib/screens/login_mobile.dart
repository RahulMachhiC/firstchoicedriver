import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:first_choice_driver/common/sizedbox.dart';
import 'package:first_choice_driver/common/widgets/splashbackground.dart';
import 'package:first_choice_driver/controller/login_provider.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/helpers/text_style.dart';
import 'package:first_choice_driver/screens/login_password.dart';
import 'package:first_choice_driver/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';

import '../common/widgets/nextfloatingbutton.dart';

class LoginMobile extends StatefulWidget {
  const LoginMobile({super.key});

  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  LoginProvider loginProvider = LoginProvider();

  @override
  void initState() {
    loginProvider = context.read<LoginProvider>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Country country = Country(
    phoneCode: "1",
    countryCode: "CA",
    e164Sc: 1,
    geographic: false,
    level: 1,
    name: "CANADA",
    example: "",
    displayName: "Canada",
    displayNameNoCountryCode: "",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: InkWell(
            onTap: () async {
              if (loginProvider.phonecontroller.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: AppColors.green,
                  content: const Text(
                    "Please enter mobile number \n\n",
                  ),
                  duration: const Duration(seconds: 2),
                ));
              } else if (country.phoneCode == "+91") {
                if (loginProvider.phonecontroller.text.length != 10) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: AppColors.green,
                    content: const Text(
                      "Number should be 10 Characters\n\n",
                    ),
                    duration: const Duration(seconds: 2),
                  ));
                } else {
                  context.read<LoginProvider>().douserlogin(
                      context: context, countrycode: country.phoneCode);
                }
              } else if (country.phoneCode == "+1") {
                if (loginProvider.phonecontroller.text.length != 10) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: AppColors.green,
                    content: const Text(
                      "Number should be 10 Characters\n\n",
                    ),
                    duration: const Duration(seconds: 2),
                  ));
                } else {
                  context.read<LoginProvider>().douserlogin(
                      context: context, countrycode: country.phoneCode);
                }
              } else if (loginProvider.phonecontroller.text.length > 11) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: AppColors.green,
                  content: const Text(
                    "number should be 11 Characters long\n\n",
                  ),
                  duration: const Duration(seconds: 2),
                ));
              } else {
                context.read<LoginProvider>().douserlogin(
                    context: context, countrycode: country.phoneCode);
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NextFloatingButton(),
              ],
            ),
          ),
        ),
        backgroundColor: AppColors.appColor,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Consumer<LoginProvider>(
              builder: (context, logincontroller, child) {
            if (logincontroller.isloading) {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                OverlayLoadingProgress.start(
                  context,
                  color: Colors.lightGreen,
                );
              });
            } else if (logincontroller.iserror) {
              OverlayLoadingProgress.stop();
            }

            OverlayLoadingProgress.stop();

            return Column(
              children: [
                const SplashBackground(),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Enter your mobile number",
                                style: AppText.text22w500.copyWith(
                                  color: AppColors.black,
                                  fontSize: 18.sp,
                                ))
                            .animate()
                            .moveX(
                                curve: Curves.fastOutSlowIn,
                                duration: const Duration(milliseconds: 700)),
                        sizedBoxWithHeight(15),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                showCountryPicker(
                                  context: context,
                                  countryFilter: ["IN", "CA"],

                                  showPhoneCode:
                                      true, // optional. Shows phone code before the country name.
                                  onSelect: (Country scountry) {
                                    setState(() {
                                      country = scountry;
                                      log(scountry.name + scountry.countryCode);
                                    });
                                  },
                                );
                              },
                              child: Container(
                                width: 65.w,
                                height: 40.h,
                                color: AppColors.mobilegrey,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      country.flagEmoji,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                    sizedBoxWithWidth(10),
                                    Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: AppColors.black,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            sizedBoxWithWidth(10),
                            Expanded(
                              child: Container(
                                  height: 40.h,
                                  padding: EdgeInsets.only(left: 10.w),
                                  color: AppColors.mobilegrey,
                                  child: Row(
                                    children: [
                                      Text(country.phoneCode,
                                          style: AppText.text15Normal.copyWith(
                                            color: AppColors.black,
                                          )),
                                      sizedBoxWithWidth(10),
                                      Expanded(
                                        child: TextFormField(
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          maxLength: 11,
                                          cursorColor: AppColors.grey500,
                                          controller:
                                              logincontroller.phonecontroller,
                                          keyboardType: TextInputType.number,
                                          style: AppText.text15Normal.copyWith(
                                            color: AppColors.black,
                                          ),
                                          decoration: InputDecoration(
                                            counterText: '',
                                            isDense: true,
                                            hintText: " Mobile Number",
                                            hintStyle:
                                                AppText.text15Normal.copyWith(
                                              color: AppColors.hintColor,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ).animate().scaleXY(
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 700)),
                        sizedBoxWithHeight(8),
                        InkWell(
                          onTap: () {
                            if (logincontroller.phonecontroller.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: AppColors.green,
                                content: const Text(
                                  "Please enter mobile number",
                                ),
                                duration: const Duration(seconds: 2),
                              ));
                            } else if (logincontroller
                                    .phonecontroller.text.length !=
                                10) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: AppColors.green,
                                content: const Text(
                                  "Number should be 10 Characters",
                                ),
                                duration: const Duration(seconds: 2),
                              ));
                            } else if (logincontroller
                                    .phonecontroller.text.length >
                                11) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: AppColors.green,
                                content: const Text(
                                  "number should be 11 Characters long",
                                ),
                                duration: const Duration(seconds: 2),
                              ));
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPassword(
                                    countrycode: country.phoneCode,
                                    mobilenumner:
                                        logincontroller.phonecontroller.text,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Login with password",
                                style: GoogleFonts.poppins(
                                    color: AppColors.green,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ).animate().slideX(
                            begin: 10,
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 700)),
                        sizedBoxWithHeight(7),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 50.w,
                          ),
                          child: Text(
                              "By proceeding you are consenting to receive calls or SMS messages, including by automated dialer from FCDD and its affiliates to the number you provide",
                              style: AppText.text15w400.copyWith(
                                color: AppColors.colorgrey,
                                fontSize: 11.sp,
                              ))
                            ..animate().scaleX(
                                begin: 10,
                                curve: Curves.easeIn,
                                duration: const Duration(milliseconds: 700)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        )
        //  }),
        );
  }
}
