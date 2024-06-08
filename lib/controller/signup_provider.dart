import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_choice_driver/api/app_repository.dart';
import 'package:first_choice_driver/controller/login_provider.dart';
import 'package:first_choice_driver/helpers/strings.dart';
import 'package:first_choice_driver/notification.dart';
import 'package:first_choice_driver/screens/login_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/colors.dart';

class SignupProvider extends ChangeNotifier {
  bool isloading = false;
  bool iserror = false;
  String errortext = '';
  File? profilepic;
  File? licencepic;
  TextEditingController nameController = TextEditingController();
  TextEditingController licensenumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cPassController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController expiryController = TextEditingController();

  bool ispasswordvisible = false;

  bool isconfirmvisible = false;

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  void changepasswordvisiblity() {
    ispasswordvisible = !ispasswordvisible;
    notifyListeners();
  }

  void selectimage({required BuildContext context}) {
    pickFile(context: context).then((value) {
      cropImage(value!).then(
        (value) {
          profilepic = File(value.path);

          notifyListeners();
        },
      );

      notifyListeners();
    });
  }

  void selectlicenceimage({required BuildContext context}) {
    pickFile(context: context).then((value) {
      cropImage(value!).then(
        (value) {
          licencepic = File(value.path);

          notifyListeners();
        },
      );
    });
  }

  void changeconfirmpasswordvisiblity() {
    isconfirmvisible = !isconfirmvisible;
    notifyListeners();
  }

  Future<CroppedFile> cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: AppColors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    return croppedFile!;
  }

  Future<void> selectDate(BuildContext context) async {
    final ThemeData theme = ThemeData(
      primarySwatch: Colors.green, // Set the primary color to green
      colorScheme: const ColorScheme.light(
          primary:
              Colors.green), // Set the light theme's primary color to green
      buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        colorScheme: ColorScheme.light(
            primary: Colors.green), // Set the button color to green
      ),
    );
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null) {
      expiryController.text = dateFormat.format(pickedDate);
      notifyListeners();
    }
  }

  Future<File?> pickFile({
    required BuildContext context,
    List<String>? extensions,
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      // ignore: invalid_use_of_visible_for_testing_member
      final xPath = await ImagePicker.platform.getImage(
        source: source,
      );
      if (xPath != null) {
        final paths = File(xPath.path);

        return File(paths.path);
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.green,
            content: const Text(
              "No file selected. \n\n",
            ),
            duration: const Duration(seconds: 2),
          ));
        });
        return null;
      }
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.green,
        content: Text(
          "Unsupported operation$ex \n\n",
        ),
        duration: const Duration(seconds: 2),
      ));
    }
    return null;
  }

  void dousersignup(
      {required BuildContext context, required String userid}) async {
    isloading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();

    try {
      await AppRepository()
          .dousersignup(
        profile_picture: profilepic!,
        driver_id: userid,
        access_token: prefs.getString(Strings().accesstoken)!,
        name: nameController.text,
        license_number: licensenumberController.text,
        license_expiry_date: expiryController.text,
        license_image: licencepic!,
        email: emailController.text,
        password: passwordController.text,
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

          // context.showSnackBar(
          //   context,
          //   msg: value["message"].toString(),
          // );
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
          // prefs.setString(Strings().userid, userid);
          isloading = false;

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.green,
            content: Text(" ${value["message"]} \n\n"),
            duration: const Duration(seconds: 2),
          ));
          nameController.clear();
          licensenumberController.clear();
          emailController.clear();
          cPassController.clear();
          passwordController.clear();
          expiryController.clear();
          context.read<LoginProvider>().phonecontroller.clear();
          context.read<LoginProvider>().otpcontroller.clear();
          context.read<LoginProvider>().islicenceverified == true;

          notifyListeners();
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppColors.green,
              content: const Text(
                " Please wait for the admin's approval for your account. \n\n",
              ),
              duration: const Duration(seconds: 2),
            ));
          });
          LocalNotification.instance.showNotification(
            const RemoteMessage(
              data: {
                "title": "Warning",
                "body":
                    "Please wait for the admin's approval for your account.",
              },
            ),
          );
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginMobile()),
              (route) => false);
        }
      });
    } catch (e) {
      iserror = true;
      isloading = false;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.green,
          content: Text(
            " ${e.toString()} \n\n",
          ),
          duration: const Duration(seconds: 2),
        ));
      });
      notifyListeners();
    }
    notifyListeners();
  }
}
