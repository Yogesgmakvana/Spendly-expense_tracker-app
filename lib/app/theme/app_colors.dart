import 'package:flutter/material.dart';

class AppColors {
  // Dark Teal Base Palette (Matching Reference UI)
  static const Color darkBackground = Color(0xFF092B30);
  static const Color darkHeaderBackground = Color(0xFF072125);
  static const Color darkCardBackground = Color(0xFF0E383F);
  static const Color darkCardSecondary = Color(0xFF13464E);
  static const Color darkCardBorder = Color(0xFF18555E);

  // Light Mode Palette
  static const Color lightBackground = Color(0xFFF4F8F8);
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE2ECEE);

  // Metallic Gold Primary Brand Color (#D4AF37)
  static const Color primaryPeach = Color(0xFFD4AF37); // Elegant Metallic Gold
  static const Color primaryPeachLight = Color(0xFFF3E5AB);
  static const Color primaryTeal = Color(0xFF135A64);

  // Financial Indicators
  static const Color incomeGreen = Color(0xFF34D399); // Soft Emerald
  static const Color expenseRed = Color(0xFFF87171); // Coral Red
  static const Color warningOrange = Color(0xFFFB923C); // Budget Warning
  static const Color infoBlue = Color(0xFF38BDF8);

  // Text Colors
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFA5C2C6);
  static const Color textMutedDark = Color(0xFF6B8B90);

  static const Color textPrimaryLight = Color(0xFF0D282C);
  static const Color textSecondaryLight = Color(0xFF4A686D);
  static const Color textMutedLight = Color(0xFF8DA6AA);

  // Gradients
  static const LinearGradient visaCardGradient = LinearGradient(
    colors: [Color(0xFF0C383F), Color(0xFF08282D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF0D3D45), Color(0xFF092B30)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient recommendationGradient = LinearGradient(
    colors: [Color(0xFF11434C), Color(0xFF0E383F)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
