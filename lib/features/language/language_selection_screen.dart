import 'package:flutter/material.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/radio_option.dart';
import '../../data/models/schedule_model.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'en';

  static const List<LanguageModel> _languages = [
    LanguageModel(code: 'en', name: 'English', nativeName: 'English'),
    LanguageModel(code: 'te', name: 'Telugu', nativeName: 'తెలుగు'),
    LanguageModel(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
    LanguageModel(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ'),
    LanguageModel(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்'),
    LanguageModel(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.language,
                  size: 32,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.selectLanguage,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.choosePreferredLanguage,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: _languages.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final lang = _languages[index];
                    return RadioOption<String>(
                      value: lang.code,
                      groupValue: _selectedLanguage,
                      title: lang.name,
                      subtitle: lang.nativeName,
                      onChanged: (value) {
                        setState(() => _selectedLanguage = value);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: AppStrings.continueText,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
