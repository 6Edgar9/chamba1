import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography tokens from Stitch Chamba Core design system:
/// Manrope for headlines & numeric bids, DM Sans for body & controls
class AppTypography {
  AppTypography._();

  static TextStyle get headlineXl => GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: -0.64, // -0.02em
        color: AppColors.neutral,
      );

  static TextStyle get headlineXlMobile => GoogleFonts.manrope(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 34 / 26,
        letterSpacing: -0.26, // -0.01em
        color: AppColors.neutral,
      );

  static TextStyle get headlineLg => GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        letterSpacing: -0.24,
        color: AppColors.neutral,
      );

  static TextStyle get headlineMd => GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: AppColors.neutral,
      );

  static TextStyle get headlineSm => GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 24 / 18,
        color: AppColors.neutral,
      );

  static TextStyle get numericBid => GoogleFonts.manrope(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 32 / 28,
        letterSpacing: -0.56,
        color: AppColors.neutral,
      );

  static TextStyle get numericBidLarge => GoogleFonts.manrope(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 42 / 36,
        letterSpacing: -0.72,
        color: AppColors.secondary,
      );

  static TextStyle get bodyLg => GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.neutral,
      );

  static TextStyle get bodyLgMedium => GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 24 / 16,
        color: AppColors.neutral,
      );

  static TextStyle get bodyMd => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppColors.neutral,
      );

  static TextStyle get bodyMdMedium => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        color: AppColors.neutral,
      );

  static TextStyle get labelLg => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 18 / 14,
        letterSpacing: 0.14,
        color: AppColors.neutral,
      );

  static TextStyle get labelMd => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        letterSpacing: 0.24,
        color: AppColors.muted,
      );

  static TextStyle get labelSm => GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 14 / 10,
        letterSpacing: 0.4,
        color: AppColors.muted,
      );
}
