import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_choice_driver/api/app_repository.dart';
import 'package:first_choice_driver/helpers/strings.dart';
import 'package:first_choice_driver/model/login.dart';
import 'package:first_choice_driver/model/passwordlogin.dart';
import 'package:first_choice_driver/model/verityotp.dart';
import 'package:first_choice_driver/screens/login_mobile.dart';
import 'package:first_choice_driver/screens/otp_login.dart';
import 'package:first_choice_driver/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/bottomnavigationbar.dart';
import '../helpers/colors.dart';

class LoginProvider extends ChangeNotifier {
  LoginResponse? login;
  bool isloading = false;
  bool islicenceverified = true;
  bool iserror = false;
  String errortext = "";

  TextEditingController phonecontroller = TextEditingController();
  TextEditingController otpcontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController forgotMobileController = TextEditingController();
  TextEditingController forgotpasswordController = TextEditingController();
  TextEditingController forgotCpasswordController = TextEditingController();

  void customdispose() {
    phonecontroller.clear();
    otpcontroller.clear();
    forgotMobileController.clear();
    forgotCpasswordController.clear();
    forgotCpasswordController.clear();
    errortext = "";
    iserror = false;
    isloading = false;
    login = null;
    passwordController.clear();
    notifyListeners();
  }

  void reset() {
    iserror = false;
    isloading = false;
    notifyListeners();
  }

  Future<void> douserlogin({
    required BuildContext context,
    required String countrycode,
  }) async {
    isloading = true;

    final fcmToken = await FirebaseMessaging.instance.getToken();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    notifyListeners();
    await AppRepository()
        .douserlogin(
      devicetype: Platform.isAndroid ? "1" : "2",
      mobilenumber: "+$countrycode${phonecontroller.text}",
      fcm: fcmToken!,
    )
        .then((value) {
      if (value["code"] == 201) {
        isloading = false;
        iserror = true;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.green,
          content: Text(
            "${value["message"].toString()} \n\n ",
          ),
          duration: const Duration(seconds: 2),
        ));

        notifyListeners();
      } else if (value["code"] == 401) {
        isloading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.green,
          content: Text(
            " ${value["message"]} \n\n",
          ),
          duration: const Duration(seconds: 2),
        ));

