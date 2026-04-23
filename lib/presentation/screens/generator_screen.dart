import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/app_spacing.dart';
import '../../domain/entities/genre_type.dart';
import '../viewmodels/progression_viewmodel.dart';
import '../widgets/chord_chip.dart';
import '../widgets/emotion_selector.dart';

class GeneratorScreen extends ConsumerWidget {
  const GeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(progressionViewModelProvider);
    final vm = ref.read(progressionViewModelProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chord Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: vm.reset,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Choose an emotion', style: theme.textTheme.titleMedium),
              AppSpacing.gapSm,
              EmotionSelector(
                selected: state.selectedEmotion,
                onSelect: vm.selectEmotion,
              ),
              AppSpacing.gapLg,
              _OptionalFields(
                onKeyChanged: vm.updateKey,
                onGenreChanged: vm.updateGenre,
              ),
              AppSpacing.gapLg,
              ElevatedButton(
                onPressed: state.selectedEmotion != null ? vm.generate : null,
                child: const Text('Generate Progression'),
              ),
              if (state.error != null) ...[
                AppSpacing.gapSm,
                Text(
                  state.error!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
              if (state.progression != null) ...[
                AppSpacing.gapXl,
                _ProgressionResult(state: state),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionalFields extends StatelessWidget {
  const _OptionalFields({
    required this.onKeyChanged,
    required this.onGenreChanged,
  });

  final ValueChanged<String> onKeyChanged;
  final ValueChanged<GenreType?> onGenreChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Optional', style: theme.textTheme.titleMedium),
        AppSpacing.gapSm,
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Key (e.g. A minor)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                onChanged: onKeyChanged,
              ),
            ),
            AppSpacing.hGapMd,
            Expanded(
              child: DropdownButtonFormField<GenreType?>(
                decoration: const InputDecoration(
                  labelText: 'Genre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                value: null,
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  ...GenreType.values.map(
                    (g) => DropdownMenuItem(
                      value: g,
                      child: Row(
                        children: [
                          Icon(g.icon, size: 16),
                          const SizedBox(width: 6),
                          Text(g.label),
                        ],
                      ),
                    ),
                  ),
                ],
                onChanged: onGenreChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressionResult extends StatelessWidget {
  const _ProgressionResult({required this.state});

  final ProgressionState state;

  @override
  Widget build(BuildContext context) {
    final progression = state.progression!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  progression.emotion.icon,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                AppSpacing.hGapSm,
                Text(
                  progression.emotion.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (progression.key.isNotEmpty) ...[
                  AppSpacing.hGapSm,
                  Chip(
                    label: Text(
                      progression.key,
                      style: const TextStyle(fontSize: 11),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ],
            ),
            AppSpacing.gapMd,
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children:
                  progression.chords.map((c) => ChordChip(chord: c)).toList(),
            ),
            AppSpacing.gapMd,
            Text(
              progression.label,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
                letterSpacing: 1.2,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              progression.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (progression.genre.isNotEmpty) ...[
              AppSpacing.gapSm,
              Text(
                progression.genre,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            AppSpacing.gapMd,
            const Divider(height: 1),
            AppSpacing.gapSm,
            OutlinedButton.icon(
              icon: const Icon(Icons.piano_outlined, size: 16),
              label: const Text('View in Piano Roll'),
              onPressed: () => context.push(AppConstants.routePianoRoll),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
