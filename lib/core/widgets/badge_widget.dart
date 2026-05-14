import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BadgeWidget extends StatelessWidget {
  final int count;
  final Color? color;
  final double fontSize;

  const BadgeWidget({
    super.key,
    required this.count,
    this.color,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color ?? AppColors.danger,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(minWidth: 18),
      child: Text(
        count > 99 ? '99+' : '$count',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class InterestBadge extends StatelessWidget {
  final int activeCount;
  final int passiveCount;

  const InterestBadge({
    super.key,
    required this.activeCount,
    required this.passiveCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildBadge(
          icon: Icons.pan_tool_alt,
          count: activeCount,
          color: AppColors.activeInterest,
          label: 'Active',
        ),
        const SizedBox(width: 12),
        _buildBadge(
          icon: Icons.visibility,
          count: passiveCount,
          color: AppColors.passiveInterest,
          label: 'Passive',
        ),
      ],
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required int count,
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
