import 'package:flutter/material.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_dialog.dart';

class TudNumberScreen extends StatefulWidget {
  const TudNumberScreen({super.key});

  @override
  State<TudNumberScreen> createState() => _TudNumberScreenState();
}

class _TudNumberScreenState extends State<TudNumberScreen> {
  String _phone = '9876543210';
  int? _selectedEmptyBox;
  String _insertedDigit = '';
  bool _isLoading = false;

  // 20 boxes: alternating empty and filled
  // Positions: 0(empty), 1(phone[0]), 2(empty), 3(phone[1]), ...
  // So empty boxes are at even indices (0,2,4,...,18)
  // Filled boxes are at odd indices (1,3,5,...,19)

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.length == 10) {
      _phone = args;
    }
  }

  List<_TudBox> get _boxes {
    final boxes = <_TudBox>[];
    for (int i = 0; i < AppConstants.tudNumberTotalBoxes; i++) {
      if (i.isOdd) {
        // Phone digit
        final phoneIndex = i ~/ 2;
        boxes.add(_TudBox(
          index: i,
          type: _BoxType.filled,
          digit: _phone[phoneIndex],
        ));
      } else {
        // Empty slot
        final isSelected = _selectedEmptyBox == i;
        boxes.add(_TudBox(
          index: i,
          type: _BoxType.empty,
          digit: isSelected ? _insertedDigit : '',
          isSelected: isSelected,
        ));
      }
    }
    return boxes;
  }

  String get _generatedTudNumber {
    if (_selectedEmptyBox == null || _insertedDigit.isEmpty) return '';
    final sb = StringBuffer();
    for (final box in _boxes) {
      if (box.digit.isNotEmpty) sb.write(box.digit);
    }
    return sb.toString();
  }

  bool get _isValid =>
      _selectedEmptyBox != null &&
      _insertedDigit.isNotEmpty &&
      _generatedTudNumber.length == AppConstants.tudNumberDigits;

  void _onBoxTap(int index) {
    if (_insertedDigit.isNotEmpty && _selectedEmptyBox != null && _selectedEmptyBox != index) {
      return; // Already filled one box
    }
    setState(() {
      _selectedEmptyBox = index;
      _insertedDigit = '';
    });
    _showDigitPicker(index);
  }

  void _showDigitPicker(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select a digit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(10, (digit) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _selectedEmptyBox = index;
                      _insertedDigit = '$digit';
                    });
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Center(
                      child: Text(
                        '$digit',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _handleNext() async {
    if (!_isValid) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() => _isLoading = false);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomDialog(
          title: 'TUD Number Created!',
          message: 'Your TUD Number is: $_generatedTudNumber',
          icon: Icons.check_circle,
          iconColor: AppColors.success,
          confirmText: AppStrings.next,
          onConfirm: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed(AppRoutes.landing);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(AppStrings.createTudNumber),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.tudNumberInstruction,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Wrap(
                spacing: 6,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _boxes.map((box) {
                  if (box.type == _BoxType.filled) {
                    return _buildFilledBox(box.digit);
                  } else {
                    return _buildEmptyBox(box);
                  }
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            if (_generatedTudNumber.isNotEmpty) ...[
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Your TUD Number',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _generatedTudNumber,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_selectedEmptyBox != null && _insertedDigit.isNotEmpty)
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedEmptyBox = null;
                      _insertedDigit = '';
                    });
                  },
                  child: const Text('Clear selection'),
                ),
              ),
            const Spacer(),
            CustomButton(
              text: AppStrings.next,
              onPressed: _isValid ? _handleNext : null,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilledBox(String digit) {
    return Container(
      width: 36,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        border: Border.all(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          digit,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyBox(_TudBox box) {
    final bool hasDigit = box.isSelected && _insertedDigit.isNotEmpty;
    final bool canTap = _selectedEmptyBox == null || box.isSelected;

    return GestureDetector(
      onTap: canTap ? () => _onBoxTap(box.index) : null,
      child: Container(
        width: 36,
        height: 42,
        decoration: BoxDecoration(
          color: hasDigit ? AppColors.primaryLight : null,
          border: Border.all(
            color: box.isSelected ? AppColors.primary : AppColors.border,
            width: box.isSelected ? 2 : 1.5,
            style: hasDigit ? BorderStyle.solid : BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: CustomPaint(
          painter: hasDigit ? null : _DashedBorderPainter(
            color: canTap ? AppColors.primary : AppColors.border,
            radius: 6,
          ),
          child: Center(
            child: hasDigit
                ? Text(
                    _insertedDigit,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  )
                : Icon(
                    Icons.add,
                    size: 16,
                    color: canTap
                        ? AppColors.primary
                        : AppColors.border,
                  ),
          ),
        ),
      ),
    );
  }
}

enum _BoxType { filled, empty }

class _TudBox {
  final int index;
  final _BoxType type;
  final String digit;
  final bool isSelected;

  _TudBox({
    required this.index,
    required this.type,
    required this.digit,
    this.isSelected = false,
  });
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    const dashWidth = 5.0;
    const dashSpace = 3.0;

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(
          metric.extractPath(distance, end),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
