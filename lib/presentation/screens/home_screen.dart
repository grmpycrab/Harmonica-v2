// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/app_spacing.dart';
import '../widgets/harmonica_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Builder(
                builder: (innerContext) => HarmonicaHeader(
                  onMenuPressed: () => Scaffold.of(innerContext).openDrawer(),
                  onNotificationPressed: () {},
                ),
              ),
              AppSpacing.gapMd,
              Text(
                'What do you want to do today?',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
              AppSpacing.gapXl,
              _HomeCard(
                icon: Icons.piano_outlined,
                title: 'Chord Generator',
                subtitle: 'Generate progressions by emotion or genre',
                color: const Color(0xFF7C3AED),
                onTap: () => context.push(AppConstants.routeGenerator),
              ),
              AppSpacing.gapMd,
              _HomeCard(
                icon: Icons.bolt_outlined,
                title: 'Inspiration Mode',
                subtitle: 'Feeling stuck? Get a random spark',
                color: const Color(0xFFEA580C),
                onTap: () => context.push(AppConstants.routeInspiration),
              ),
              AppSpacing.gapMd,
              _HomeCard(
                icon: Icons.school_outlined,
                title: 'Learn Theory',
                subtitle: 'Chords, scales, progressions & more',
                color: const Color(0xFF0891B2),
                onTap: () => context.push(AppConstants.routeLearn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSpacing.gapXs,
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}
