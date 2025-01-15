import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class WaterIntakeProvider with ChangeNotifier {
  int _currentWaterIntake = 0;
  final int _dailyWaterGoal = 2000;

  int get currentWaterIntake => _currentWaterIntake;
  int get dailyWaterGoal => _dailyWaterGoal;

  WaterIntakeProvider() {
    _initializeWaterIntake();
  }

  Future<void> _initializeWaterIntake() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        String userId = user.uid;
        String todayDate = DateTime.now()
            .toIso8601String()
            .split('T')[0]; // Format: YYYY-MM-DD

        DatabaseReference waterIntakeRef = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userId)
            .child('waterIntake')
            .child(todayDate);

        // Get current water intake for the day
        DatabaseEvent event = await waterIntakeRef.once();
        _currentWaterIntake = (event.snapshot.value as int?) ?? 0;

        notifyListeners();
      } catch (e) {
        print("Error initializing water intake: $e");
      }
    }
  }

  Future<void> incrementSubGoalProgress(int intakeAmount) async {
    // Check if the intake amount is 200ml, as you only want to increment for 200ml
    if (intakeAmount == 200 || intakeAmount == 500) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          String userUid = user.uid;

          // Reference to the 'subGoals' node in Firebase
          DatabaseReference subGoalsRef = FirebaseDatabase.instance
              .ref()
              .child('users')
              .child(userUid)
              .child('subGoals');

          // Get current subgoal data
          DatabaseEvent subGoalsEvent = await subGoalsRef.once();
          if (subGoalsEvent.snapshot.exists) {
            Map<Object?, Object?>? subGoalsData =
                subGoalsEvent.snapshot.value as Map<Object?, Object?>?;

            // Iterate through each subgoal and update its progress
            subGoalsData?.forEach((goalName, goalData) async {
              if (goalData is Map<Object?, Object?>) {
                // Cast goalName to String safely
                String goalNameStr = goalName as String;

                // Safely convert progress to a double
                double currentProgress =
                    (goalData['progress'] as num?)?.toDouble() ?? 0.0;
                if (intakeAmount == 200) {
                  double updatedProgress =
                      currentProgress + 0.004; // Increment by 0.02
                  await subGoalsRef.child(goalNameStr).update({
                    'progress': updatedProgress,
                  });
                  print('Updated progress for $goalNameStr: $updatedProgress');
                } else {
                  double updatedProgress =
                      currentProgress + 0.01; // Increment by 0.02
                  // Update the progress for this subgoal in Firebase
                  await subGoalsRef.child(goalNameStr).update({
                    'progress': updatedProgress,
                  });
                  print('Updated progress for $goalNameStr: $updatedProgress');
                }
              }
            });
          }
        } catch (e) {
          print('Error updating progress for subgoals: $e');
        }
      }
    }
  }

  Future<void> addWaterIntake(int intakeAmount) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        String userId = user.uid;
        String todayDate = DateTime.now()
            .toIso8601String()
            .split('T')[0]; // Format: YYYY-MM-DD

        DatabaseReference waterIntakeRef = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userId)
            .child('waterIntake')
            .child(todayDate);

        // Get current water intake for the day
        DatabaseEvent event = await waterIntakeRef.once();
        int currentIntake = (event.snapshot.value as int?) ?? 0;

        // Update water intake
        _currentWaterIntake = currentIntake + intakeAmount;

        // Ensure it doesn't exceed the daily goal
        if (_currentWaterIntake > _dailyWaterGoal) {
          _currentWaterIntake = _dailyWaterGoal;
        }

        await waterIntakeRef.set(_currentWaterIntake);
        await incrementSubGoalProgress(intakeAmount);
        notifyListeners();
      } catch (e) {
        print("Error updating water intake: $e");
      }
    }
  }
}
