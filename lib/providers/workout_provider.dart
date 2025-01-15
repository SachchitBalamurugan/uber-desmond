import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/services/workout_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:healthapp/utils/helpers/helper_functions.dart';
import 'package:intl/intl.dart';

class WorkoutViewModel with ChangeNotifier {
  final WorkoutService _workoutService = WorkoutService();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Map<String, List<Map<String, dynamic>>> _workoutSchedules = {};

  Map<String, List<Map<String, dynamic>>> get workoutSchedules =>
      _workoutSchedules;

  bool _isLoading = false;
  bool _isCompleting = false;
  bool get isCompleting => _isCompleting;
  bool get isLoading => _isLoading;

  Future<void> fetchWorkouts() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    try {
      _isLoading = true;
      final snapshot = await _database
          .ref()
          .child('users')
          .child(userId ?? "")
          .child('workoutSchedules')
          .get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        _workoutSchedules = data.map((date, workouts) {
          final workoutList =
              (workouts as Map<dynamic, dynamic>).values.map((workout) {
            return {
              'workoutName': workout['workoutName'] ?? '',
              'scheduledDateTime': workout['scheduledDateTime'] ?? '',
              'workoutId': workout['workoutId'] ?? '',
              'isActive': workout['isActive'] ?? true,
              'isCompleted': workout['isCompleted'] ?? false,
            };
          }).toList();
          return MapEntry(date, workoutList);
        });
      } else {
        _workoutSchedules = {};
      }
    } catch (e) {
      print('Error fetching workouts: $e');
      _workoutSchedules = {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setDateAndTime(DateTime date, TimeOfDay time) {
    selectedDate = date;
    selectedTime = time;
    notifyListeners();
  }

  Future<void> markWorkoutAsCompletedAndMove(
      BuildContext context, String workoutId, String sm) async {
    _isCompleting = true;
    notifyListeners();

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in.')),
        );
        return;
      }

      final databaseReference = FirebaseDatabase.instance.ref();

      // Locate the workout based on workoutId across all schedules
      final scheduledWorkoutsRef = databaseReference
          .child('users')
          .child(userId)
          .child('workoutSchedules');

      final snapshot = await scheduledWorkoutsRef.get();

      if (!snapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No scheduled workouts found.')),
        );
        return;
      }

      bool workoutFound = false;
      Map<dynamic, dynamic>? workoutData;

      // Iterate through schedules to locate the workout by workoutId
      for (var dateKey in snapshot.children) {
        final workoutRef = dateKey.child(workoutId);

        if (workoutRef.exists) {
          workoutData = workoutRef.value as Map<dynamic, dynamic>;
          workoutFound = true;
          DateTime now = DateTime.now();

          // Format the date to include only day and month
          String formattedDate =
              "${now.day.toString().padLeft(2, '0')} ${now.month.toString().padLeft(2, '0')} ${now.year}";

          // Mark the workout as completed
          workoutData['isCompleted'] = true;
          // Move the workout to the completed workouts collection
          await databaseReference
              .child('users')
              .child(userId)
              .child('completedWorkouts')
              .child(formattedDate)
              .push()
              .set(workoutData);

          // Delete the workout from its original location
          await workoutRef.ref.remove();
          break;
        }
      }

      if (!workoutFound) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Workout not found.')),
        );
        _isCompleting = false;
        notifyListeners();
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Workout marked as completed and moved to completed list!')),
      );
      _isCompleting = false;
      notifyListeners();
      Navigator.pop(context);

      // Refresh the scheduled workouts
      await fetchWorkouts();
    } catch (e) {
      THelperFunctions.showSnackBar('Error: $e', context);
      _isCompleting = false;
      notifyListeners();
    }
  }

  Future<void> scheduleWorkout(BuildContext context, String workoutName) async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both date and time.')),
      );
      return;
    }

    final combinedDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    try {
      final databaseReference = FirebaseDatabase.instance.ref();

      // Format the date for organization
      final String formattedDate =
          "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}";

      // Generate a unique ID for the workout
      final String workoutId = databaseReference.push().key ?? "";

      // Path: /users/{userId}/workoutSchedules/{formattedDate}/{workoutId}
      final workoutData = {
        'workoutId': workoutId, // Add the workout ID
        'workoutName': workoutName,
        'scheduledDateTime': combinedDateTime.toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
        'isCompleted': false,
        'isActive': true,
      };

      final String? userUid = FirebaseAuth.instance.currentUser?.uid;

      if (userUid != null) {
        await databaseReference
            .child('users') // Root collection for all users
            .child(userUid) // User-specific data
            .child('workoutSchedules') // Workouts collection
            .child(formattedDate) // Specific date
            .child(workoutId) // Use the generated workout ID
            .set(workoutData);

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Workout scheduled successfully!')),
        );
      }
    } catch (e) {
      THelperFunctions.showSnackBar("Error: $e", context);
    }
  }

  // Future<void> scheduleWorkout(BuildContext context, String workoutName) async {
  //   if (selectedDate == null || selectedTime == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Please select both date and time.')),
  //     );
  //     return;
  //   }
  //
  //   final combinedDateTime = DateTime(
  //     selectedDate!.year,
  //     selectedDate!.month,
  //     selectedDate!.day,
  //     selectedTime!.hour,
  //     selectedTime!.minute,
  //   );
  //
  //   try {
  //     // Get the current user's ID
  //     final User? user = FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('User not logged in.')),
  //       );
  //       return;
  //     }
  //     final String userId = user.uid;
  //
  //     // Prepare workout data
  //     final workoutData = {
  //       'workoutName': workoutName,
  //       'scheduledDateTime': combinedDateTime.toIso8601String(),
  //       'createdAt': FieldValue.serverTimestamp(),
  //     };
  //
  //     final String formattedDate = "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}";
  //
  //     // Reference to Firestore node for user-specific daily workouts
  //     final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //     await firestore
  //         .collection('users') // Root collection for users
  //         .doc(userId) // Document for the specific user
  //         .collection('workouts') // Sub-collection for workouts
  //         .doc(formattedDate) // Daily workout document based on the selected date
  //         .collection('workoutList') // Sub-collection for the list of workouts
  //         .add(workoutData);
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Workout scheduled successfully!')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //   }
  // }
  //

  Future<void> setTimeAndDateForWorkout(BuildContext context) async {
    try {
      // Pick a date
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );

      if (pickedDate == null) {
        return; // User canceled the date picker
      }

      // Pick a time
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now(),
      );

      if (pickedTime == null) {
        return; // User canceled the time picker
      }

      // Update the provider's date and time variables
      setDateAndTime(pickedDate, pickedTime);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Date and time set successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// class WorkoutViewModel with ChangeNotifier {
//
// }
