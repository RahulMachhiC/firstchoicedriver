import 'package:first_choice_driver/common/bottomnavigationbar.dart';
import 'package:first_choice_driver/common/widgets/splashbackground.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/helpers/strings.dart';
import 'package:first_choice_driver/helpers/text_style.dart';
import 'package:first_choice_driver/screen_config.dart';
import 'package:first_choice_driver/screens/login_mobile.dart';
import 'package:first_choice_driver/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil()
      ..init(
        context,
      );
    return Scaffold(
        backgroundColor: AppColors.appColor,
        body: ListView(
          children: [
            const SplashBackground(),
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "First Choice Designated\nDriver Service",
                    textAlign: TextAlign.center,
                    style: AppText.text28w500.copyWith(
                      color: AppColors.black,
                      fontSize: MediaQuery.of(context).size.height > 700
                          ? 20.sp
                          : 25.sp,
                    ),
                  ).animate().slideY(
                        duration: const Duration(milliseconds: 500),
                      ),
                  //       Spacer(),
                  // MediaQuery.of(context).size.height > 700
                  //     ? sizedBoxWithHeight(12)
                  //     : sizedBoxWithHeight(50),
                  SizedBox(
                    height: 50.h,
                  ),
                  InkWell(
                    onTap: () async {
                      isLoggedIn(context: context);
                      // final SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // if (prefs.getString(Strings().refreshtoken) == null) {
                      //   SchedulerBinding.instance
                      //       .addPostFrameCallback((timeStamp) {
                      //     context.read<TokenProvider>().fetchrefreshtoken();
                      //   });
                      // } else {
                      //   SchedulerBinding.instance
                      //       .addPostFrameCallback((timeStamp) {
                      //     context.read<TokenProvider>().fetchaccesstoken();
                      //   });
                      // }
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.h,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(
                          10.r,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Get Started",
                          style: AppText.text15w400.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 500)),
                  )
                ],
              ),
            ),
          ],
        ));
    // });
  }
}

Future isLoggedIn({required BuildContext context}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String istokenavailable = prefs.getString(Strings().userid) ?? "";
  // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
  //   context.read<TokenProvider>().resetvalues();
  // });
  if (istokenavailable == "") {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginMobile(),
        ),
        (route) => false,
      );
    });
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => LoginMobile(),
    //   ),
    // );
  } else {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PagesWidget()),
        (route) => false,
      );
    });
  }
}
