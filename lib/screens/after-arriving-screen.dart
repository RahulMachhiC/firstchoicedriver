// import 'package:animated_toggle_switch/animated_toggle_switch.dart';
// import 'package:first_choice_driver/common/app_google_map.dart';
// import 'package:first_choice_driver/common/app_image.dart';
// import 'package:first_choice_driver/common/commonbottombar.dart';
// import 'package:first_choice_driver/controller/ride_provider.dart';
// import 'package:first_choice_driver/helpers/colors.dart';
// import 'package:first_choice_driver/model/driver_arrived.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:overlay_loading_progress/overlay_loading_progress.dart';
// import 'package:provider/provider.dart';

// class AfterArrivingScreen extends StatefulWidget {
//   final DriverArrived driverArrived;
//   const AfterArrivingScreen({
//     super.key,
//     required this.driverArrived,
//   });

//   @override
//   State<AfterArrivingScreen> createState() => _AfterArrivingScreenState();
// }

// class _AfterArrivingScreenState extends State<AfterArrivingScreen> {
//   bool positive = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: CommonBottomBar(),
//       appBar: AppBar(
//         leading: Padding(
//           padding: EdgeInsets.all(10.r),
//           child: const AppImage(
//             "assets/user.png",
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: Padding(
//           padding: EdgeInsets.all(10.r),
//           child: AnimatedToggleSwitch<bool>.dual(
//             current: positive,
//             first: false,
//             second: true,
//             dif: 20.0,
//             borderColor: Colors.transparent,
//             borderWidth: 5.0,
//             height: 35,
//             innerColor: positive ? Colors.green : Colors.red,
//             onChanged: (b) {
//               setState(() => positive = b);
//             },
//             indicatorColor: Colors.transparent,
//             indicatorSize: const Size(47, 25),
//             iconBuilder: (value) => value
//                 ? const AppImage("assets/driver.svg")
//                 : const AppImage("assets/driver.svg"),
//             textBuilder: (value) => value
//                 ? Center(
//                     child: Text(
//                     'Online',
//                     style: GoogleFonts.poppins(
//                       color: Colors.white,
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ))
//                 : Center(
//                     child: Text(
//                     'Offline',
//                     style: GoogleFonts.poppins(
//                       color: Colors.white,
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   )),
//           ),
//         ),
//         // actions: [
//         //   Container(
//         //     margin: EdgeInsets.all(5.r),
//         //     padding: EdgeInsets.all(5.r),
//         //     child: const Icon(
//         //       Icons.search,
//         //       color: Colors.black,
//         //     ),
//         //     decoration: BoxDecoration(
//         //       color: Colors.white,
//         //       shape: BoxShape.circle,
//         //       boxShadow: [
//         //         BoxShadow(
//         //           color: AppColors.greydark,
//         //           spreadRadius: 0,
//         //           blurRadius: 4,
//         //         )
//         //       ],
//         //     ),
//         //   ),
//         //   sizedBoxWithWidth(10),
//         // ],
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(25.h),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Icon(
//                   Icons.roundabout_left_outlined,
//                   color: AppColors.green,
//                 ),
//                 Text(
//                   "  ${widget.driverArrived.dropLocation.first.address}",
//                   style: GoogleFonts.poppins(
//                     color: Colors.black,
//                     fontSize: 13.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//       // appBar: AppBar(
//       //   backgroundColor: Colors.white,
//       //   elevation: 0,
//       //   centerTitle: false,
//       //   automaticallyImplyLeading: false,
//       //   title:
//       // ),
//       body: Consumer<RideProvider>(builder: (context, controller, child) {
//         if (controller.isloading) {
//           SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//             OverlayLoadingProgress.start(
//               context,
//             );
//           });
//         } else if (controller.iserror) {
//           OverlayLoadingProgress.stop();
//         }

//         OverlayLoadingProgress.stop();
//         return SafeArea(
//           child: Stack(
//             children: [
//               const AppGoogleMap(),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
