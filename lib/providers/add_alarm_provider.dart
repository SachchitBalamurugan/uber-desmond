import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../utils/helpers/helper_functions.dart';
import '../utils/helpers/notifications.dart';

class AddAlarmProvider extends ChangeNotifier {
  String selectedBedtime = "09:00 PM";
  String selectedSleepHours = "8 Hours 30 Minutes";
  List<String> selectedDays = ["Mon", "Tue"];
  bool vibrate = true;
  bool loading = false;

  final List<String> bedtimes = [
    "09:00 PM",
    "10:00 PM",
    "11:00 PM",
    "12:00 AM",
    "01:00 AM"
  ];
  final List<String> sleepHours = [
    "6 Hours",
    "7 Hours",
    "8 Hours",
    "8 Hours 30 Minutes",
    "9 Hours",
    "10 Hours"
  ];
  final List<String> weekdays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  void setBedtime(String bedtime) {
    selectedBedtime = bedtime;
    notifyListeners();
  }

  void setSleepHours(String hours) {
    selectedSleepHours = hours;
    notifyListeners();
  }

  void setRepeatDays(List<String> days) {
    selectedDays = days;
    notifyListeners();
  }

  void toggleVibrate(bool value) {
    vibrate = value;
    notifyListeners();
  }
  String calculateTimeLeftToBedtime(time) {
    final bedtimeFormat = DateFormat("hh:mm a");
    final bedtimeDateTime = bedtimeFormat.parse(time);

    final now = DateTime.now();
    final bedtimeToday = DateTime(
      now.year,
      now.month,
      now.day,
      bedtimeDateTime.hour,
      bedtimeDateTime.minute,
    );

    final difference = bedtimeToday.difference(now);
    return difference.isNegative
        ? _formatDuration(bedtimeToday.add(Duration(days: 1)).difference(now))
        : _formatDuration(difference);
  }
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return "${hours.abs()} Hours ${minutes.abs()} Minutes";
  }
  Future<void> saveAlarmToFirebase(BuildContext context) async {
    loading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final alarmData = {
        "bedtime": selectedBedtime,
        "sleepHours": selectedSleepHours,
        "repeatDays": selectedDays,
        "vibrate": vibrate,
        "lastUpdated": DateTime.now().toIso8601String(),
      };

      // Reference the Realtime Database path: users/{userUid}/dailyAlarms/dailyAlarm
      final databaseRef = FirebaseDatabase.instance.ref();
      await databaseRef
          .child("users")
          .child(user.uid)
          .child("dailyAlarms")
          .child(
              "dailyAlarm") // Use a fixed key to ensure only one alarm is saved
          .set(alarmData);
      await NotificationHelper.showBasicNotification(title: "Bedtime Scheduled", body: "${calculateTimeLeftToBedtime(selectedBedtime)} hours left for bedtime");

      await NotificationHelper.showRepeatingNotification(
          id: Random().nextInt(4294967),
          title: "Repeating Notification",
          body: "This is a repeating notification",
          payload: "payload",
          repeatInterval: RepeatInterval.everyMinute, );
      THelperFunctions.showSnackBar(
          "Repeating notification set",context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alarm saved successfully!")),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving alarm: $e")),
      );
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Stream function to fetch alarm data
  Stream<Map<String, dynamic>?> fetchAlarm() {


    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final databaseRef = FirebaseDatabase.instance.ref();
    return databaseRef
        .child("users")
        .child(user.uid)
        .child("dailyAlarms")
        .child("dailyAlarm")
        .onValue
        .map((event) {
      if (event.snapshot.value != null) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      return null;
    });
  }

}
