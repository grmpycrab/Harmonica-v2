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

    return Scaffold(
      appBar: AppBar(title: const Text('Inspiration Mode')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Feeling stuck? Hit the button and get a random chord spark.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
              ),
              AppSpacing.gapXl,
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEA580C),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                onPressed: vm.generateRandom,
                icon: const Text('⚡', style: TextStyle(fontSize: 20)),
                label: const Text(
                  'Spark Inspiration',
                  style: TextStyle(fontSize: 16),
                ),
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Text(
              progression.emotion.emoji,
              style: const TextStyle(fontSize: 48),
            ),
            AppSpacing.gapSm,
            Text(
              progression.emotion.label,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            AppSpacing.gapMd,
            Text(
              progression.label,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
                letterSpacing: 2,
              ),
            ),
            AppSpacing.gapMd,
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: progression.chords
                  .map((c) => ChordChip(chord: c))
                  .toList(),
            ),
            AppSpacing.gapMd,
            Text(
              progression.description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white60,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
