import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';

/// Persistent shell that wraps all top-level screens with a [NavigationBar].
///
/// The shell is declared as a [ShellRoute] in [appRouter]; [child] is
/// whatever screen go_router resolved for the current location.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  // ── Tab definitions ────────────────────────────────────────────────────────
  static const _destinations = [
    _TabDestination(
      path: AppConstants.routeHome,
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    _TabDestination(
      path: AppConstants.routeGenerator,
      icon: Icons.piano_outlined,
      activeIcon: Icons.piano,
      label: 'Generate',
    ),
    _TabDestination(
      path: AppConstants.routeInspiration,
      icon: Icons.donut_large_outlined,
      activeIcon: Icons.donut_large,
      label: 'Circle',
    ),
    _TabDestination(
      path: AppConstants.routeLearn,
      icon: Icons.library_books_outlined,
      activeIcon: Icons.library_books,
      label: 'Learn',
    ),
    _TabDestination(
      path: AppConstants.routeSettings,
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  // Check most-specific paths first; home ('/') is the fallback.
  static int _indexForLocation(String loc) {
    if (loc.startsWith(AppConstants.routeSettings)) return 4;
    if (loc.startsWith(AppConstants.routeLearn)) return 3;
    if (loc.startsWith(AppConstants.routeInspiration)) return 2;
    if (loc.startsWith(AppConstants.routeGenerator)) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _indexForLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => context.go(_destinations[index].path),
        destinations: _destinations
            .map(
              (d) => NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.activeIcon),
                label: d.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

// ── Private data class ─────────────────────────────────────────────────────

class _TabDestination {
  const _TabDestination({
    required this.path,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
