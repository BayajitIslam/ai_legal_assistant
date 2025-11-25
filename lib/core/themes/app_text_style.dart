import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/core/constants/app_colors.dart';

class AppTextStyles {
  //------------------------------ Inter Font Styles --------------------------------//
  static TextStyle s14w4i({
    Color? color,
    double fontSize = 14,
    double lineHeight = 1,
    FontWeight fontweight = FontWeight.w400,
  }) {
    return GoogleFonts.inter(
      color: color ?? AppColors.pText,
      fontSize: fontSize.sp,
      fontWeight: fontweight,
      height: lineHeight,
    );
  }

  //------------------------------ Inter Font Styles --------------------------------//
  static TextStyle s16w4i({
    Color? color,
    double fontSize = 16,
    double lineHeight = 1.5,
    FontWeight fontweight = FontWeight.w400,
  }) {
    return GoogleFonts.inter(
      color: color ?? AppColors.titleText,
      fontSize: fontSize.sp,
      fontWeight: fontweight,
      height: lineHeight,
    );
  }

  //------------------------------ Inter Font Styles --------------------------------//
  static TextStyle s20w7i({
    Color? color,
    double fontSize = 20,
    double lineHeight = 1,
    FontWeight fontweight = FontWeight.w700,
  }) {
    return GoogleFonts.inter(
      color: color ?? AppColors.titleText,
      fontSize: fontSize.sp,
      fontWeight: fontweight,
      height: lineHeight,
    );
  }

  //------------------------------ Poppins Font Styles --------------------------------//
  static TextStyle s24w6p({
    Color? color,
    double fontSize = 24,
    double lineHeight = 1,
    FontWeight fontweight = FontWeight.w600,
  }) {
    return GoogleFonts.inter(
      color: color ?? AppColors.titleText,
      fontSize: fontSize.sp,
      fontWeight: fontweight,
      height: lineHeight,
    );
  }

  //------------------------------ Poppins Font Styles --------------------------------//
  static TextStyle s16w4p({
    Color? color,
    double fontSize = 16,
    double lineHeight = 1,
    FontWeight fontweight = FontWeight.w400,
  }) {
    return GoogleFonts.inter(
      color: color ?? AppColors.titleText,
      fontSize: fontSize.sp,
      fontWeight: fontweight,
      height: lineHeight,
    );
  }

   //------------------------------ Poppins Font Styles --------------------------------//
  static TextStyle s12w4arimo({
    Color? color,
    double fontSize = 12,
    double lineHeight = 1,
    FontWeight fontweight = FontWeight.w400,
  }) {
    return GoogleFonts.arimo(
      color: color ?? AppColors.titleText,
      fontSize: fontSize.sp,
      fontWeight: fontweight,
      height: lineHeight,
    );
  }
}
