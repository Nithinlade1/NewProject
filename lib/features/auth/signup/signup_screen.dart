import 'package:flutter/material.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _hasPhoto = false;
  bool _termsAccepted = false;
  bool _isLoading = false;

  String? _nameError;
  String? _emailError;
  String? _photoError;
  String? _termsError;

  String _phone = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _phone = args;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _pickPhoto() {
    setState(() {
      _hasPhoto = true;
      _photoError = null;
    });
  }

  bool _validate() {
    bool isValid = true;

    final photoError = Validators.validateProfilePhoto(_hasPhoto);
    if (photoError != null) {
      _photoError = photoError;
      isValid = false;
    }

    final nameError = Validators.validateName(_nameController.text);
    if (nameError != null) {
      _nameError = nameError;
      isValid = false;
    }

    final emailError = Validators.validateEmail(_emailController.text);
    if (emailError != null) {
      _emailError = emailError;
      isValid = false;
    }

    final termsError = Validators.validateTerms(_termsAccepted);
    if (termsError != null) {
      _termsError = termsError;
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  Future<void> _handleSignup() async {
    if (!_validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.tudNumber,
        arguments: _phone,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(AppStrings.signupTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Photo
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickPhoto,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryLight,
                        border: Border.all(
                          color: _photoError != null
                              ? AppColors.danger
                              : AppColors.primary,
                          width: 2,
                        ),
                      ),
                      child: _hasPhoto
                          ? const ClipOval(
                              child: Icon(
                                Icons.person,
                                size: 48,
                                color: AppColors.primary,
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt,
                                    size: 28, color: AppColors.primary),
                                SizedBox(height: 4),
                                Text(
                                  'Add Photo',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  if (_photoError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _photoError!,
                      style: const TextStyle(
                        color: AppColors.danger,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  const Text(
                    '* Required',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Name
            CustomTextField(
              label: 'Name *',
              hintText: 'Enter your name',
              controller: _nameController,
              errorText: _nameError,
              onChanged: (_) {
                if (_nameError != null) setState(() => _nameError = null);
              },
            ),
            const SizedBox(height: 16),

            // Email
            CustomTextField(
              label: 'Email (Optional)',
              hintText: 'Enter your email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
              onChanged: (_) {
                if (_emailError != null) setState(() => _emailError = null);
              },
            ),
            const SizedBox(height: 24),

            // Terms & Conditions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _termsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                        _termsError = null;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.termsConditions);
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'I agree to the ',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_termsError != null) ...[
              const SizedBox(height: 8),
              Text(
                _termsError!,
                style: const TextStyle(
                  color: AppColors.danger,
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 32),

            CustomButton(
              text: 'Sign Up',
              onPressed: _handleSignup,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
