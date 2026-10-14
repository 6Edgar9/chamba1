import 'package:flutter/material.dart';

/// Design tokens extracted directly from Google Stitch project 12752052940306496834
class AppColors {
  AppColors._();

  // Institutional Primary (Petroleum Blue)
  static const Color primary = Color(0xFF173B4D);
  static const Color primaryContainer = Color(0xFF284B5D);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Action & Transactional Secondary (Brick Terracotta)
  static const Color secondary = Color(0xFFB84A1C);
  static const Color secondaryLight = Color(0xFFFFDBCE);
  static const Color secondaryContainer = Color(0xFFFF7E4C);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Tertiary Utility & Escrow (Highland Green)
  static const Color tertiary = Color(0xFF237553);
  static const Color tertiaryLight = Color(0xFFA3F3C9);
  static const Color onTertiary = Color(0xFFFFFFFF);

  // Neutral Foreground & Typography (Graphite Deep)
  static const Color neutral = Color(0xFF202D33);
  static const Color onSurface = Color(0xFF101D23);

  // Muted Text & Meta (Slate Silver)
  static const Color muted = Color(0xFF667085);
  static const Color outline = Color(0xFF72787C);
  static const Color outlineVariant = Color(0xFFC2C7CC);

  // Surfaces & Canvases
  static const Color canvas = Color(0xFFF8F6F1); // Warm Canvas backdrop
  static const Color card = Color(0xFFFFFFFF); // Foreground white card
  static const Color surfaceContainer = Color(0xFFE2F0F8);
  static const Color surfaceContainerLow = Color(0xFFE8F6FE);
  static const Color surfaceContainerHighest = Color(0xFFD6E5ED);

  // Alerts & Warnings
  static const Color error = Color(0xFFB42318);
  static const Color errorLight = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);

  // Badges and status accents
  static const Color badgeNegotiatingBg = Color(0x14173B4D); // ~8% opacity
  static const Color badgeNegotiatingText = Color(0xFF173B4D);

  static const Color badgeConfirmedBg = Color(0x1A237553); // ~10% opacity
  static const Color badgeConfirmedText = Color(0xFF237553);

  static const Color badgeCounterBg = Color(0x1FB84A1C); // ~12% opacity
  static const Color badgeCounterText = Color(0xFFB84A1C);

  static const Color quickCounterBg = Color(0x14B84A1C);
  static const Color quickCounterBorder = Color(0x33B84A1C);

  // Worker Professional Role Palette (Emerald / Deep Forest)
  static const Color workerPrimary = Color(0xFF0F4C3A);
  static const Color workerPrimaryContainer = Color(0xFF16654F);
  static const Color workerAccent = Color(0xFF0D9488); // Vibrant professional teal
  static const Color workerAccentLight = Color(0xFFCCFBF1);
  static const Color workerSurface = Color(0xFFF0FDF4);
  static const Color workerSurfaceContainer = Color(0xFFDCFCE7);

  // Chamba SOS Emergency Palette
  static const Color sosRed = Color(0xFFDC2626);
  static const Color sosRedDark = Color(0xFF991B1B);
  static const Color sosRedLight = Color(0xFFFEE2E2);
  static const Color sosAmber = Color(0xFFF59E0B);
  static const Color sosGlow = Color(0x55DC2626);

  // Escudo de Confianza Palette
  static const Color shieldReniec = Color(0xFF2563EB); // Royal Blue
  static const Color shieldPolice = Color(0xFF059669); // Police clean record Emerald
  static const Color shieldWarranty = Color(0xFFD97706); // Golden Amber Guarantee
}
