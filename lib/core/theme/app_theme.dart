import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palette source: Bogdan Nikitin / Cloud7 UI kit
///   #F1A410  amber gold  → primary accent
///   #191D2D  dark navy   → dark bg
///   #34394B  mid navy    → dark surface / light text secondary
///   #FFFFFF  white       → dark text / light bg
class AppTheme {
  AppTheme._();

  // ── Shared accent ──────────────────────────────────────────────────────────
  static const _amber = Color(0xFFF1A410);

  // ── Dark palette ───────────────────────────────────────────────────────────
  static const _dBg = Color(0xFF191D2D);
  static const _dSurface = Color(0xFF1F2338);
  static const _dCard = Color(0xFF262B40);
  static const _dBorder = Color(0xFF34394B);
  static const _dAmberMuted = Color(0xFF3D2E05); // amber tint for chips/pills
  static const _dOnSurface = Color(0xFFF0EEF8);
  static const _dOnSurfaceMid = Color(0xFF8B91AA);
  static const _dOnSurfaceDim = Color(0xFF4E5270);

  // ── Light palette ──────────────────────────────────────────────────────────
  static const _lBg = Color(0xFFFFFFFF);
  static const _lSurface = Color(0xFFF5F3EE);
  static const _lCard = Color(0xFFEDEAE2);
  static const _lBorder = Color(0xFFDDD9CE);
  static const _lAmberMuted = Color(0xFFFEF3D7);
  static const _lOnSurface = Color(0xFF191D2D);
  static const _lOnSurfaceMid = Color(0xFF34394B);
  static const _lOnSurfaceDim = Color(0xFF8B91AA);

  // ── Themes ─────────────────────────────────────────────────────────────────
  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        bg: _dBg,
        surface: _dSurface,
        card: _dCard,
        border: _dBorder,
        amberMuted: _dAmberMuted,
        onSurface: _dOnSurface,
        onSurfaceMid: _dOnSurfaceMid,
        onSurfaceDim: _dOnSurfaceDim,
        errorColor: const Color(0xFFCF6679),
      );

  static ThemeData get light => _build(
        brightness: Brightness.light,
        bg: _lBg,
        surface: _lSurface,
        card: _lCard,
        border: _lBorder,
        amberMuted: _lAmberMuted,
        onSurface: _lOnSurface,
        onSurfaceMid: _lOnSurfaceMid,
        onSurfaceDim: _lOnSurfaceDim,
        errorColor: const Color(0xFFB83C50),
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color bg,
    required Color surface,
    required Color card,
    required Color border,
    required Color amberMuted,
    required Color onSurface,
    required Color onSurfaceMid,
    required Color onSurfaceDim,
    required Color errorColor,
  }) {
    final isDark = brightness == Brightness.dark;
    final base = isDark ? ThemeData.dark() : ThemeData.light();

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: _amber,
        onPrimary: Colors.white,
        primaryContainer: amberMuted,
        onPrimaryContainer: _amber,
        // NavigationBar uses secondaryContainer for the pill indicator
        secondary: _amber,
        onSecondary: Colors.white,
        secondaryContainer: amberMuted,
        onSecondaryContainer: _amber,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceMid,
        surfaceContainerHighest: card,
        outline: border,
        error: errorColor,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: bg,

      // ── Typography ──────────────────────────────────────────────────────
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: onSurface,
        displayColor: onSurface,
      ),

      // ── Cards ───────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: border),
        ),
      ),

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: onSurface, size: 22),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: onSurface,
          letterSpacing: 0.2,
        ),
      ),

      // ── NavigationBar ────────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 64,
        indicatorColor: amberMuted,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: _amber, size: 22);
          }
          return IconThemeData(color: onSurfaceMid, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _amber,
            );
          }
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: onSurfaceMid,
          );
        }),
      ),

      // ── Divider ─────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(color: border, thickness: 1),

      // ── Input fields ─────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        labelStyle: TextStyle(color: onSurfaceMid),
        hintStyle: TextStyle(color: onSurfaceDim),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: _amber.withAlpha(180), width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),

      // ── Chips ────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: amberMuted,
        side: BorderSide(color: border),
        labelStyle: TextStyle(
          color: onSurface,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),

      // ── Elevated buttons ─────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _amber,
          foregroundColor: Colors.white,
          disabledBackgroundColor: border,
          disabledForegroundColor: onSurfaceDim,
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

      // ── Icon buttons ─────────────────────────────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: onSurfaceMid,
        ),
      ),

      // ── Toggle buttons ───────────────────────────────────────────────────
      toggleButtonsTheme: ToggleButtonsThemeData(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        selectedColor: _amber,
        fillColor: amberMuted,
        color: onSurfaceMid,
        borderColor: border,
        selectedBorderColor: _amber,
      ),
    );
  }
}
