import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/app_spacing.dart';
import '../viewmodels/theory_viewmodel.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(theoryViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Learn Theory')),
      body: lessonsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (lessons) => ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: lessons.length,
          separatorBuilder: (_, __) => AppSpacing.gapMd,
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            return _LessonCard(lesson: lesson);
          },
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.lesson});

  final Map<String, dynamic> lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final examples = (lesson['examples'] as List?)?.cast<String>() ?? [];

    return Card(
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        title: Text(
          lesson['title'] as String? ?? '',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          lesson['category'] as String? ?? '',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        children: [
          Text(
            lesson['content'] as String? ?? '',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          if (examples.isNotEmpty) ...[
            AppSpacing.gapMd,
            Text('Examples:', style: theme.textTheme.labelLarge),
            AppSpacing.gapXs,
            ...examples.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: Colors.white54)),
                    Expanded(
                      child: Text(
                        e,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white54,
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
    );
  }
}
