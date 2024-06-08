import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';
import 'package:first_choice_driver/common/bottomnavigationbar.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:flutter/material.dart';

import '../my_flutter_app_icons.dart';

class CommonBottomBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  CommonBottomBar({super.key});

  @override
  State<CommonBottomBar> createState() => _CommonBottomBarState();
}

class _CommonBottomBarState extends State<CommonBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.green,
      child: FancyBottomNavigation(
        initialSelection: 1,
        barBackgroundColor: Colors.green,
        circleColor: Colors.white,
        inactiveIconColor: Colors.black,
        activeIconColor: Colors.green,
        //    initialSelection: widget.currentTab,
        onTabChangedListener: (int i) {
          if (i == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => PagesWidget(
                  currentTab: 0,
                ),
              ),
            );
          } else if (i == 1) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => PagesWidget(
                  currentTab: 1,
                ),
              ),
            );
          } else if (i == 2) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => PagesWidget(
                  currentTab: 2,
                ),
              ),
            );
          }
          // _selectTab(
          //   i,
          // );
        },
        tabs: [
          TabData(
            iconData: MyFlutterApp.home,
            title: "",
            onclick: () {},
          ),
          TabData(
            iconData: MyFlutterApp.past,
            title: "",
            onclick: () {},
          ),
          TabData(
            iconData: MyFlutterApp.person,
            title: "",
            onclick: () {},
          ),
        ],
      ),
    );
  }
}
