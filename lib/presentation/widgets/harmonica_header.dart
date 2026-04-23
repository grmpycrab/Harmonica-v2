import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A fully custom app header for Harmonica.
///
/// Layout: [menu icon] ←→ [title — true center] ←→ [notification icon]
///
/// The title is pinned to the absolute center of the header using a [Stack]
/// so it never shifts regardless of badge width or icon sizes.
///
/// Usage:
/// ```dart
/// HarmonicaHeader(
///   onMenuPressed: () => scaffoldKey.currentState?.openDrawer(),
///   onNotificationPressed: () { /* handle */ },
///   notificationCount: 3,
/// )
/// ```
class HarmonicaHeader extends StatelessWidget {
  const HarmonicaHeader({
    super.key,
    required this.onMenuPressed,
    required this.onNotificationPressed,
    this.notificationCount = 0,
    this.title = 'Harmonica',
  });

  final VoidCallback onMenuPressed;
  final VoidCallback onNotificationPressed;

  /// Badge count shown on the notification icon. Hidden when 0.
  final int notificationCount;

  /// Header title. Defaults to the app name.
  final String title;

  // ── Layout constants ────────────────────────────────────────────────────────
  static const double _height = 60;
  static const double _iconSize = 22;
  static const double _iconAreaWidth = 48; // tap target width for both sides

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: _height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ── True-center title ──────────────────────────────────────────
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),

            // ── Left: hamburger ────────────────────────────────────────────
            Positioned(
              left: 0,
              child: _HeaderIconButton(
                icon: Icons.menu,
                iconSize: _iconSize,
                width: _iconAreaWidth,
                onPressed: onMenuPressed,
              ),
            ),

            // ── Right: notification bell ───────────────────────────────────
            Positioned(
              right: 0,
              child: _NotificationButton(
                iconSize: _iconSize,
                width: _iconAreaWidth,
                count: notificationCount,
                badgeColor: colorScheme.error,
                onPressed: onNotificationPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────────

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onPressed,
    required this.width,
    required this.iconSize,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double width;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: IconButton(
        icon: Icon(icon, size: iconSize, color: Colors.white),
        onPressed: onPressed,
        splashRadius: 22,
        tooltip: 'Menu',
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({
    required this.count,
    required this.badgeColor,
    required this.onPressed,
    required this.width,
    required this.iconSize,
  });

  final int count;
  final Color badgeColor;
  final VoidCallback onPressed;
  final double width;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.notifications_outlined,
                size: iconSize, color: Colors.white),
            onPressed: onPressed,
            splashRadius: 22,
            tooltip: 'Notifications',
          ),
          if (count > 0)
            Positioned(
              top: 8,
              right: 8,
              child: _Badge(count: count, color: badgeColor),
            ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count, required this.color});

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Cap display at 99 to keep the badge small
    final label = count > 99 ? '99+' : '$count';

    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          height: 1.6,
        ),
      ),
    );
  }
}
