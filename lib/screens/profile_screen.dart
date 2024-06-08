import 'package:first_choice_driver/api/app_repository.dart';
import 'package:first_choice_driver/common/bottomnavigationbar.dart';
import 'package:first_choice_driver/controller/profile_provider.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/helpers/string_extension.dart';
import 'package:first_choice_driver/helpers/strings.dart';
import 'package:first_choice_driver/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/sizedbox.dart';
import '../helpers/text_style.dart';

class ProfileScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  const ProfileScreen({super.key, this.parentScaffoldKey});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    context.read<ProfileProvider>().getdriverprofile(
          context: context,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      // floatingActionButton: Visibility(
      //   visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
      //   child:
      // ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PagesWidget(
                  currentTab: 0,
                ),
              ),
            );
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.black,
            size: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<ProfileProvider>(builder: (context, controller, child) {
          if (controller.isloading) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              OverlayLoadingProgress.start(
                context,
              );
            });
          } else if (controller.iserror) {
            OverlayLoadingProgress.stop();
          }

          OverlayLoadingProgress.stop();
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      controller.changeselectedImage(context: context);
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
                              child: controller.userimageicon()),
                        ),
                        Transform.translate(
                          offset: const Offset(-24, 40),
                          child: Container(
                            padding: EdgeInsets.all(4.r),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 10.sp,
                              color: Colors.white,
                            ),
                          ),
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
                      keyboardType: TextInputType.emailAddress,
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
                      controller: controller.mobileController,
                      readOnly: true,
                      cursorColor: AppColors.grey500,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Enter your mobile",
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
                      obscureText: controller.ispasswordvisible ? false : true,
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
                      keyboardType: TextInputType.emailAddress,
                      controller: controller.linencenumberController,
                      readOnly: true,
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
                      keyboardType: TextInputType.emailAddress,
                      controller: controller.expiryDateController,
                      onTap: () {
                        controller.selectDate(context);
                      },
                      cursorColor: AppColors.grey500,
                      readOnly: true,
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
                  InkWell(
                    onTap: () {
                      controller.selectlicenceimage(context: context);
                    },
                    child: Container(
                      height: 90.h,
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        image: controller.licenseImage == null
                            ? DecorationImage(
                                image: NetworkImage(controller.driverProfile ==
                                        null
                                    ? "https://images-wixmp-530a50041672c69d335ba4cf.wixmp.com/templates/image/5bf41cca049f03cdc7e842db2201172d6cc1a6b173e8db293a3b880ecc5836561616582409012.jpg"
                                    : controller.driverProfile!.licensePhoto))
                            : DecorationImage(
                                image: FileImage(
                                  controller.licenseImage!,
                                ),
                              ),
                      ),
                      child: Transform.translate(
                        offset: const Offset(144, -50),
                        child: Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 10.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  sizedBoxWithHeight(20),
                  InkWell(
                    onTap: () {
                      if (controller.emailController.text.isValidEmail() ==
                          false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.green,
                            content: const Text("Please Enter Valid Email"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else if (controller
                          .passwordController.text.isNotEmpty) {
                        if (controller.passwordController.text.length < 8) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: AppColors.green,
                            content:
                                const Text("Minimum 8 Characters Required"),
                            duration: const Duration(seconds: 2),
                          ));
                        } else if (controller.passwordController.text !=
                            controller.cPassController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: AppColors.green,
                            content: const Text("Password not match"),
                            duration: const Duration(seconds: 2),
                          ));
                        } else {
                          FocusScope.of(context).unfocus();

                          controller.updatedriverprofile(context: context);
                        }
                      } else {
                        FocusScope.of(context).unfocus();

                        controller.updatedriverprofile(context: context);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                        bottom: 10.h,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.green,
                            AppColors.yellow,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: Text("Update Profile",
                            style: AppText.text18w400.copyWith(
                              color: Colors.white,
                              fontSize: 16.sp,
                            )),
                      ),
                    ),
                  ),
                  sizedBoxWithHeight(10),
                  InkWell(
                    onTap: () {
                      _logout();
                    },
                    child: Center(
                      child: Text(
                        "Sign Out",
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.colorRed,
                        ),
                      ),
                    ),
                  ),
                  sizedBoxWithHeight(20),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> _logout() async {
    OverlayLoadingProgress.start(
      context,
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await AppRepository()
          .douserlogout(
              accesstoken: prefs.getString(
                Strings().accesstoken,
              )!,
              userid: prefs.getString(Strings().userid)!)
          .then((value) {
        if (value["code"] == 201) {
          OverlayLoadingProgress.stop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.green,
            content: Text(" ${value["message"]} \n\n"),
            duration: const Duration(seconds: 2),
          ));
        } else if (value["code"] == 200) {
          OverlayLoadingProgress.stop();

          // BlocProvider.of<DashboardBloc>(context).add(
          //   InitBloc(),
          // );
          Restart.restartApp();

          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute<void>(
          //       builder: (BuildContext context) => const LoginMobile()),
          //   (route) {
          //     return true;
          //   },
          // );

          prefs.clear();
        }
      });
    } catch (e) {
      OverlayLoadingProgress.stop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.green,
        content: Text(
          " ${e.toString()} \n\n",
        ),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      OverlayLoadingProgress.stop();
    }
  }
}
