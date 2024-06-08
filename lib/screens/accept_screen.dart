// // ignore_for_file: sort_child_properties_last

// import 'package:animated_toggle_switch/animated_toggle_switch.dart';
// import 'package:first_choice_driver/common/app_google_map.dart';
// import 'package:first_choice_driver/common/app_image.dart';
// import 'package:first_choice_driver/common/commonbottombar.dart';
// import 'package:first_choice_driver/controller/ride_provider.dart';
// import 'package:first_choice_driver/screens/arriving_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:overlay_loading_progress/overlay_loading_progress.dart';
// import 'package:provider/provider.dart';

// import '../common/sizedbox.dart';
// import '../helpers/colors.dart';

// class AcceptScreen extends StatefulWidget {
//   const AcceptScreen({super.key});

//   @override
//   State<AcceptScreen> createState() => _AcceptScreenState();
// }

// class _AcceptScreenState extends State<AcceptScreen> {
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
//         elevation: 1,
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
//       ),
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
