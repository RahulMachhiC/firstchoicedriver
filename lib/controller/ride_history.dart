import 'package:first_choice_driver/api/app_repository.dart';
import 'package:first_choice_driver/helpers/strings.dart';
import 'package:first_choice_driver/model/ridehistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/colors.dart';

class RideHistoryProvider extends ChangeNotifier {
  bool isloading = false;
  bool iserror = false;
  bool isempty = false;
  String errortext = '';
  RideHistory? rideHistory;

  void getridehistory({required BuildContext context}) async {
    isloading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();

    try {
      await AppRepository()
          .getridehistory(
        userid: prefs.getString(Strings().userid)!,
        accesstoken: prefs.getString(Strings().accesstoken)!,
      )
          .then((value) {
        if (value["code"] == 201) {
          isloading = false;
          iserror = true;
          if (value["message"] == "No booking found") {
            isempty = true;
          }

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
          rideHistory = RideHistory.fromJson(value);
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
