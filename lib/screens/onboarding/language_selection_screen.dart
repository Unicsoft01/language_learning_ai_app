import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  // For now, only English target language is supported
  String _selectedTargetLanguage = 'English';

  // Dummy UI languages
  String _selectedUiLanguage = 'English';
  final List<String> _uiLanguages = ['English', 'French', 'Spanish', 'German'];

  // Proficiency levels
  String _selectedLevel = 'A2';
  final List<String> _levels = ['A1', 'A2', 'B1', 'B2'];

  void _onContinue() {
    // TODO: Persist selectedTargetLanguage, selectedUiLanguage, selectedLevel
    // and use them to seed the learner model.

    Navigator.pushNamed(
      context,
      AppRoutes.setupGoals, // <-- you will add this route constant
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Set up your learning')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your language settings',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'We use this information to personalise your learning path.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Target language card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: colorScheme.primary.withOpacity(0.08),
                        child: Icon(Icons.flag, color: colorScheme.primary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Target language',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedTargetLanguage,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onPressed: () {
                          // Only English for now
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'English is currently the only supported target language.',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // UI language dropdown
              Text('App language', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedUiLanguage,
                items: _uiLanguages
                    .map(
                      (lang) =>
                          DropdownMenuItem(value: lang, child: Text(lang)),
                    )
                    .toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedUiLanguage = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              // Level selection chips
              Text('Your current level', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _levels
                    .map(
                      (level) => ChoiceChip(
                        label: Text(level),
                        selected: _selectedLevel == level,
                        onSelected: (selected) {
                          if (!selected) return;
                          setState(() {
                            _selectedLevel = level;
                          });
                        },
                      ),
                    )
                    .toList(),
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
                'You can change these settings later in your profile.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
