// import 'package:first_choice_driver/common/app_google_map.dart';
// import 'package:first_choice_driver/common/commonbottombar.dart';
// import 'package:first_choice_driver/common/sizedbox.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../helpers/colors.dart';

// class PaymentReceived extends StatefulWidget {
//   const PaymentReceived({super.key});

//   @override
//   State<PaymentReceived> createState() => _PaymentReceivedState();
// }

// class _PaymentReceivedState extends State<PaymentReceived> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(
//         //     builder: (context) => const PaymentScreen(),
//         //   ),
//         // );
//       },
//       child: Scaffold(
//         bottomNavigationBar: CommonBottomBar(),
//         body: Stack(
//           children: [
//              AppGoogleMap(
// currentLocation: conr,
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(
//                 vertical: 10.h,
//               ),
//               margin: EdgeInsets.symmetric(
//                     horizontal: 10.w,
//                   ) +
//                   EdgeInsets.only(
//                     top: 80.h,
//                   ),
//               height: 170.h,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(
//                   5,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   sizedBoxWithHeight(10),
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 20.w,
//                       vertical: 5.h,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       gradient: LinearGradient(
//                         colors: [
//                           AppColors.green,
//                           AppColors.yellow,
//                         ],
//                       ),
//                     ),
//                     child: Text(
//                       "\$40",
//                       style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                   ),
//                   sizedBoxWithHeight(10),
//                   Text(
//                     "LAST RIDE",
//                     style: GoogleFonts.poppins(
//                       color: Colors.black,
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const Divider(),
//                   sizedBoxWithHeight(10),
//                   Text(
//                     "Today at 4:16 PM",
//                     style: GoogleFonts.poppins(
//                       color: Colors.black,
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   sizedBoxWithHeight(20),
//                   Text(
//                     "See all rides",
//                     style: GoogleFonts.poppins(
//                       color: AppColors.green,
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
