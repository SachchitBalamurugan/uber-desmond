import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:healthapp/utils/helpers/helper_functions.dart';
import 'package:intl/intl.dart';

class WorkoutDataProvider extends ChangeNotifier {
  final Map<String, List<dynamic>> _workoutData = {}; // Store workouts by day of the week
  List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  bool _isLoading = false;

  Map<String, List<dynamic>> get workoutData => _workoutData;
  bool get isLoading => _isLoading;

  Future<void> fetchWorkoutData(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final userUid = FirebaseAuth.instance.currentUser?.uid;

    if (userUid == null) {
      THelperFunctions.showSnackBar("User not logged in.", context);
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final dbRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userUid)
          .child('completedWorkouts');

      final snapshot = await dbRef.get();

      if (snapshot.exists && snapshot.value is Map<dynamic, dynamic>) {
        _workoutData.clear();
        final now = DateTime.now();
        final data = snapshot.value as Map<dynamic, dynamic>;

        // Iterate over the past 7 days
        for (int i = 0; i < 7; i++) {
          final day = now.subtract(Duration(days: i));
          final formattedDate = DateFormat('dd MM yyyy').format(day); // e.g., "08 01 2025"
          final dayOfWeek = DateFormat('EEEE').format(day); // e.g., "Monday"

          // Initialize the list for this day of the week
          _workoutData.putIfAbsent(dayOfWeek, () => []);

          // Match Firebase data by date
          if (data.containsKey(formattedDate)) {
            final workoutsForDate = data[formattedDate];
            if (workoutsForDate is Map<dynamic, dynamic>) {
              // Add all workout keys or details to the list
              _workoutData[dayOfWeek] = workoutsForDate.values.toList();
            } else {
              // Add a placeholder if the data structure is invalid
              _workoutData[dayOfWeek] = ["Invalid workout data"];
            }
          } else {
            // Add an empty list if there are no workouts for this date
            _workoutData[dayOfWeek] = [];
          }
        }

        // Debugging: Print collected data for each day
        for (var entry in _workoutData.entries) {
          days= [];
          days.add(entry.key);
          notifyListeners();
          debugPrint("Day: ${entry.key}, Workouts: ${entry.value}");
        }

        // THelperFunctions.showSnackBar("Workout data fetched successfully!", context);
      } else {
        // THelperFunctions.showSnackBar("No workout data found.", context);
      }
    } catch (e) {
      // THelperFunctions.showSnackBar("Error fetching data: $e", context);
      debugPrint("Error fetching workout data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
