import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'lessons_screen.dart'; // For the Lesson model

class LessonDetailScreen extends StatelessWidget {
  const LessonDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Try to get Lesson from navigation arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    Lesson? lesson;
    if (args is Lesson) {
      lesson = args;
    }

    // Fallback dummy if nothing was passed (so the screen doesn’t crash in testing)
    lesson ??= const Lesson(
      id: 'fallback',
      title: 'Sample lesson',
      durationMinutes: 10,
      microObjective: 'Understand the structure of the lesson detail screen.',
      skill: 'Vocabulary',
      level: 'A2',
    );

    // Dummy objectives & item types for now – you can later attach these to Lesson
    final objectives = <String>[
      'Review key vocabulary in context.',
      'Practise recognition with short multiple-choice items.',
      'Apply new words in simple sentences.',
    ];

    final itemTypes = <String>['MCQ', 'Gap-fill', 'Listening', 'Speaking'];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Lesson details'), centerTitle: false),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(lesson.title, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),

              // Skill chip + level + duration
              Row(
                children: [
                  _SkillChip(label: lesson.skill, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  _PillChip(
                    label: 'Level ${lesson.level}',
                    icon: Icons.verified_outlined,
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${lesson.durationMinutes} min',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Micro-objective / short intro
              Text(
                lesson.microObjective,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.85),
                ),
              ),

              const SizedBox(height: 24),

              // Objectives section
              Text('Objectives', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Column(
                children: objectives
                    .map(
                      (obj) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('•  '),
                            Expanded(
                              child: Text(
                                obj,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 24),

              // Item types
              Text('Included activities', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: itemTypes
                    .map(
                      (type) =>
                          _TagChip(label: type, icon: _iconForItemType(type)),
                    )
                    .toList(),
              ),

              const SizedBox(height: 24),

              // Info banner (prerequisite or tips)
              _InfoBanner(
                icon: Icons.info_outline,
                text:
                    'Tip: You’ll get the best results if you complete this lesson in one sitting, without distractions.',
              ),

              const SizedBox(height: 32),

              // Start button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // For now, route to generic exercise screen
                    Navigator.pushNamed(context, AppRoutes.exercise);
                  },
                  child: const Text('Start lesson'),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We’ll adapt the exercises based on your answers as you go.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForItemType(String type) {
    switch (type) {
      case 'MCQ':
        return Icons.checklist_rtl;
      case 'Gap-fill':
        return Icons.edit_note_outlined;
      case 'Listening':
        return Icons.hearing;
      case 'Speaking':
        return Icons.mic_none;
      default:
        return Icons.extension_outlined;
    }
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  final Color color;

  const _SkillChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_outlined, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PillChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _PillChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _TagChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Chip(
      avatar: Icon(icon, size: 16, color: colorScheme.primary),
      label: Text(label),
      backgroundColor: colorScheme.primary.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoBanner({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.secondary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
