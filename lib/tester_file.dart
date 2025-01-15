import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthapp/utils/helpers/helper_functions.dart';
import 'package:healthapp/utils/helpers/notifications.dart';

class NotificationTester extends StatefulWidget {
  const NotificationTester({super.key});

  @override
  State<NotificationTester> createState() => _NotificationTesterState();
}

class _NotificationTesterState extends State<NotificationTester> {
  @override
  initState() {
    super.initState();

    onNotificationTapListener();
  }

  void onNotificationTapListener() {
    NotificationHelper.notificationResponseController.stream
        .listen((notificationResponse) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NotificationPage()));
    });
  }

  Future<void> _scheduleNotification() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 300),
      initialDate: DateTime.now(),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime scheduledDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        int secondsUntilNotification =
            scheduledDateTime.difference(DateTime.now()).inSeconds;

        if (secondsUntilNotification > 0) {
          NotificationHelper.showScheduleNotification(
            delay: Duration(seconds: secondsUntilNotification),
            id: Random().nextInt(4294967),
            title: "Scheduled Notification",
            body: "This is a scheduled notification",
            payload: "payload",
          );
          THelperFunctions.showSnackBar(

               "Notification set for $scheduledDateTime",context);
        } else {
          THelperFunctions.showSnackBar(


              "The selected time is in the past. Please choose a future time.",context);
        }
      } else {
        THelperFunctions.showSnackBar("No time selected.",context);
      }
    } else {
      THelperFunctions.showSnackBar("No date selected.",context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text(
          'Notification Center',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header Card
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text(
                        "Manage Notifications",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "You can create, schedule, and manage notifications right here.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Notification buttons
              NotificationButton(
                label: "Basic Notification",
                onPressed: () {
                  NotificationHelper.showBasicNotification(
                    id: Random().nextInt(909890),
                    title: "Basic Notification",
                    body: "This is a basic notification",
                    payload: "payload",
                  );
                  THelperFunctions.showSnackBar(
                         "Basic notification shown",context);
                },
              ),
              NotificationButton(
                label: "Repeating Notification",
                onPressed: () {
                  NotificationHelper.showRepeatingNotification(
                      id: Random().nextInt(909890),
                      title: "Repeating Notification",
                      body: "This is a repeating notification",
                      payload: "payload",
                      repeatInterval: RepeatInterval.everyMinute, );

                },
              ),
              NotificationButton(
                label: "Schedule Notification",
                onPressed:()=> _scheduleNotification,
              ),
              NotificationButton(
                label: "Remove Notifications",
                onPressed: () {
                  NotificationHelper.cancelAllNotifications();
                  THelperFunctions.showSnackBar(
                      "All notifications canceled",context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// notification_button.dart

class NotificationButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const NotificationButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Page'),
      ),
      body: const Center(
        child: Text('Notification Page'),
      ),
    );
  }
}
// header_card.dart


