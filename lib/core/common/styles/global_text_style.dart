import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yasminaarsic/core/utils/constants/colors.dart';

TextStyle primaryFontStyle({
  double fontSize = 16.0,
  FontWeight fontWeight = FontWeight.w500,
  double lineHeight = 21.0,
  TextAlign textAlign = TextAlign.center,
  Color color = AppColors.textPrimary,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: fontSize.sp / lineHeight.sp,
    color: color,
  );
}

TextStyle secondaryFontStyle({
  double fontSize = 12.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 21.0,
  TextAlign textAlign = TextAlign.center,
  Color color = AppColors.textSecondary,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: fontSize.sp / lineHeight.sp,
    color: color,
  );
}

TextStyle tertiaryFontStyle({
  double fontSize = 16.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 21.0,
  TextAlign textAlign = TextAlign.center,
  Color color = AppColors.textSecondary,
}) {
  return GoogleFonts.poppins(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: fontSize.sp / lineHeight.sp,
    color: color,
  );
}
