import 'package:flutter/material.dart';
import '../models/post.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  // Ginawa nating static para ma-access sa main.dart
  static List<Map<String, dynamic>> notifications = [
    {
      "id": 1,
      "title": "New Reel Like",
      "body": "Someone liked your recent reel.",
      "time": "2m ago",
      "isRead": false
    },
  ];

  static void addPostNotification(PostData post) {
    notifications.insert(0, {
      "id": DateTime.now().millisecondsSinceEpoch,
      "title": "New Post Uploaded",
      "body": "You successfully posted: ${post.caption}",
      "time": "Just now",
      "isRead": false
    });
  }

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  void markAllAsRead() {
    setState(() {
      for (var item in NotificationScreen.notifications) {
        item['isRead'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: markAllAsRead,
            child: const Text("Mark all as read", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: NotificationScreen.notifications.isEmpty
          ? const Center(child: Text("Walang notifications dito."))
          : ListView.builder(
              itemCount: NotificationScreen.notifications.length,
              itemBuilder: (context, index) {
                final item = NotificationScreen.notifications[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.post_add, color: Colors.blue),
                  ),
                  title: Text(
                    item['title'],
                    style: TextStyle(
                      fontWeight: item['isRead'] ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text("${item['body']}\n${item['time']}"),
                  isThreeLine: true,
                );
              },
            ),
    );
  }
}
