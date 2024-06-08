import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_choice_driver/api/app_repository.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/helpers/strings.dart';
import 'package:first_choice_driver/model/driverprofile.dart';
import 'package:first_choice_driver/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  DriverProfile? driverProfile;
  bool isloading = false;
  bool iserror = false;
  String errortext = '';
  bool ispasswordvisible = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPassController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController linencenumberController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  File? selectedimage;
  File? licenseImage;

  void selectlicenceimage({required BuildContext context}) {
    pickFile(context: context).then((value) {
      licenseImage = value;
      notifyListeners();
    });
  }

  void changepasswordvisiblity() {
    ispasswordvisible = !ispasswordvisible;
    notifyListeners();
  }

  bool isconfirmvisible = false;

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

  void changeconfirmpasswordvisiblity() {
    isconfirmvisible = !isconfirmvisible;
    notifyListeners();
  }

  void changeselectedImage({required BuildContext context}) {
    pickFile(context: context).then(
      (value) {
        cropImage(value!).then(
          (value) {
            selectedimage = File(value.path);

            notifyListeners();
          },
        );
      },
    );
    // .then((value) {
    //   selectedimage = value;
    //   notifyListeners();
    // });
  }

  Future<File?> pickFile({
    List<String>? extensions,
    required BuildContext context,
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
            content: const Text('No file selected. \n\n'),
            duration: const Duration(seconds: 2),
          ));
        });
        return null;
      }
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.green,
        content: Text('Unsupported operation$ex \n\n'),
        duration: const Duration(seconds: 2),
      ));
    }
    return null;
  }

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

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
      //   setState(() {
      expiryDateController.text = dateFormat.format(pickedDate);
      notifyListeners();
      // });
    }
  }

  Widget userimageicon() {
    if (selectedimage != null) {
      return Image.file(
        selectedimage!,
        fit: BoxFit.cover,
      );
    } else if (driverProfile != null) {
      if (driverProfile!.profilePhoto.isNotEmpty) {
        return CachedNetworkImage(
          imageUrl: driverProfile!.profilePhoto,
          fit: BoxFit.cover,
        );
      }
    }
    return Icon(
      Icons.person,
      size: 40.sp,
    );
  }

  void getdriverprofile({required BuildContext context}) async {
    isloading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();

    try {
      await AppRepository()
          .getdriverprofile(
        userid: prefs.getString(Strings().userid)!,
        accesstoken: prefs.getString(Strings().accesstoken)!,
      )
          .then((value) {
        if (value["code"] == 201) {
          isloading = false;
          iserror = true;

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
          isloading = false;

          driverProfile = DriverProfile.fromJson(value);
          nameController.text = driverProfile!.name;
          emailController.text = driverProfile!.email;
          mobileController.text = driverProfile!.mobileNumber;
          linencenumberController.text = driverProfile!.licenseNumber;
          DateTime parsedDate =
              DateTime.parse(driverProfile!.licenseExpiryDate);

          // Create a DateFormat instance for the desired output format
          DateFormat outputFormat = DateFormat("MMM dd/yyyy");

          // Format the parsed date according to the output format
          String formattedDate = outputFormat.format(parsedDate);
          expiryDateController.text = formattedDate;

          notifyListeners();
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

  void updatedriverprofile({required BuildContext context}) async {
    isloading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();

    try {
      await AppRepository()
          .updatedriverprofile(
              license_number: linencenumberController.text,
              profile_picture: selectedimage ?? File(""),
              driver_id: prefs.getString(Strings().userid)!,
              name: nameController.text,
              license_expiry_date: expiryDateController.text,
              accesstoken: prefs.getString(Strings().accesstoken)!,
              email: emailController.text,
              password: passwordController.text,
              license_image: licenseImage ?? File(""))
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
          getdriverprofile(context: context);

          notifyListeners();
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
