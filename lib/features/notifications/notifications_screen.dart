import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/notification_model.dart';
import '../../data/services/notification_service.dart';
import 'widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _service = MockNotificationService();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    final data = await _service.getNotifications();
    setState(() {
      _notifications = data;
      _isLoading = false;
    });
  }

  Future<void> _markAllRead() async {
    await _service.markAllAsRead();
    setState(() {
      _notifications =
          _notifications.map((n) => n.copyWith(isRead: true)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text('Notifications'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Mark all read',
                style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.9)),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Loading notifications...');
    }

    if (_notifications.isEmpty) {
      return const EmptyStateWidget(
        message: AppStrings.noNotifications,
        icon: Icons.notifications_off_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _notifications.length,
        separatorBuilder: (_, i) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return NotificationItem(
            notification: _notifications[index],
            onTap: () async {
              await _service.markAsRead(_notifications[index].id);
              setState(() {
                _notifications[index] =
                    _notifications[index].copyWith(isRead: true);
              });
            },
          );
        },
      ),
    );
  }
}
