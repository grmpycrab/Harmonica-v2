import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../screens/generator_screen.dart';
import '../screens/home_screen.dart';
import '../screens/inspiration_screen.dart';
import '../screens/learn_screen.dart';

final appRouter = GoRouter(
  initialLocation: AppConstants.routeHome,
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
  ],
);
