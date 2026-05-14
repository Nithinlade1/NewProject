import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_dialog.dart';
import 'widgets/otp_input_field.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _timerSeconds = AppConstants.otpTimerSeconds;
  Timer? _timer;
  String? _errorText;
  bool _isLoading = false;
  String _phone = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        setState(() => _phone = args);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _timerSeconds = AppConstants.otpTimerSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  String get _otpValue => _controllers.map((c) => c.text).join();

  Future<void> _verifyOTP() async {
    final otp = _otpValue;

    if (otp.isEmpty) {
      setState(() => _errorText = AppStrings.otpEmptyError);
      return;
    }
    if (otp.length != 4) {
      setState(() => _errorText = AppStrings.otpInvalidError);
      return;
    }
    if (_timerSeconds == 0) {
      setState(() => _errorText = AppStrings.otpExpiredError);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomDialog(
        title: AppStrings.otpVerified,
        message: AppStrings.otpVerifiedMessage,
        icon: Icons.check_circle,
        iconColor: AppColors.success,
        confirmText: AppStrings.continueText,
        onConfirm: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(AppRoutes.signup,
              arguments: _phone);
        },
      ),
    );
  }

  void _resendOTP() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    setState(() => _errorText = null);
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.lock_outline, size: 40,
                    color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.otpTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the OTP sent to +91 $_phone',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              OTPInputField(
                controllers: _controllers,
                focusNodes: _focusNodes,
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorText!,
                  style: const TextStyle(
                    color: AppColors.danger,
                    fontSize: 13,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (_timerSeconds > 0)
                RichText(
                  text: TextSpan(
                    text: 'OTP valid for ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: '${_timerSeconds}s',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                TextButton(
                  onPressed: _resendOTP,
                  child: const Text(
                    AppStrings.resendOTP,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              const Spacer(),
              CustomButton(
                text: AppStrings.verifyOTP,
                onPressed: _verifyOTP,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
