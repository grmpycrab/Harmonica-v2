import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../screens/generator_screen.dart';
import '../screens/home_screen.dart';
import '../screens/inspiration_screen.dart';
import '../screens/learn_screen.dart';
import '../screens/settings_screen.dart';
import '../shell/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: AppConstants.routeHome,
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(
        location: state.matchedLocation,
        child: child,
      ),
      routes: [
        GoRoute(
          path: AppConstants.routeHome,
          builder: (_, __) => const HomeScreen(),
        ),
        GoRoute(
          path: AppConstants.routeGenerator,
          builder: (_, __) => const GeneratorScreen(),
        ),
        GoRoute(
          path: AppConstants.routeInspiration,
          builder: (_, __) => const InspirationScreen(),
        ),
        GoRoute(
          path: AppConstants.routeLearn,
          builder: (_, __) => const LearnScreen(),
        ),
        GoRoute(
          path: AppConstants.routeSettings,
          builder: (_, __) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
