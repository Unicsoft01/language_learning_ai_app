import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  String _selectedSkill = 'All';
  String _selectedLevel = 'All';

  // Dummy lesson data – later replace with real backend data.
  final List<Lesson> _allLessons = const [
    Lesson(
      id: '1',
      title: 'Daily routines vocabulary',
      durationMinutes: 10,
      microObjective: 'Learn key verbs and phrases for everyday actions.',
      skill: 'Vocabulary',
      level: 'A2',
    ),
    Lesson(
      id: '2',
      title: 'Present simple – statements',
      durationMinutes: 12,
      microObjective: 'Practise present simple for facts and habits.',
      skill: 'Grammar',
      level: 'A2',
    ),
    Lesson(
      id: '3',
      title: 'Short dialogues: at the café',
      durationMinutes: 8,
      microObjective: 'Improve listening with short, clear conversations.',
      skill: 'Listening',
      level: 'A2',
    ),
    Lesson(
      id: '4',
      title: 'Introduce yourself',
      durationMinutes: 7,
      microObjective: 'Practise speaking about your name, job, and hobbies.',
      skill: 'Speaking',
      level: 'A1',
    ),
    Lesson(
      id: '5',
      title: 'Travel phrases – airport',
      durationMinutes: 15,
      microObjective: 'Learn useful expressions for travelling.',
      skill: 'Vocabulary',
      level: 'B1',
    ),
  ];

  List<String> get _skillFilters => [
    'All',
    'Vocabulary',
    'Grammar',
    'Listening',
    'Speaking',
  ];

  List<String> get _levelFilters => ['All', 'A1', 'A2', 'B1', 'B2'];

  List<Lesson> get _filteredLessons {
    return _allLessons.where((lesson) {
      final skillMatch =
          _selectedSkill == 'All' || lesson.skill == _selectedSkill;
      final levelMatch =
          _selectedLevel == 'All' || lesson.level == _selectedLevel;
      return skillMatch && levelMatch;
    }).toList();
  }

  IconData _iconForSkill(String skill) {
    switch (skill) {
      case 'Vocabulary':
        return Icons.text_fields;
      case 'Grammar':
        return Icons.rule;
      case 'Listening':
        return Icons.hearing;
      case 'Speaking':
        return Icons.mic_none;
      default:
        return Icons.menu_book_outlined;
    }
  }

  void _openLessonDetail(Lesson lesson) {
    // Use named route and pass the Lesson as arguments.
    // Ensure AppRoutes.lessonDetail is registered to a screen that reads arguments.
    Navigator.pushNamed(context, AppRoutes.lessonDetail, arguments: lesson);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final lessons = _filteredLessons;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Lessons'), centerTitle: false),
        body: Column(
          children: [
            // Filters section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Skill', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _skillFilters
                          .map(
                            (skill) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(skill),
                                selected: _selectedSkill == skill,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedSkill = skill;
                                  });
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Level', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _levelFilters
                          .map(
                            (level) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(level),
                                selected: _selectedLevel == level,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedLevel = level;
                                  });
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Lesson list
            Expanded(
              child: lessons.isEmpty
                  ? const _EmptyLessonsView()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: lessons.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final lesson = lessons[index];
                        return _LessonCard(
                          lesson: lesson,
                          icon: _iconForSkill(lesson.skill),
                          onTap: () => _openLessonDetail(lesson),
                          onStart: () => _openLessonDetail(lesson),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final int durationMinutes;
  final String microObjective;
  final String skill;
  final String level;

  const Lesson({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.microObjective,
    required this.skill,
    required this.level,
  });
}

class _LessonCard extends StatelessWidget {
  final Lesson lesson;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onStart;

  const _LessonCard({
    required this.lesson,
    required this.icon,
    required this.onTap,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.primary.withOpacity(0.08),
                child: Icon(icon, color: colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      lesson.microObjective,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: theme.textTheme.bodySmall?.color?.withOpacity(
                            0.8,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${lesson.durationMinutes} min',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            lesson.level,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          lesson.skill,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(onPressed: onStart, child: const Text('Start')),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyLessonsView extends StatelessWidget {
  const _EmptyLessonsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: colorScheme.primary.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No lessons match your filters',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try changing the skill or level to see more options.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
