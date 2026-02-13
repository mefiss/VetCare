import 'package:flutter/material.dart';

/// Design system color tokens for PetCare app.
/// Based on the HTML mockup specifications.
abstract final class AppColors {
  // Primary
  static const primary = Color(0xFF667EEA);
  static const primaryDark = Color(0xFF5568D3);
  static const gradientEnd = Color(0xFF764BA2);

  // Semantic
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFFF4444);
  static const orangeAccent = Color(0xFFFF6B35);
  static const orangeStatus = Color(0xFFFF9800);

  // Warning banner
  static const warningBannerBg = Color(0xFFFFF3CD);
  static const warningBannerBorder = Color(0xFFFFC107);
  static const warningBannerText = Color(0xFF856404);

  // Text
  static const textPrimary = Color(0xFF333333);
  static const textSecondary = Color(0xFF666666);
  static const textTertiary = Color(0xFF999999);

  // Surfaces
  static const background = Color(0xFFF8F9FA);
  static const cardBg = Colors.white;
  static const border = Color(0xFFE0E0E0);
  static const selectedBg = Color(0xFFF0F4FF);

  // Stars
  static const starYellow = Color(0xFFFFC107);

  // Gradient
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, gradientEnd],
  );
}
