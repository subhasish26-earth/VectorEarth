import 'package:flutter/material.dart';

/// Prithvi Fix — Urban Company Standard Color Palette
/// Combines sleek, modern on-demand marketplace styling with trusted cooperative hues.
class AppColors {
  // Brand Primary & Accents
  static const Color primary = Color(0xFF1A365D); // Deep Cooperative Navy
  static const Color primaryLight = Color(0xFF2B6CB0);
  static const Color primaryDark = Color(0xFF0F172A);
  
  static const Color accentTeal = Color(0xFF0D9488); // Electric Teal (Action / Trust)
  static const Color accentTealLight = Color(0xFFCCFBF1);
  
  static const Color accentAmber = Color(0xFFF59E0B); // Star Ratings / Escrow Badge
  static const Color accentAmberLight = Color(0xFFFEF3C7);
  
  static const Color accentEmerald = Color(0xFF10B981); // 93% Payout / Active Status
  static const Color accentEmeraldLight = Color(0xFFD1FAE5);
  
  static const Color accentCoral = Color(0xFFEF4444); // Urgent / Emergency SOS
  static const Color accentCoralLight = Color(0xFFFEE2E2);

  // Background & Surface
  static const Color background = Color(0xFFF8FAFC); // Clean Slate Tint
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceHover = Color(0xFFF1F5F9);

  // Typography & Content
  static const Color textPrimary = Color(0xFF0F172A); // High Contrast Near-Black
  static const Color textSecondary = Color(0xFF475569); // Muted Slate
  static const Color textMuted = Color(0xFF94A3B8); // Subtitle / Hints
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color borderFocus = Color(0xFF3B82F6);

  // Shimmer Loader Colors
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);

  // Urban Company Floating Cart Gradient
  static const LinearGradient cartGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Hero Banner Overlay Gradient
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xCC0F172A), Color(0x330F172A), Colors.transparent],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}
