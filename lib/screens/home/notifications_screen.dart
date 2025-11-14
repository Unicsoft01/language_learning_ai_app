import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  // Dummy notifications – later you can load these from backend/local DB.
  List<_NotificationItem> _buildDummyNotifications() {
    return const [
      _NotificationItem(
        type: _NotificationType.reminder,
        title: 'Time to practise',
        subtitle: 'Your daily 15-minute goal is waiting.',
        timestamp: 'Just now',
      ),
      _NotificationItem(
        type: _NotificationType.achievement,
        title: '3-day streak! 🔥',
        subtitle: 'Great consistency. Keep it going!',
        timestamp: '2 hours ago',
      ),
      _NotificationItem(
        type: _NotificationType.tip,
        title: 'Try a listening exercise',
        subtitle: 'Short conversations can boost your comprehension.',
        timestamp: 'Yesterday',
      ),
      _NotificationItem(
        type: _NotificationType.reminder,
        title: 'Evening study slot',
        subtitle: 'A quick 5-minute session fits your schedule.',
        timestamp: '2 days ago',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifications = _buildDummyNotifications();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: notifications.isEmpty
            ? const _EmptyNotificationsView()
            : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return _NotificationCard(item: item);
                },
              ),
      ),
    );
  }
}

enum _NotificationType { reminder, achievement, tip }

class _NotificationItem {
  final _NotificationType type;
  final String title;
  final String subtitle;
  final String timestamp;

  const _NotificationItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });
}

class _NotificationCard extends StatelessWidget {
  final _NotificationItem item;

  const _NotificationCard({required this.item});

  IconData _iconForType() {
    switch (item.type) {
      case _NotificationType.reminder:
        return Icons.notifications_active_outlined;
      case _NotificationType.achievement:
        return Icons.emoji_events_outlined;
      case _NotificationType.tip:
        return Icons.lightbulb_outline;
    }
  }

  Color _colorForType(ColorScheme colorScheme) {
    switch (item.type) {
      case _NotificationType.reminder:
        return colorScheme.primary;
      case _NotificationType.achievement:
        return colorScheme.secondary;
      case _NotificationType.tip:
        return colorScheme.tertiary ?? colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: _colorForType(colorScheme).withOpacity(0.08),
              child: Icon(_iconForType(), color: _colorForType(colorScheme)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.timestamp,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyNotificationsView extends StatelessWidget {
  const _EmptyNotificationsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_outlined,
              size: 64,
              color: colorScheme.primary.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You’ll see reminders, streaks, and tips here once you start practising.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
