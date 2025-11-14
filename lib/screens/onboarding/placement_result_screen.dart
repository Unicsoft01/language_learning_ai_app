import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class PlacementResultScreen extends StatelessWidget {
  const PlacementResultScreen({super.key});

  // For now, hard-code A2 + dummy units.
  // Later, you can pass level & units via arguments.
  final String _level = 'A2';

  List<_RecommendedUnit> get _recommendedUnits => const [
    _RecommendedUnit(
      title: 'Core vocab: Daily routines',
      description: 'Learn essential verbs and phrases for everyday actions.',
    ),
    _RecommendedUnit(
      title: 'Grammar focus: Present simple',
      description:
          'Practise sentence structure and question forms at A2 level.',
    ),
    _RecommendedUnit(
      title: 'Listening: Short conversations',
      description:
          'Improve listening with short, clear dialogues about daily life.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Your starting level')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // Level badge
              CircleAvatar(
                radius: 40,
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                child: Text(
                  _level,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'We think this is your current level.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Estimated from your placement test responses.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Info card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This helps us choose lessons that are challenging but not overwhelming.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Recommended units section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recommended to start with',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),

              Column(
                children: _recommendedUnits
                    .map((unit) => _RecommendedUnitCard(unit: unit))
                    .toList(),
              ),

              const SizedBox(height: 32),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                  child: const Text('Start learning'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.setupPlacement,
                    );
                  },
                  child: const Text('Retake test'),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecommendedUnit {
  final String title;
  final String description;

  const _RecommendedUnit({required this.title, required this.description});
}

class _RecommendedUnitCard extends StatelessWidget {
  final _RecommendedUnit unit;

  const _RecommendedUnitCard({required this.unit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary.withOpacity(0.08),
                child: Icon(
                  Icons.menu_book,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(unit.title, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      unit.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(
                          0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
