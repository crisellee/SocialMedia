import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Sample data para sa notifications
  List<Map<String, dynamic>> notifications = [
    {
      "id": 1,
      "title": "New Reel Like",
      "body": "Someone liked your recent reel.",
      "time": "2m ago",
      "isRead": false
    },
    {
      "id": 2,
      "title": "New Message",
      "body": "May bagong message ka mula sa iyong kaibigan.",
      "time": "15m ago",
      "isRead": false
    },
    {
      "id": 3,
      "title": "System Update",
      "body": "Tapos na ang maintenance ng server.",
      "time": "1h ago",
      "isRead": true
    },
  ];

  void markAllAsRead() {
    setState(() {
      for (var item in notifications) {
        item['isRead'] = true;
      }
    });
  }

  void removeNotification(int index) {
    setState(() {
      notifications.removeAt(index);
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
      body: notifications.isEmpty
          ? const Center(child: Text("Walang notifications dito."))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Dismissible(
            key: Key(item['id'].toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              removeNotification(index);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Notification deleted")),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item['isRead'] ? Colors.grey[300] : Colors.blue[100],
                child: Icon(
                  Icons.notifications,
                  color: item['isRead'] ? Colors.grey : Colors.blue,
                ),
              ),
              title: Text(
                item['title'],
                style: TextStyle(
                  fontWeight: item['isRead'] ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Text("${item['body']}\n${item['time']}"),
              isThreeLine: true,
              onTap: () {
                setState(() {
                  item['isRead'] = true;
                });
              },
            ),
          );
        },
      ),
    );
  }
}