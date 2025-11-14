import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class PlacementTestScreen extends StatefulWidget {
  const PlacementTestScreen({super.key});

  @override
  State<PlacementTestScreen> createState() => _PlacementTestScreenState();
}

class _PlacementTestScreenState extends State<PlacementTestScreen> {
  final List<_PlacementQuestion> _questions = const [
    _PlacementQuestion(
      question: 'Choose the correct option: “I ____ to the market yesterday.”',
      options: ['go', 'went', 'gone', 'going'],
    ),
    _PlacementQuestion(
      question: 'What is the synonym of “happy”?',
      options: ['sad', 'angry', 'joyful', 'tired'],
    ),
    _PlacementQuestion(
      question: 'Select the correct sentence:',
      options: [
        'She don’t like coffee.',
        'She does not likes coffee.',
        'She doesn’t like coffee.',
        'She not like coffee.',
      ],
    ),
    _PlacementQuestion(
      question: 'Fill in the blank: “They ____ English every day.”',
      options: ['study', 'studies', 'studying', 'studied'],
    ),
    _PlacementQuestion(
      question: 'Which word is a noun?',
      options: ['run', 'quickly', 'happiness', 'blue'],
    ),
  ];

  int _currentIndex = 0;
  int? _selectedOptionIndex;

  void _onOptionTap(int index) {
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  void _goToNext({bool skipped = false}) {
    // TODO: log answer or skip if you want to store results later

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
      });
    } else {
      // Last question → navigate to placement result
      // Navigator.pushNamed(
      //   context,
      //   AppRoutes.setupPlacementResult, // you'll add this in AppRoutes
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final currentQuestion = _questions[_currentIndex];
    final total = _questions.length;
    final progressValue = (_currentIndex + 1) / total;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Placement test')),
        body: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  LinearProgressIndicator(value: progressValue),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentIndex + 1} of $total',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Approx. 5–7 questions',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question text
                    Text(
                      currentQuestion.question,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),

                    // Options
                    Column(
                      children: List.generate(currentQuestion.options.length, (
                        index,
                      ) {
                        final optionText = currentQuestion.options[index];
                        final isSelected = _selectedOptionIndex == index;

                        return _OptionCard(
                          text: optionText,
                          isSelected: isSelected,
                          onTap: () => _onOptionTap(index),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom bar: Skip / Next
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => _goToNext(skipped: true),
                    child: const Text('Skip'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => _goToNext(skipped: false),
                    child: Text(_currentIndex == total - 1 ? 'Finish' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlacementQuestion {
  final String question;
  final List<String> options;

  const _PlacementQuestion({required this.question, required this.options});
}

class _OptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withOpacity(0.1)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : theme.dividerColor.withOpacity(0.4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
                if (isSelected)
                  Icon(Icons.check_circle, color: colorScheme.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
