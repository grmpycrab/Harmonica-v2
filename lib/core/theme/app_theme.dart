import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// DAW-inspired dark theme.
///
/// Palette is intentionally desaturated so UI chrome stays out of the way
/// and musical content (chord names, progression labels) reads clearly.
class AppTheme {
  AppTheme._();

  // ── Neutrals ────────────────────────────────────────────────────────────────
  /// True-black background — matches pro audio tool canvases.
  static const _bg = Color(0xFF0D0D0F);

  /// Panel surface — barely lighter than background for subtle depth.
  static const _surface = Color(0xFF161618);

  /// Card / raised element.
  static const _card = Color(0xFF1E1E22);

  /// Subtle border / divider colour.
  static const _border = Color(0xFF2A2A30);

  // ── Accent ──────────────────────────────────────────────────────────────────
  /// Single accent colour — a cool indigo that reads well on dark surfaces
  /// without feeling "app-like". Used sparingly (selected states, CTAs).
  static const _accent = Color(0xFF5B6AF0); // indigo-500

  /// Muted accent for selected-chip backgrounds and icon tints.
  static const _accentMuted = Color(0xFF23253D);

  // ── Type ramp ───────────────────────────────────────────────────────────────
  static const _onSurface = Color(0xFFE8E8EE); // primary text
  static const _onSurfaceMid = Color(0xFF9090A0); // secondary / label text
  static const _onSurfaceDim = Color(0xFF55555F); // placeholder / hint

  static ThemeData get dark {
    final base = ThemeData.dark();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _accent,
        primaryContainer: _accentMuted,
        secondary: _accent,
        surface: _surface,
        surfaceContainerHighest: _card,
        outline: _border,
        onPrimary: Colors.white,
        onSurface: _onSurface,
        onSurfaceVariant: _onSurfaceMid,
        error: Color(0xFFCF6679),
      ),
      scaffoldBackgroundColor: _bg,

      // ── Typography ────────────────────────────────────────────────────────
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: _onSurface,
        displayColor: _onSurface,
      ),

      // ── Cards ─────────────────────────────────────────────────────────────
      cardTheme: const CardThemeData(
        color: _card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: _border),
        ),
      ),

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: _bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: _onSurface, size: 22),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _onSurface,
          letterSpacing: 0.2,
        ),
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(color: _border, thickness: 1),

      // ── Input fields ──────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        labelStyle: const TextStyle(color: _onSurfaceMid),
        hintStyle: const TextStyle(color: _onSurfaceDim),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: _accent.withAlpha(180), width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),

      // ── Chips ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: _surface,
        selectedColor: _accentMuted,
        side: const BorderSide(color: _border),
        labelStyle: const TextStyle(
          color: _onSurface,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),

      // ── Elevated buttons ──────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _border,
          disabledForegroundColor: _onSurfaceDim,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // ── Icon buttons ──────────────────────────────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: _onSurfaceMid,
        ),
      ),
    );
  }
}
