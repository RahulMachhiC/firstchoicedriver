import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/helpers/route_arguments.dart';
import 'package:first_choice_driver/model/riderequestnoti.dart';
import 'package:first_choice_driver/my_flutter_app_icons.dart';
import 'package:first_choice_driver/screens/driver_search_screen.dart';
import 'package:first_choice_driver/screens/past_history.dart';
import 'package:first_choice_driver/screens/profile_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PagesWidget extends StatefulWidget {
  dynamic currentTab;
  final bool isriderecieved;
  final RideRequestModel? rideRequestModel;
  RouteArgument? routeArgument;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  PagesWidget(
      {super.key,
      this.currentTab,
      this.isriderecieved = false,
      this.rideRequestModel}) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(
          currentTab.id,
        );
      }
    } else {
      currentTab = 0;
    }
  }

  @override
  // ignore: library_private_types_in_public_api
  _PagesWidgetState createState() {
    return _PagesWidgetState();
  }
}

class _PagesWidgetState extends State<PagesWidget> {
  Widget currentPage = const DriverSearch(
      //   isriderecieved: widget.isriderecieved,
      );

  @override
  initState() {
    super.initState();

    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          currentPage = DriverSearch(
            parentScaffoldKey: widget.scaffoldKey,
            isriderecieved: widget.isriderecieved,
            rideRequestModel: widget.rideRequestModel,
          );
          break;
        case 1:
          currentPage = PastHistory(
            parentScaffoldKey: widget.scaffoldKey,
          );
          break;
        case 2:
          currentPage = ProfileScreen(
            parentScaffoldKey: widget.scaffoldKey,
          );
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      body: IndexedStack(
        index: widget.currentTab,
        children: [
          DriverSearch(
            parentScaffoldKey: widget.scaffoldKey,
            isriderecieved: widget.isriderecieved,
            rideRequestModel: widget.rideRequestModel,
          ),
          PastHistory(
            parentScaffoldKey: widget.scaffoldKey,
          ),
          ProfileScreen(
            parentScaffoldKey: widget.scaffoldKey,
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: AppColors.green,
        child: FancyBottomNavigation(
          barBackgroundColor: AppColors.green,
          circleColor: Colors.white,
          inactiveIconColor: Colors.black,
          activeIconColor: AppColors.green,
          initialSelection: widget.currentTab,
          onTabChangedListener: (int i) {
            _selectTab(
              i,
            );
          },
          tabs: [
            TabData(iconData: MyFlutterApp.home, title: ""),
            TabData(iconData: MyFlutterApp.past, title: ""),
            TabData(iconData: MyFlutterApp.person, title: ""),
          ],
        ),
      ),
    );
  }
}
