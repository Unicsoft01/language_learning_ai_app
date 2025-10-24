import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_routes.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _nativeLanguage;
  String? _targetLanguage;

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'flag': 'assets/flags/en.png'},
    {'name': 'French', 'flag': 'assets/flags/fr.png'},
    {'name': 'Spanish', 'flag': 'assets/flags/es.png'},
    {'name': 'German', 'flag': 'assets/flags/de.png'},
    {'name': 'Chinese', 'flag': 'assets/flags/zh.png'},
    {'name': 'Arabic', 'flag': 'assets/flags/ar.png'},
  ];

  Future<void> _saveSelections() async {
    if (_nativeLanguage != null && _targetLanguage != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('native_language', _nativeLanguage!);
      await prefs.setString('target_language', _targetLanguage!);

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both languages')),
      );
    }
  }

  Widget _buildLanguageDropdown({
    required String label,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(label),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          items: _languages.map((lang) {
            return DropdownMenuItem<String>(
              value: lang['name'],
              child: Row(
                children: [
                  Image.asset(lang['flag']!, width: 28, height: 20),
                  const SizedBox(width: 10),
                  Text(lang['name']!),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset(
                'assets/logo.png',
                height: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                "Language Setup",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Choose your native and target learning languages",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 50),

              // Native Language Dropdown
              _buildLanguageDropdown(
                label: "Select your native language",
                value: _nativeLanguage,
                onChanged: (value) {
                  setState(() => _nativeLanguage = value);
                },
              ),
              const SizedBox(height: 30),

              // Target Language Dropdown
              _buildLanguageDropdown(
                label: "Select your target learning language",
                value: _targetLanguage,
                onChanged: (value) {
                  setState(() => _targetLanguage = value);
                },
              ),
              const Spacer(),

              // Continue Button
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextButton(
                  onPressed: _saveSelections,
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
