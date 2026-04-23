import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/app_spacing.dart';
import '../viewmodels/progression_viewmodel.dart';
import '../widgets/chord_chip.dart';

class InspirationScreen extends ConsumerWidget {
  const InspirationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(progressionViewModelProvider);
    final vm = ref.read(progressionViewModelProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Inspiration')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Feeling stuck? Generate a random chord spark.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.gapXl,
              ElevatedButton.icon(
                onPressed: vm.generateRandom,
                icon: const Icon(Icons.shuffle_outlined, size: 18),
                label: const Text('Spark Inspiration'),
              ),
              if (state.progression != null) ...[
                AppSpacing.gapXl,
                _InspirationCard(state: state),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InspirationCard extends StatelessWidget {
  const _InspirationCard({required this.state});

  final ProgressionState state;

  @override
  Widget build(BuildContext context) {
    final progression = state.progression!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Emotion icon in a tinted circle — clean, no emoji
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                progression.emotion.icon,
                size: 26,
                color: colorScheme.primary,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              progression.emotion.label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.gapMd,
            Text(
              progression.label,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: 2.5,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            AppSpacing.gapMd,
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children:
                  progression.chords.map((c) => ChordChip(chord: c)).toList(),
            ),
            AppSpacing.gapMd,
            Text(
              progression.description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
