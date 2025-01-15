import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
        title: "Hey, it’s time for lunch",
        time: "About 1 minutes ago",
        icon: Icons.lunch_dining),
    NotificationItem(
        title: "Don’t miss your lowerbody workout",
        time: "About 3 hours ago",
        icon: Icons.directions_run),
    NotificationItem(
        title: "Hey, let’s add some meals for your b...",
        time: "About 3 hours ago",
        icon: Icons.breakfast_dining),
    NotificationItem(
        title: "Congratulations, You have finished A...",
        time: "29 May",
        icon: Icons.check_circle_outline),
    NotificationItem(
        title: "Hey, it’s time for lunch",
        time: "8 April",
        icon: Icons.lunch_dining),
    NotificationItem(
        title: "Ups, You have missed your Lowerbo...",
        time: "3 April",
        icon: Icons.directions_run),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
        ),
        title: Text(
          "Notification",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: Icon(notification.icon, color: Colors.black),
            ),
            title: Text(notification.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
            subtitle: Text(notification.time),
            trailing: Icon(Icons.more_vert),
          );
        },
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String time;
  final IconData icon;

  NotificationItem({required this.title, required this.time, required this.icon});
}
