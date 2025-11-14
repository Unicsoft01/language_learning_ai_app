import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // For now, we assume Home is tab 0.
  int _currentIndex = 0;

  // Dummy progress values
  final double _todayGoalProgress = 0.6; // 60% of daily goal
  final int _streakDays = 3;
  final String _lastLessonTitle = 'Daily routines – A2';

  void _onNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home; do nothing or pop to root
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.lessons);
        break;
      case 2:
        // Use analytics as "Progress" for now
        Navigator.pushNamed(context, AppRoutes.analytics);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
  }

  void _onStartSession() {
    // For now, just go to lessons list
    Navigator.pushNamed(context, AppRoutes.lessons);
  }

  void _onResumeLesson() {
    // TODO: deep-link into last lesson player
    Navigator.pushNamed(context, AppRoutes.lessons);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LinguaAI'),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.notifications);
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.colorScheme.surface,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              label: 'Lessons',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_outlined),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Greeting
            Text('Welcome back, Sochman 👋', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Let’s keep your English practice going.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Continue learning card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: colorScheme.primary.withOpacity(0.08),
                      child: Icon(
                        Icons.play_circle_fill,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Continue learning',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _lastLessonTitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _onResumeLesson,
                      child: const Text('Resume'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Recommendation chips
            Text('Recommended focus', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  _RecommendationChip(
                    label: 'Vocabulary',
                    icon: Icons.text_fields,
                  ),
                  _RecommendationChip(label: 'Grammar', icon: Icons.rule),
                  _RecommendationChip(label: 'Listening', icon: Icons.hearing),
                  _RecommendationChip(label: 'Speaking', icon: Icons.mic_none),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Streak + daily goal progress
            Row(
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: colorScheme.secondary.withOpacity(
                              0.08,
                            ),
                            child: Icon(
                              Icons.local_fire_department_outlined,
                              color: colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Streak', style: theme.textTheme.bodyMedium),
                              const SizedBox(height: 2),
                              Text(
                                '$_streakDays days',
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 46,
                            width: 46,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: _todayGoalProgress,
                                  strokeWidth: 5,
                                ),
                                Text(
                                  '${(_todayGoalProgress * 100).round()}%',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Today’s goal',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Almost there!',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.textTheme.bodySmall?.color
                                        ?.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Start session CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onStartSession,
                child: const Text('Start 5-min session'),
              ),
            ),

            const SizedBox(height: 8),
            Text(
              'We’ll pick a short set of exercises based on your current level.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _RecommendationChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colorScheme.primary),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        selected: false,
        onSelected: (_) {
          // TODO: filter recommendations or navigate to relevant lessons
        },
      ),
    );
  }
}