        notifyListeners();
      } else if (value["code"] == 200) {
        isloading = false;

        login = LoginResponse.fromJson(value);

        preferences.setString(Strings().accesstoken, login!.accessToken);
        reset();

        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => OtpLogin(
                    message: value["message"],
                    counterText: countrycode,
                  )),
        );

        isloading = false;

        notifyListeners();
      }
    }).catchError((e) {
      iserror = true;

      isloading = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.green,
        content: Text(
          "${e.toString()} \n\n ",
        ),
        duration: const Duration(seconds: 2),
      ));

      errortext = e.toString();
      notifyListeners();
    });
  }

  Future<void> verifyotp({
    required BuildContext context,
    required String countryCode,
  }) async {
    isloading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();
    try {
      await AppRepository()
          .verifyOTP(
        otp: otpcontroller.text,
        mobilenumber: "+$countryCode${phonecontroller.text}",
      )
          .then((value) async {
        if (value["code"] == 401) {
          isloading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.green,
            content: Text(
              " ${value["message"]} \n\n",
            ),
            duration: const Duration(seconds: 2),
          ));
          notifyListeners();
        } else if (value["code"] == 201) {
          isloading = false;
          iserror = true;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.green,
            content: Text(
              " ${value["message"]} \n\n",
            ),
            duration: const Duration(seconds: 2),
          ));
          notifyListeners();
        } else if (value["code"] == 200) {
          final verifyotp = VerifyOtp.fromJson(value);
          if (verifyotp.alreadyRegistered == false) {
            OverlayLoadingProgress.stop();

            // removeListener(() {});
            isloading = false;
            notifyListeners();
            otpcontroller.clear();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUp(
                        userid: verifyotp.driverId,
                      )),
              (route) => false,
            );
          } else {
            if (verifyotp.licenseVerified == false) {
              OverlayLoadingProgress.stop();
              isloading = false;

              islicenceverified = verifyotp.licenseVerified;
              notifyListeners();
            } else {
              await prefs
                  .setString(
                Strings().userid,
                verifyotp.driverId,
              )
                  .whenComplete(() {
                OverlayLoadingProgress.stop();
                otpcontroller.clear();
                phonecontroller.clear();
                passwordController.clear();
                islicenceverified = true;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => PagesWidget()),
                  (route) => false,
                );
              });
            }
            //
          }
        }
      });
    } on Exception catch (e) {
      iserror = true;

      isloading = false;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.green,
          content: Text(
            "${e.toString()} \n\n",
          ),
          duration: const Duration(seconds: 2),
        ));
      });
      errortext = e.toString();
      notifyListeners();
    }
  }

  Future<void> loginbypassword({
    required BuildContext context,
    required String countrycode,
  }) async {
    isloading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();
    try {
      await AppRepository()
          .loginbypassword(
        password: passwordController.text,
        countrycode: countrycode,
        // accesstoken: prefs.getString(
        //   Strings().accesstoken,
        // )!,
        mobilenumber: phonecontroller.text,
      )
          .then((value) async {
        if (value["code"] == 401) {
          isloading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.green,
            content: Text(
              " ${value["message"]} \n\n",
            ),
            duration: const Duration(seconds: 2),
          ));
          notifyListeners();
        } else if (value["code"] == 201) {
          isloading = false;
          iserror = true;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.green,
            content: Text(" ${value["message"]} \n\n"),
            duration: const Duration(seconds: 2),
          ));
          notifyListeners();
        } else if (value["code"] == 200) {
          final verifyotp = Passwordlogin.fromJson(value);
          prefs.setString(Strings().accesstoken, verifyotp.accessToken);

          if (verifyotp.alreadyRegistered == false) {
            OverlayLoadingProgress.stop();

            // removeListener(() {});
            isloading = false;
            passwordController.clear();
            notifyListeners();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUp(
                        userid: verifyotp.driverId,
                      )),
              (route) => false,
            );
          } else {
            if (verifyotp.licenseVerified == false) {
              OverlayLoadingProgress.stop();
              isloading = false;

              islicenceverified = verifyotp.licenseVerified;
              notifyListeners();
            } else {
              await prefs
                  .setString(
                Strings().userid,
                verifyotp.driverId,
              )
                  .whenComplete(() {
                OverlayLoadingProgress.stop();
                otpcontroller.clear();
                phonecontroller.clear();
                passwordController.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => PagesWidget()),
                  (route) => false,
                );
              });
            }
          }
          //
        }
      });
    } on Exception catch (e) {
      iserror = true;

      isloading = false;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.green,
          content: Text(
            "${e.toString()} \n\n",
          ),
          duration: const Duration(seconds: 2),
        ));
      });
      errortext = e.toString();
      notifyListeners();
    }
  }

  Future<void> forgotpassword({required BuildContext context}) async {
    isloading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();
    try {
      await AppRepository()
          .forgotpassword(
        password: forgotpasswordController.text,
        mobile: forgotMobileController.text,
      )
          .then((value) async {
        if (value["code"] == 401) {
          isloading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.green,
            content: Text(
              " ${value["message"]} \n\n",
            ),
            duration: const Duration(seconds: 2),
          ));
          notifyListeners();
        } else if (value["code"] == 201) {
          isloading = false;
          iserror = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.green,
              content: Text(" ${value["message"]} \n\n"),
              duration: const Duration(seconds: 2),
            ),
          );
          notifyListeners();
        } else if (value["code"] == 200) {
          OverlayLoadingProgress.stop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.green,
            content: Text(" ${value["message"]} \n\n"),
            duration: const Duration(seconds: 2),
          ));

          // removeListener(() {});
          isloading = false;
          notifyListeners();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginMobile()),
            (route) => false,
          );

          //
        }
      });
    } on Exception catch (e) {
      iserror = true;

      isloading = false;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.green,
          content: Text(
            "${e.toString()} \n\n",
          ),
          duration: const Duration(seconds: 2),
        ));
      });
      errortext = e.toString();
      notifyListeners();
    }
  }

  Future<void> resentOTP({required BuildContext context}) async {
    isloading = true;

    final fcmToken = await FirebaseMessaging.instance.getToken();
    notifyListeners();
    await AppRepository()
        .douserlogin(
      devicetype: Platform.isAndroid ? "1" : "2",
      mobilenumber: phonecontroller.text,
      fcm: fcmToken!,
    )
        .then((value) {
      if (value["code"] == 201) {
        isloading = false;
        iserror = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.green,
          content: Text(" ${value["message"]} \n\n"),
          duration: const Duration(seconds: 2),
        ));
        notifyListeners();
      } else if (value["code"] == 401) {
        isloading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.green,
          content: Text(" ${value["message"]} \n\n"),
          duration: const Duration(seconds: 2),
        ));
        notifyListeners();
      } else if (value["code"] == 200) {
        isloading = false;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.green,
          content: Text(" ${value["message"]} \n\n"),
          duration: const Duration(seconds: 2),
        ));
        notifyListeners();
      }
    }).catchError((e) {
      iserror = true;

      isloading = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.green,
        content: Text(
          " ${e.toString()} \n\n",
        ),
        duration: const Duration(seconds: 2),
      ));
      errortext = e.toString();
      notifyListeners();
    });
  }
}
