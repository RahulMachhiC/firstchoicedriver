// import 'package:first_choice_driver/common/app_google_map.dart';
// import 'package:first_choice_driver/common/commonbottombar.dart';
// import 'package:first_choice_driver/controller/ride_provider.dart';
// import 'package:first_choice_driver/model/startride.dart';
// import 'package:first_choice_driver/size_extension.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:overlay_loading_progress/overlay_loading_progress.dart';
// import 'package:provider/provider.dart';

// import '../common/sizedbox.dart';
// import '../helpers/colors.dart';

// class InBetweenRide extends StatefulWidget {
//   final StartRide startRide;
//   final Set<Marker> markers;

//   const InBetweenRide({
//     super.key,
//     required this.startRide,
//     required this.markers,
//   });

//   @override
//   State<InBetweenRide> createState() => _InBetweenRideState();
// }

// class _InBetweenRideState extends State<InBetweenRide> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: CommonBottomBar(),
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
//                 myLocationEnabled: false,
//                 polylines: Set<Polyline>.of(controller.polylines.values),
//                 markers: widget.markers,
//                 gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
//                   Factory<OneSequenceGestureRecognizer>(
//                     () => EagerGestureRecognizer(),
//                   ),
//                 },
//                 onMapCreated: (controller) {
//                   // setState(() {
//                   //   ismapCreated = true;
//                   // });
//                 },
//                 myLocationButtonEnabled: true,
//                 initialCameraPosition: CameraPosition(
//                   target: LatLng(
//                     controller.currentPosition!.latitude,
//                     controller.currentPosition!.longitude,
//                   ),
//                   zoom: 15,
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.only(
//                   left: 10.w,
//                   top: 8.h,
//                   bottom: 8.h,
//                 ),
//                 margin: EdgeInsets.symmetric(
//                   horizontal: 16.w,
//                   vertical: 10.h,
//                 ),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       AppColors.green,
//                       AppColors.yellow,
//                     ],
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(
//                           Icons.turn_left_outlined,
//                           color: Colors.white,
//                         ),
//                         Text(
//                           "700ft",
//                           style: GoogleFonts.poppins(
//                             color: Colors.white,
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       "  verve Senior Living",
//                       style: GoogleFonts.poppins(
//                           color: Colors.white,
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w500),
//                     )
//                   ],
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(
//                         horizontal: 16.w,
//                         vertical: 10.h,
//                       ) +
//                       EdgeInsets.only(
//                         bottom: 30.h,
//                       ),
//                   color: Colors.white,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         "4 min 700ft",
//                         style: GoogleFonts.poppins(
//                             color: Colors.black,
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "Dropping Off",
//                         style: GoogleFonts.poppins(
//                             color: Colors.black,
//                             fontSize: 17.sp,
//                             fontWeight: FontWeight.w500),
//                       ),
//                       sizedBoxWithHeight(5),
//                       InkWell(
//                         onTap: () {
//                           context.read<RideProvider>().endride(
//                                 context: context,
//                                 markers: widget.markers,
//                               );
//                         },
//                         child: Container(
//                           width: double.infinity,
//                           padding: EdgeInsets.symmetric(
//                             vertical: 8.h,
//                           ),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 AppColors.green,
//                                 AppColors.yellow,
//                               ],
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               "Drop Off",
//                               style: GoogleFonts.poppins(
//                                 color: Colors.white,
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
