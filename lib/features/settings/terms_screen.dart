import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text('Terms & Conditions'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms & Conditions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            Text(
              'Last Updated: May 2026',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            SizedBox(height: 20),
            _SectionWidget(
              title: '1. Acceptance of Terms',
              body:
                  'By downloading, installing, or using the EntryTUD application, you agree to be bound by these Terms and Conditions. If you do not agree, please uninstall the application.',
            ),
            _SectionWidget(
              title: '2. User Account',
              body:
                  'You are responsible for maintaining the confidentiality of your account. You must provide accurate information during registration. Your TUD Number is unique and non-transferable.',
            ),
            _SectionWidget(
              title: '3. Privacy',
              body:
                  'Your privacy is important to us. We collect and process personal data as described in our Privacy Policy. By using the app, you consent to the collection and use of your information.',
            ),
            _SectionWidget(
              title: '4. Community Guidelines',
              body:
                  'Users must interact respectfully within KutComs. Harassment, spam, and inappropriate content are prohibited. Violation may result in account suspension.',
            ),
            _SectionWidget(
              title: '5. Service Usage',
              body:
                  'The app facilitates connections between service providers and consumers. EntryTUD does not guarantee the quality of services provided by users. Users are responsible for their interactions.',
            ),
            _SectionWidget(
              title: '6. Modifications',
              body:
                  'We reserve the right to modify these terms at any time. Continued use of the application constitutes acceptance of the modified terms.',
            ),
            SizedBox(height: 24),
            Text(
              'For questions about these terms, contact us at support@entrytud.com',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionWidget extends StatelessWidget {
  final String title;
  final String body;

  const _SectionWidget({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
