import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/notification_model.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  IconData get _icon {
    switch (notification.type) {
      case NotificationType.activeInterest:
        return Icons.pan_tool_alt;
      case NotificationType.passiveInterest:
        return Icons.visibility;
      case NotificationType.interestWithdrawn:
        return Icons.remove_circle_outline;
      case NotificationType.interestSwitched:
        return Icons.swap_horiz;
      case NotificationType.addedToHTuds:
        return Icons.link;
      case NotificationType.addedToHouse:
        return Icons.home_outlined;
      case NotificationType.removedFromHouse:
        return Icons.home_outlined;
      case NotificationType.message:
        return Icons.chat_bubble_outline;
      case NotificationType.serviceDelivered:
        return Icons.check_circle_outline;
      case NotificationType.serviceUnable:
        return Icons.cancel_outlined;
      case NotificationType.customerUnavailable:
        return Icons.person_off_outlined;
      case NotificationType.general:
        return Icons.notifications_outlined;
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case NotificationType.activeInterest:
        return AppColors.activeInterest;
      case NotificationType.passiveInterest:
        return AppColors.passiveInterest;
      case NotificationType.interestWithdrawn:
      case NotificationType.serviceUnable:
      case NotificationType.customerUnavailable:
        return AppColors.danger;
      case NotificationType.addedToHTuds:
      case NotificationType.addedToHouse:
      case NotificationType.serviceDelivered:
        return AppColors.success;
      case NotificationType.removedFromHouse:
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: notification.isRead ? null : AppColors.primaryLight.withValues(alpha: 0.3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(_icon, size: 20, color: _iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          notification.isRead ? FontWeight.w500 : FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.timeAgo,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
