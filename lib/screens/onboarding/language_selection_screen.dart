import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flag/flag.dart';
import '../../routes/app_routes.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _nativeLanguage;
  String? _targetLanguage;
  bool _saving = false;

  // Language + canonical country code for flag SVG (customize freely)
  final List<Map<String, String>> _languages = const [
    {'name': 'English', 'code': 'GB'},
    {'name': 'French', 'code': 'FR'},
    {'name': 'Spanish', 'code': 'ES'},
    {'name': 'German', 'code': 'DE'},
    {'name': 'Chinese', 'code': 'CN'},
    {'name': 'Arabic', 'code': 'SA'},
  ];

  Map<String, String> get _codeByName => {
    for (final l in _languages) l['name']!: l['code']!,
  };

  Future<void> _saveSelections() async {
    if (_nativeLanguage == null || _targetLanguage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both languages')),
      );
      return;
    }
    if (_nativeLanguage == _targetLanguage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Native and target cannot be the same')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('native_language', _nativeLanguage!);
      await prefs.setString('target_language', _targetLanguage!);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _swapLanguages() {
    if (_nativeLanguage == null && _targetLanguage == null) return;
    setState(() {
      final tmp = _nativeLanguage;
      _nativeLanguage = _targetLanguage;
      _targetLanguage = tmp;
    });
  }

  Widget _buildFancyDropdown({
    required String label,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF121212)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              if (Theme.of(context).brightness == Brightness.light)
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
            ],
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              hint: const Text('Select'),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: _languages.map((lang) {
                final code = lang['code']!;
                final name = lang['name']!;
                return DropdownMenuItem<String>(
                  value: name,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Flag.fromString(
                          code,
                          height: 20,
                          width: 28,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final canContinue =
        _nativeLanguage != null &&
        _targetLanguage != null &&
        _nativeLanguage != _targetLanguage;

    final surface = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF6FAFF);

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        centerTitle: true,
        title: const Text(
          'Language Setup',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Brand/Logo (optional)
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF111827)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    if (Theme.of(context).brightness == Brightness.light)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      "Choose your native and target learning languages",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Step badges
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StepDot(active: true, label: '1'),
                        _Connector(),
                        _StepDot(active: canContinue, label: '2'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Dropdowns
                    _buildFancyDropdown(
                      label: 'Native language',
                      value: _nativeLanguage,
                      onChanged: (v) => setState(() => _nativeLanguage = v),
                    ),
                    const SizedBox(height: 16),
                    _buildFancyDropdown(
                      label: 'Target language',
                      value: _targetLanguage,
                      onChanged: (v) => setState(() => _targetLanguage = v),
                    ),
                    const SizedBox(height: 14),
                    // Selected preview + swap
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (_nativeLanguage != null)
                                _SelChip(
                                  label: 'Native: ${_nativeLanguage!}',
                                  flagCode: _codeByName[_nativeLanguage!]!,
                                ),
                              if (_targetLanguage != null)
                                _SelChip(
                                  label: 'Target: ${_targetLanguage!}',
                                  flagCode: _codeByName[_targetLanguage!]!,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: 'Swap languages',
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap:
                                (_nativeLanguage != null ||
                                    _targetLanguage != null)
                                ? _swapLanguages
                                : null,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.08),
                              ),
                              child: const Icon(Icons.swap_vert_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_nativeLanguage == _targetLanguage &&
                        _nativeLanguage != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Native and target cannot be the same',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: canContinue
                        ? const LinearGradient(
                            colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [
                              Colors.grey.shade400,
                              Colors.grey.shade500,
                            ],
                          ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextButton(
                    onPressed: canContinue && !_saving ? _saveSelections : null,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.6,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Continue',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelChip extends StatelessWidget {
  final String label;
  final String flagCode;

  const _SelChip({required this.label, required this.flagCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 6, right: 10, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0B1220)
            : const Color(0xFFF1F5FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Flag.fromString(
              flagCode,
              height: 18,
              width: 24,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool active;
  final String label;
  const _StepDot({required this.active, required this.label});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active
            ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
            : Theme.of(context).dividerColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 8,
            backgroundColor: active
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor.withOpacity(0.6),
            child: const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
