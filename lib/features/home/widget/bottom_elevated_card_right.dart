// sleep_repository.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SleepRepository {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  Stream<String> getSleepHours() {
    if (_userId == null) return Stream.value('0h 0m');

    return _database
        .child('users')
        .child(_userId)
        .child('dailyAlarms')
        .child('dailyAlarm')
        .child('sleepHours')
        .onValue
        .map((event) {
      if (event.snapshot.value == null) return '0h 0m';

      // Convert minutes to hours and minutes format
      // int totalMinutes = (event.snapshot.value as num).toInt();
      // int hours = totalMinutes ~/ 60;
      // int minutes = totalMinutes % 60;
      return "${event.snapshot.value}";
    });
  }
}

// bottom_elevated_card_right.dart

class BottomElevatedCardRight extends StatelessWidget {
  final SleepRepository sleepRepository;

  const BottomElevatedCardRight({
    super.key,
    required this.sleepRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sleep',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          StreamBuilder<String>(
            stream: sleepRepository.getSleepHours(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8EB1BB)),
                );
              }

              if (snapshot.hasError) {
                return Text(
                  'Error',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Colors.red,
                  ),
                );
              }

              return ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Color(0xFF8EB1BB), Color(0xFFB7D5DE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  snapshot.data ?? '0h 0m',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 16),
          Image.asset(
            'assets/Sleep-Graph.png',
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
