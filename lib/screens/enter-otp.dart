// import 'package:code_input/code_input.dart';
// import 'package:first_choice_driver/common/sizedbox.dart';
// import 'package:first_choice_driver/helpers/colors.dart';
// import 'package:first_choice_driver/screens/accept_screen.dart';
// import 'package:first_choice_driver/screens/past_history.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// class EnterOTPScreen extends StatefulWidget {
//   const EnterOTPScreen({super.key});

//   @override
//   State<EnterOTPScreen> createState() => _EnterOTPScreenState();
// }

// class _EnterOTPScreenState extends State<EnterOTPScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const AcceptScreen(),
//           ),
//         );
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: const Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//             ),
//           ),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               Icon(
//                 Icons.code,
//                 color: AppColors.grey500,
//                 size: 30.h,
//               ),
//               sizedBoxWithHeight(20),
//               Text(
//                 "Enter PIN",
//                 style: GoogleFonts.poppins(
//                   color: Colors.black,
//                   fontSize: 30.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               sizedBoxWithHeight(40),
//               CodeInput(
//                 length: 4,
//                 spacing: 0,
//                 keyboardType: TextInputType.number,
//                 builder: CodeInputBuilders.circle(
//                     border: Border.all(
//                       color: Colors.transparent,
//                     ),
//                     color: AppColors.greydark,
//                     emptyRadius: 6,
//                     textStyle: GoogleFonts.poppins(
//                       color: Colors.black,
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                     )),
//                 // ignore: avoid_print
//                 onFilled: (value) => print('Your input is $value.'),
//               ),
//             ],
//           ),
//         ),
//         //     body: SafeArea(
//         //   child:
//         // ));
//       ),
//     );
//   }
// }
