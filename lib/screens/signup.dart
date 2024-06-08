import 'package:first_choice_driver/common/widgets/nextfloatingbutton.dart';
import 'package:first_choice_driver/controller/signup_provider.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/helpers/string_extension.dart';
import 'package:first_choice_driver/screens/login_mobile.dart';
import 'package:first_choice_driver/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';

import '../common/sizedbox.dart';
import '../helpers/text_style.dart';

class SignUp extends StatefulWidget {
  final String userid;

  const SignUp({super.key, required this.userid});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginMobile()),
            (route) => false);
        return false;
      },
      child: Consumer<SignupProvider>(builder: (context, controller, child) {
        if (controller.isloading) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            OverlayLoadingProgress.start(
              context,
              color: Colors.black,
            );
          });
        } else if (controller.iserror) {
          OverlayLoadingProgress.stop();
        }

        OverlayLoadingProgress.stop();
        return Scaffold(
          backgroundColor: AppColors.appColor,
          // floatingActionButton: Visibility(
          //   visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          //   child:
          // ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizedBoxWithHeight(0),
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginMobile()),
                            (route) => false);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.black,
                        size: 20,
                      ),
                    ),
                    sizedBoxWithHeight(10),
                    Text("Create New Account",
                        style: AppText.text22w500.copyWith(
                          color: AppColors.black,
                        )),
                    sizedBoxWithHeight(20),
                    InkWell(
                      onTap: () {
                        controller.selectimage(context: context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              height: 90.h,
                              width: 90.w,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: controller.profilepic == null
                                  ? Icon(
                                      Icons.person,
                                      size: 40.sp,
                                    )
                                  : Image.file(
                                      controller.profilepic!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(-24, 40),
                            child: Container(
                                padding: EdgeInsets.all(4.r),
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.add,
                                  size: 10.sp,
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                    ),
                    sizedBoxWithHeight(20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey.shade300,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        controller: controller.nameController,
                        cursorColor: AppColors.grey500,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Enter your name",
                          hintStyle: GoogleFonts.poppins(
                            color: AppColors.hintColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    sizedBoxWithHeight(20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey.shade300,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: controller.emailController,
                        cursorColor: AppColors.grey500,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Enter your email",
                          hintStyle: GoogleFonts.poppins(
                            color: AppColors.hintColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    sizedBoxWithHeight(20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey.shade300,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: AppColors.grey500,
                        obscureText:
                            controller.ispasswordvisible ? false : true,
                        controller: controller.passwordController,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                              onTap: () {
                                controller.changepasswordvisiblity();
                              },
                              child: Icon(
                                controller.ispasswordvisible
                                    ? Icons.remove_red_eye
                                    : Icons.visibility_off_rounded,
                                color: AppColors.black,
                              )),
                          isDense: true,
                          hintText: "Password",
                          hintStyle: GoogleFonts.poppins(
                            color: AppColors.hintColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    sizedBoxWithHeight(20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey.shade300,
                      ),
                      child: TextFormField(
                        obscureText: controller.isconfirmvisible ? false : true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: controller.cPassController,
                        cursorColor: AppColors.grey500,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                              onTap: () {
                                controller.changeconfirmpasswordvisiblity();
                              },
                              child: Icon(
                                controller.isconfirmvisible
                                    ? Icons.remove_red_eye
                                    : Icons.visibility_off_rounded,
                                color: AppColors.black,
                              )),
                          isDense: true,
                          hintText: "Confirm Password",
                          hintStyle: GoogleFonts.poppins(
                            color: AppColors.hintColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    sizedBoxWithHeight(20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey.shade300,
                      ),
                      child: TextFormField(
                        controller: controller.licensenumberController,
                        cursorColor: AppColors.grey500,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Enter your driving licence number",
                          hintStyle: GoogleFonts.poppins(
                            color: AppColors.hintColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    sizedBoxWithHeight(20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey.shade300,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        onTap: () {
                          controller.selectDate(context);
                        },
                        controller: controller.expiryController,
                        cursorColor: AppColors.grey500,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Driving licence expiry date",
                          hintStyle: GoogleFonts.poppins(
                            color: AppColors.hintColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    sizedBoxWithHeight(10),
                    Text(
                      "Upload Driving Licence Image",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    sizedBoxWithHeight(5),
                    InkWell(
                      onTap: () {
                        controller.selectlicenceimage(context: context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.green,
                                AppColors.yellow,
                              ],
                            )),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.file_upload_outlined,
                              color: Colors.white,
                              size: 15.sp,
                            ),
                            Text(
                              "Choose Image",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    controller.licencepic != null
                        ? Column(
                            children: [
                              sizedBoxWithHeight(20),
                              Container(
                                width: double.infinity,
                                height: 120.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                  image: DecorationImage(
                                    image: FileImage(
                                      controller.licencepic!,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Transform.translate(
                                  offset: const Offset(170, -70),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        controller.licencepic = null;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(57),
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    sizedBoxWithHeight(20),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                          onTap: () {
                            // QuickAlert.show(
                            //     context: context,
                            //     type: QuickAlertType.info,
                            //     confirmBtnColor: AppColors.green,
                            //     text:
                            //         "Account Registered Successfully\nplease wait for 24 hours we are reviewing your licence details");
                            if (controller.nameController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: AppColors.green,
                                content: const Text("Please Enter Name"),
                                duration: const Duration(seconds: 2),
                              ));
                            } else if (controller.emailController.text
                                    .isValidEmail() ==
                                false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.green,
                                  content:
                                      const Text("Please Enter Valid Email"),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            } else if (controller
                                .passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: AppColors.green,
                                content: const Text("Please Enter Password"),
                                duration: const Duration(seconds: 2),
                              ));
                            } else if (controller
                                    .passwordController.text.length <
                                8) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: AppColors.green,
                                content: const Text(
                                    "Minimum 8 Characters Required "),
                                duration: const Duration(seconds: 2),
                              ));
                            } else if (controller.passwordController.text !=
                                controller.cPassController.text) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: AppColors.green,
                                content: const Text("Password not match"),
                                duration: const Duration(seconds: 2),
                              ));
                            } else if (controller
                                .licensenumberController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: AppColors.green,
                                content:
                                    const Text("Please Enter License Number"),
                                duration: const Duration(seconds: 2),
                              ));
                            } else if (controller
                                .expiryController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: AppColors.green,
                                content:
                                    const Text("Please Select Licence Expiry"),
                                duration: const Duration(seconds: 2),
                              ));
                            } else if (controller.licencepic == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: AppColors.green,
                                content: const Text("Please select licence"),
                                duration: const Duration(seconds: 2),
                              ));
                            } else if (controller.profilepic == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: AppColors.green,
                                content:
                                    const Text("Please Select Profile Pic"),
                                duration: const Duration(seconds: 2),
                              ));
                            } else {
                              controller.dousersignup(
                                  context: context, userid: widget.userid);
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => PagesWidget(),
                              //   ),
                              // );
                            }
                          },
                          child: const NextFloatingButton()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
