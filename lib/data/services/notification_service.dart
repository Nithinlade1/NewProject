import '../models/notification_model.dart';

abstract class NotificationService {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
}

class MockNotificationService implements NotificationService {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      type: NotificationType.activeInterest,
      title: 'New Active Interest',
      description: 'Eshwar from Sarangi has shown active interest',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    NotificationModel(
      id: '2',
      type: NotificationType.addedToHouse,
      title: 'Added to KutCom',
      description: 'You have been added to Mekhala community',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationModel(
      id: '3',
      type: NotificationType.interestWithdrawn,
      title: 'Interest Withdrawn',
      description: 'Ravi Kumar has withdrawn interest from Sarangi',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
    ),
    NotificationModel(
      id: '4',
      type: NotificationType.message,
      title: 'New Message',
      description: 'You have a new message from Lakshmi Nagar',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    NotificationModel(
      id: '5',
      type: NotificationType.addedToHTuds,
      title: 'Added to HTuds',
      description: "You have been added to Meena's HTuds",
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: '6',
      type: NotificationType.serviceDelivered,
      title: 'Service Delivered',
      description: 'Service has been delivered to Priya Homes',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_notifications);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }
}
