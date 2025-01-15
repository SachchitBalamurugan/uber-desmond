import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class BadgeRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Get current user's UID
  String? getCurrentUserUid() {
    return _auth.currentUser?.uid;
  }

  // Stream for daily steps
  Stream<int> streamDailySteps() {
    String? userUid = getCurrentUserUid();
    if (userUid == null) {
      return Stream.value(0); // Default value if no user is signed in
    }

    final today = DateTime.now().toIso8601String().split('T')[0];
    final ref = _database.ref("users/$userUid/daily_steps/$today/steps");

    return ref.onValue.map((event) {
      final value = event.snapshot.value;
      return value != null ? (value as int) : 0;
    });
  }

  // Stream for water intake
  Stream<int> streamWaterIntake() {
    String? userUid = getCurrentUserUid();
    if (userUid == null) {
      return Stream.value(0);
    }

    final today = DateTime.now().toIso8601String().split('T')[0];
    final ref = _database.ref("users/$userUid/waterIntake/$today");

    return ref.onValue.map((event) {
      final value = event.snapshot.value;
      return value != null ? (value as int) : 0;
    });
  }

  // Stream for completed workouts
  Stream<List<String>> streamCompletedWorkouts() {
    String? userUid = getCurrentUserUid();
    if (userUid == null) {
      return Stream.value([]);
    }

    final today = DateTime.now().toIso8601String().split('T')[0];
    final ref = _database.ref("users/$userUid/completedWorkouts/$today");

    return ref.onValue.map((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        return data.keys.map((key) => key.toString()).toList();
      }
      return [];
    });
  }
}
