import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/utils/app_spacing.dart';
import '../../data/datasources/theory_local_datasource.dart';
import '../../domain/entities/progression.dart';
import '../widgets/chord_chip.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Progression? _spark;

  @override
  void initState() {
    super.initState();
    // Generate once after the first frame so providers are ready.
    WidgetsBinding.instance.addPostFrameCallback((_) => _regenerate());
  }

  void _regenerate() {
    final service = ref.read(chordGeneratorServiceProvider);
    setState(() => _spark = service.generateRandom());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Harmonica')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Greeting ─────────────────────────────────────────────────
              _GreetingSection(theme: theme, colorScheme: colorScheme),
              AppSpacing.gapXl,

              // ── Today's Spark ─────────────────────────────────────────────
              _SectionLabel(label: "Today's Spark", colorScheme: colorScheme),
              AppSpacing.gapSm,
              _SparkCard(
                progression: _spark,
                onRefresh: _regenerate,
                theme: theme,
                colorScheme: colorScheme,
              ),
              AppSpacing.gapXl,

              // ── Theory Tip ────────────────────────────────────────────────
              _SectionLabel(
                  label: 'Theory Tip of the Day', colorScheme: colorScheme),
              AppSpacing.gapSm,
              _TheoryTipCard(theme: theme, colorScheme: colorScheme),
              AppSpacing.gapLg,
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.colorScheme});

  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurfaceVariant,
        letterSpacing: 1.2,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Greeting
// ─────────────────────────────────────────────────────────────────────────────

class _GreetingSection extends StatelessWidget {
  const _GreetingSection({required this.theme, required this.colorScheme});

  final ThemeData theme;
  final ColorScheme colorScheme;

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning.';
    if (hour < 17) return 'Good afternoon.';
    return 'Good evening.';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greeting(),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSpacing.gapXs,
        Text(
          'Here\'s something to play with today.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Today's Spark card
// ─────────────────────────────────────────────────────────────────────────────

class _SparkCard extends StatelessWidget {
  const _SparkCard({
    required this.progression,
    required this.onRefresh,
    required this.theme,
    required this.colorScheme,
  });

  final Progression? progression;
  final VoidCallback onRefresh;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: progression == null
            ? const SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Emotion row
                  Row(
                    children: [
                      Icon(
                        progression!.emotion.icon,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      AppSpacing.hGapSm,
                      Text(
                        progression!.emotion.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      // Refresh button — stays in top-right of card
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 18,
                          icon: Icon(
                            Icons.refresh,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onPressed: onRefresh,
                          tooltip: 'New spark',
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapMd,

                  // Chord label — the main display
                  Text(
                    progression!.label,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  AppSpacing.gapMd,

                  // Chord chips
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: progression!.chords
                        .map((c) => ChordChip(chord: c))
                        .toList(),
                  ),
                  AppSpacing.gapMd,

                  // Description
                  Text(
                    progression!.description,
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

// ─────────────────────────────────────────────────────────────────────────────
// Theory Tip card
// ─────────────────────────────────────────────────────────────────────────────

class _TheoryTipCard extends StatelessWidget {
  const _TheoryTipCard({required this.theme, required this.colorScheme});

  final ThemeData theme;
  final ColorScheme colorScheme;

  static Map<String, dynamic> _dailyLesson() {
    final lessons = TheoryLocalDatasource.lessons;
    final index = DateTime.now().dayOfYear % lessons.length;
    return lessons[index];
  }

  @override
  Widget build(BuildContext context) {
    final lesson = _dailyLesson();
    final examples = (lesson['examples'] as List?)?.cast<String>() ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                (lesson['category'] as String? ?? '').toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                  letterSpacing: 1,
                ),
              ),
            ),
            AppSpacing.gapSm,
            Text(
              lesson['title'] as String? ?? '',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            AppSpacing.gapXs,
            Text(
              lesson['content'] as String? ?? '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            if (examples.isNotEmpty) ...[
              AppSpacing.gapMd,
              ...examples.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.music_note,
                        size: 12,
                        color: colorScheme.primary,
                      ),
                      AppSpacing.hGapSm,
                      Expanded(
                        child: Text(
                          e,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DateTime helper
// ─────────────────────────────────────────────────────────────────────────────

extension _DateTimeExt on DateTime {
  int get dayOfYear {
    return difference(DateTime(year, 1, 1)).inDays;
  }
}
