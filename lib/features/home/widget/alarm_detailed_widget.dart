import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/helpers/notifications.dart';
import '../../sleep_tracking/widgets/alarm_detailed_card.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmDetailedWidget extends StatelessWidget {
  final String time; // Bedtime string, e.g., "09:00 PM"
  final String timeLeft; // Sleep duration, e.g., "8 Hours 30 Minutes"

  const AlarmDetailedWidget({super.key, required this.time, required this.timeLeft});

  String calculateAlarmTime() {
    final bedtimeFormat = DateFormat("hh:mm a");
    final bedtimeDateTime = bedtimeFormat.parse(time);

    final durationParts = timeLeft.split(" ");
    final hours = int.parse(durationParts[0]);
    final minutes = durationParts.length > 2 ? int.parse(durationParts[2]) : 0;

    final alarmDateTime = bedtimeDateTime.add(Duration(hours: hours, minutes: minutes));
    return bedtimeFormat.format(alarmDateTime);
  }



  String calculateTimeLeftToAlarmTime() {
    final bedtimeFormat = DateFormat("hh:mm a");
    final bedtimeDateTime = bedtimeFormat.parse(time);

    final durationParts = timeLeft.split(" ");
    final hours = int.parse(durationParts[0]);
    final minutes = durationParts.length > 2 ? int.parse(durationParts[2]) : 0;

    final alarmDateTime = bedtimeDateTime.add(Duration(hours: hours, minutes: minutes));

    final now = DateTime.now();
    final alarmToday = DateTime(
      now.year,
      now.month,
      now.day,
      alarmDateTime.hour,
      alarmDateTime.minute,
    );

    final difference = alarmToday.difference(now);

    if (difference.isNegative) {
      // If the alarm is the next day
      final alarmTomorrow = alarmToday.add(Duration(days: 1));
      return _formatDuration(alarmTomorrow.difference(now));
    }

    return _formatDuration(difference);
  }


  Widget _buildDataCard({
    required IconData icon,
    required Color iconColor,
    required String time,
    required String timeLeft,
    required String title,
  }) {
    return DetailedAlarmCard(
      icon: icon,
      title: title,
      time: time,
      timeLeft: timeLeft,
      iconColor: iconColor,
    );
  }
  String calculateTimeLeftToBedtime(BuildContext context) {
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
  @override
  Widget build(BuildContext context) {

    final alarmTime = calculateAlarmTime();
    final timeLeftToBedtime = calculateTimeLeftToBedtime(context);
    final timeLeftToAlarm = calculateTimeLeftToAlarmTime();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bedtime Card with Icon
        _buildDataCard(
          icon: Icons.bed,
          iconColor: Colors.purple,
          time: time,
          timeLeft: timeLeftToBedtime,
          title: 'Bedtime',
        ),
        SizedBox(height: 16),
        // Alarm Card with Icon
        _buildDataCard(
          title: "Alarm",
          icon: Icons.alarm,
          iconColor: Colors.red,
          time: alarmTime,
          timeLeft: timeLeftToAlarm,
        ),
      ],
    );
  }
}
