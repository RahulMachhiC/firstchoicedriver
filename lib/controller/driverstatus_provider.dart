import 'package:first_choice_driver/api/app_repository.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/helpers/strings.dart';
import 'package:first_choice_driver/model/driverstatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverStatusProvider extends ChangeNotifier {
  bool isloading = false;
  bool iserror = false;
  String errortext = '';
  DriverStatus? driverStatus;
  bool isonline = true;

  void changestatus({
    required bool value,
    required BuildContext context,
  }) {
    isonline = value;
    changedriverstatus(
      context: context,
    );
    notifyListeners();
  }

  void getdriverstatus({
    required BuildContext context,
  }) async {
    isloading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();

    try {
      await AppRepository()
          .getdriverStatus(
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
          OverlayLoadingProgress.stop();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.green,
            content: Text(
              " ${value["message"]} \n\n",
            ),
            duration: const Duration(
              seconds: 2,
            ),
          ));
          notifyListeners();
        } else if (value["code"] == 200) {
          isloading = false;
          OverlayLoadingProgress.stop();

          driverStatus = DriverStatus.fromJson(value);
          isonline = driverStatus!.status == "online" ? true : false;

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
            "           ${e.toString()} \n\n",
          ),
          duration: const Duration(seconds: 2),
        ));
      });
      notifyListeners();
    }
    notifyListeners();
  }

  void changedriverstatus({required BuildContext context}) async {
    isloading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();

    try {
      await AppRepository()
          .changedriverStatus(
        userid: prefs.getString(Strings().userid)!,
        stauts: isonline ? "online" : "offline",
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
            content: Text(
              " ${value["message"]} \n\n",
            ),
            duration: const Duration(seconds: 2),
          ));
          notifyListeners();
        } else if (value["code"] == 200) {
          isloading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.green,
            content: Text(
              " ${value["message"]} \n\n",
            ),
            duration: const Duration(seconds: 2),
          ));
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
            "${e.toString()} \n\n",
          ),
          duration: const Duration(seconds: 2),
        ));
      });
      notifyListeners();
    }
    notifyListeners();
  }
}
