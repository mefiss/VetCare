import 'package:flutter/material.dart';

/// Design system color tokens for PetCare app.
/// Health-oriented palette: pastel green (teal) + light blue.
abstract final class AppColors {
  // Primary — teal/green pastel (salud, confianza, bienestar)
  static const primary = Color(0xFF4CAF93);
  static const primaryDark = Color(0xFF3D9B82);
  static const gradientEnd = Color(0xFF5DADE2); // azul claro (frescura, calma)

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
  static const background = Color(0xFFF5F9F7); // tinte verde sutil
  static const cardBg = Colors.white;
  static const border = Color(0xFFE0E0E0);
  static const selectedBg = Color(0xFFE8F5F0); // verde muy claro

  // Species badges
  static const dogBadgeBg = Color(0xFFE0F2F1);
  static const dogBadgeText = Color(0xFF00796B);
  static const catBadgeBg = Color(0xFFFCE4EC);
  static const catBadgeText = Color(0xFFC62828);

  // Stars
  static const starYellow = Color(0xFFFFC107);

  // Gradient
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, gradientEnd],
  );
}
