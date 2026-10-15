import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextTheme textThemeDark = TextTheme(
    displayLarge: GoogleFonts.notoSerif(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryDark,
    ),
    displayMedium: GoogleFonts.notoSerif(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryDark,
    ),
    titleLarge: GoogleFonts.notoSerif(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryDark,
    ),
    titleMedium: GoogleFonts.notoSerif(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),
    bodyLarge: GoogleFonts.notoSerif(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimaryDark,
    ),
    bodyMedium: GoogleFonts.notoSerif(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondaryDark,
    ),
    labelLarge: GoogleFonts.notoSerif(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),
  );

  static TextTheme textThemeLight = TextTheme(
    displayLarge: GoogleFonts.notoSerif(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryLight,
    ),
    displayMedium: GoogleFonts.notoSerif(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryLight,
    ),
    titleLarge: GoogleFonts.notoSerif(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryLight,
    ),
    titleMedium: GoogleFonts.notoSerif(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    ),
    bodyLarge: GoogleFonts.notoSerif(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimaryLight,
    ),
    bodyMedium: GoogleFonts.notoSerif(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondaryLight,
    ),
    labelLarge: GoogleFonts.notoSerif(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    ),
  );
}
