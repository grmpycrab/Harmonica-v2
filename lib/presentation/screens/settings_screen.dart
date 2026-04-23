import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/utils/app_spacing.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Section label ──────────────────────────────────────────
              Text(
                'Appearance',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.8,
                ),
              ),
              AppSpacing.gapSm,

              // ── Theme toggle card ──────────────────────────────────────
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.palette_outlined,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      AppSpacing.hGapMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Theme',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              isDark ? 'Dark' : 'Light',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Dark / Light toggle buttons
                      ToggleButtons(
                        isSelected: [isDark, !isDark],
                        onPressed: (index) {
                          ref.read(themeModeProvider.notifier).state =
                              index == 0 ? ThemeMode.dark : ThemeMode.light;
                        },
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Icon(Icons.nights_stay_outlined, size: 18),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Icon(Icons.wb_sunny_outlined, size: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
