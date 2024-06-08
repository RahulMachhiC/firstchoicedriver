import 'package:first_choice_driver/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppText {
  AppText._();

  static TextStyle get text18w400 => GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get text22w500 => GoogleFonts.poppins(
        fontSize: 22.sp,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get text28w500 => GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
      );

  static TextStyle get text15w400 => GoogleFonts.poppins(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get text15Normal => GoogleFonts.poppins(
        fontSize: 15.sp,
        fontWeight: FontWeight.normal,
      );
  static TextStyle get text16w400 => GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get text15w500 => GoogleFonts.poppins(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get text14w400 => GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w300,
      );
}
