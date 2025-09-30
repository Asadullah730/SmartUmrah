import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Sample notifications data
  final List<Map<String, String>> notifications = const [
    {
      "title": "New Update Available",
      "body": "Version 2.0 is now available. Update to enjoy new features.",
      "time": "5 min ago",
    },
    {
      "title": "Reminder",
      "body": "Don't forget to complete your profile setup.",
      "time": "1 hour ago",
    },
    {
      "title": "Promo",
      "body": "Get 20% off on your next subscription!",
      "time": "Yesterday",
    },
    {
      "title": "Maintenance Notice",
      "body": "Server maintenance scheduled at 12:00 AM.",
      "time": "2 days ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 4,
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Add functionality to mark all as read if needed
            },
            icon: const Icon(Icons.mark_email_read),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: const Icon(Icons.notifications, color: Colors.teal),
              ),
              title: Text(
                notification['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                notification['body']!,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              trailing: Text(
                notification['time']!,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              onTap: () {
                // Action when notification is tapped
              },
            ),
          );
        },
      ),
    );
  }
}
