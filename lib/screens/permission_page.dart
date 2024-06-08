import 'package:first_choice_driver/common/bottomnavigationbar.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/helpers/text_style.dart';
import 'package:first_choice_driver/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class NoPermission extends StatefulWidget {
  const NoPermission({Key? key}) : super(key: key);

  @override
  State<NoPermission> createState() => _NoPermissionState();
}

class _NoPermissionState extends State<NoPermission>
    with WidgetsBindingObserver {
  ValueNotifier<LocationPermission?> permision = ValueNotifier(null);
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _getPermission();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getPermission();
  }

  void _getPermission() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      permision.value = await Geolocator.checkPermission();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getPermission();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();

        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.appColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Permession Denied',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: Text(
                  'Please give permission to app ,to work properly. Please go to app setting and grant the permissions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
              ValueListenableBuilder<LocationPermission?>(
                  valueListenable: permision,
                  builder: (context, snapshot, _) {
                    return GestureDetector(
                      onTap: () async {
                        if (snapshot == LocationPermission.denied ||
                            snapshot == LocationPermission.deniedForever ||
                            snapshot == LocationPermission.unableToDetermine) {
                          Geolocator.openAppSettings();
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PagesWidget()),
                            (route) => false,
                          );
                          // AppEnvironment.navigator.pushNamedAndRemoveUntil(
                          //   GeneralRoutes.pages,
                          //   (route) => false,
                          // );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 16.h,
                        ),
                        margin: EdgeInsets.symmetric(
                            vertical: 16.h, horizontal: 16.h),
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(
                            10.r,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            snapshot == LocationPermission.denied ||
                                    snapshot ==
                                        LocationPermission.deniedForever ||
                                    snapshot ==
                                        LocationPermission.unableToDetermine
                                ? "Go to Setting"
                                : "Go to Home Page",
                            style: AppText.text15w400.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
