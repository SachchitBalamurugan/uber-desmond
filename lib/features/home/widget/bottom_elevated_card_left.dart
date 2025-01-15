// calorie_repository.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../sleep_tracker.dart';
import 'package:flutter/material.dart';
class CalorieRepository {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Stream<int> getCaloriesStream( String currentDate) {
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    if(userUid == null) throw 0;
    return _database
        .child('users')
        .child(userUid)
        .child('daily_steps')
        .child(currentDate)
        .child('calories')
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      return value != null ? int.parse(value.toString()) : 0;
    });
  }
}

// bottom_calorie_card.dart



class BottomCalorieCard extends StatelessWidget {

  static const int maxCalories = 500;

  const BottomCalorieCard({
    super.key,

  });

  String getCurrentDate() {

    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final calorieRepository = CalorieRepository();

    return StreamBuilder<int>(
      stream: calorieRepository.getCaloriesStream( getCurrentDate()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final calories = snapshot.data ?? 0;
        final progress = (calories / maxCalories).clamp(0.0, 1.0);

        return Container(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 4,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Calories',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF8EB1BB), Color(0xFFB7D5DE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  '$calories kCal',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF8EB1BB), Color(0xFFB7D5DE)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    CustomPaint(
                      size: const Size(120, 120),
                      painter: GradientCircularProgressPainter(
                        progress: progress,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8EB1BB), Color(0xFFB4C0FE)],
                        ),
                      ),
                    ),
                    Text(
                      '${maxCalories - calories} Left',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}