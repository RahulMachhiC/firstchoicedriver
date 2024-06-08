// import 'dart:developer';

// import 'package:animated_toggle_switch/animated_toggle_switch.dart';
// import 'package:first_choice_driver/model/acceptresponse.dart';
// import 'package:first_choice_driver/screens/after-arriving-screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:overlay_loading_progress/overlay_loading_progress.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../common/app_google_map.dart';
// import '../common/app_image.dart';
// import '../common/commonbottombar.dart';
// import '../common/sizedbox.dart';
// import '../controller/ride_provider.dart';
// import '../helpers/colors.dart';

// class ArrivingScreen extends StatefulWidget {
//   final AcceptResponse acceptResponse;
//   const ArrivingScreen({super.key, required this.acceptResponse});

//   @override
//   State<ArrivingScreen> createState() => _ArrivingScreenState();
// }

// class _ArrivingScreenState extends State<ArrivingScreen> {
//   bool positive = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: CommonBottomBar(),
//       appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           leading: Padding(
//             padding: EdgeInsets.all(10.r),
//             child: const AppImage(
//               "assets/user.png",
//             ),
//           ),
//           actions: [
//             Container(
//               margin: EdgeInsets.all(5.r),
//               padding: EdgeInsets.all(5.r),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.greydark,
//                     spreadRadius: 0,
//                     blurRadius: 4,
//                   )
//                 ],
//               ),
//               child: const Icon(
//                 Icons.search,
//                 color: Colors.black,
//               ),
//             ),
//             sizedBoxWithWidth(10),
//           ],
//           title: Padding(
//             padding: EdgeInsets.all(10.r),
//             child: AnimatedToggleSwitch<bool>.dual(
//               current: positive,
//               first: false,
//               second: true,
//               dif: 20.0,
//               borderColor: Colors.transparent,
//               borderWidth: 5.0,
//               height: 35,
//               innerColor: positive ? Colors.green : Colors.red,
//               onChanged: (b) {
//                 setState(() => positive = b);
//               },
//               indicatorColor: Colors.transparent,
//               indicatorSize: const Size(47, 25),
//               iconBuilder: (value) => value
//                   ? const AppImage("assets/driver.svg")
//                   : const AppImage("assets/driver.svg"),
//               textBuilder: (value) => value
//                   ? Center(
//                       child: Text(
//                       'Online',
//                       style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ))
//                   : Center(
//                       child: Text(
//                       'Offline',
//                       style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     )),
//             ),
//           ),
//           centerTitle: true,
//           bottom: PreferredSize(
//               preferredSize: Size.fromHeight(40.h),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Divider(),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                           horizontal: 10.w,
//                         ) +
//                         EdgeInsets.only(
//                           bottom: 10.h,
//                         ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.roundabout_left_outlined,
//                           color: AppColors.green,
//                         ),
//                         sizedBoxWithWidth(4),
//                         Flexible(
//                           child: Text(
//                             widget.acceptResponse.pickupLocation.address,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: GoogleFonts.poppins(
//                               color: Colors.black,
//                               fontSize: 13.sp,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ))),
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
//               GoogleMap(
//                 zoomGesturesEnabled: true,
//                 zoomControlsEnabled: false,
//                 markers: <Marker>{
//                   Marker(
//                     markerId: const MarkerId('marker_1'),
//                     draggable: false,
//                     position: LatLng(
//                         double.parse(widget.acceptResponse.pickupLocation.lat),
//                         double.parse(
//                             widget.acceptResponse.pickupLocation.long)),
//                     infoWindow: const InfoWindow(
//                       title: 'Marker Title',
//                       snippet: 'Marker Snippet',
//                     ),
//                     icon: BitmapDescriptor.defaultMarkerWithHue(
//                       BitmapDescriptor.hueRed,
//                     ),
//                   ),
//                 },
//                 gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
//                   Factory<OneSequenceGestureRecognizer>(
//                     () => EagerGestureRecognizer(),
//                   ),
//                 },
//                 onMapCreated: (mapcontroller) {
//                   mapcontroller.animateCamera(
//                     CameraUpdate.newLatLngZoom(
//                       LatLng(
//                         double.parse(widget.acceptResponse.pickupLocation.lat),
//                         double.parse(widget.acceptResponse.pickupLocation.long),
//                       ),
//                       15,
//                     ),
//                   );
//                 },
//                 compassEnabled: false,
//                 myLocationButtonEnabled: false,
//                 myLocationEnabled: false,
//                 initialCameraPosition: CameraPosition(
//                   target: LatLng(
//                     double.parse(widget.acceptResponse.pickupLocation.lat),
//                     double.parse(widget.acceptResponse.pickupLocation.long),
//                   ),
//                   zoom: 15.0,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
