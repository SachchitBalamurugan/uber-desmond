import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> markCompleted(int caloriesBurned, int minutesWorkedOut) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('complete')
        .add({
      'completed': true,
      'timestamp': FieldValue.serverTimestamp(),
      'caloriesBurned': caloriesBurned,
      'minutesWorkedOut': minutesWorkedOut,
    });
  }

  Future<void> saveWorkoutSchedule(
      String workoutName, DateTime combinedDateTime) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('workouts')
        .add({
      'workout': workoutName,
      'date': combinedDateTime.toIso8601String(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
