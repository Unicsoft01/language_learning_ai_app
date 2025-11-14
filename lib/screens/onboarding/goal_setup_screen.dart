import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class GoalSetupScreen extends StatefulWidget {
  const GoalSetupScreen({super.key});

  @override
  State<GoalSetupScreen> createState() => _GoalSetupScreenState();
}

class _GoalSetupScreenState extends State<GoalSetupScreen> {
  double _dailyMinutes = 15; // default value
  TimeOfDay? _reminderTime;

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? now,
    );

    if (!mounted) return;

    if (picked != null) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  String get _formattedReminderTime {
    if (_reminderTime == null) {
      return 'No reminder set';
    }
    return _reminderTime!.format(context);
  }

  int get _weeklyMinutes => (_dailyMinutes.round() * 7);

  void _onContinue() {
    // TODO: persist goal & reminder settings if needed

    Navigator.pushNamed(
      context,
      AppRoutes.setupPlacement, // you will add this in AppRoutes
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Learning goals')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set your daily learning goal',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'A small, consistent habit is better than a long session once in a while.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Daily minutes slider card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Daily minutes', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('5 min', style: theme.textTheme.bodySmall),
                          Text(
                            '${_dailyMinutes.round()} min',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                          Text('30 min', style: theme.textTheme.bodySmall),
                        ],
                      ),
                      Slider(
                        min: 5,
                        max: 30,
                        divisions: 25,
                        label: '${_dailyMinutes.round()} min',
                        value: _dailyMinutes,
                        onChanged: (value) {
                          setState(() {
                            _dailyMinutes = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Reminder time picker
              Text('Reminder time', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 1,
                child: ListTile(
                  leading: Icon(Icons.alarm, color: colorScheme.primary),
                  title: Text(
                    _formattedReminderTime,
                    style: theme.textTheme.bodyMedium,
                  ),
                  subtitle: const Text('We’ll remind you around this time.'),
                  trailing: TextButton(
                    onPressed: _pickTime,
                    child: const Text('Change'),
                  ),
                  onTap: _pickTime,
                ),
              ),

              const SizedBox(height: 24),

              // Weekly summary
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: colorScheme.primaryContainer.withOpacity(0.4),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: colorScheme.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.calendar_today,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'You’ll study approximately $_weeklyMinutes minutes per week.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You can adjust your goal later if it feels too easy or too hard.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
