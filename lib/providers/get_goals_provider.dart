// get_goals_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GetGoalsProvider with ChangeNotifier {
  double _overallProgress = 0.6;
  TextEditingController searchController = TextEditingController();
  String goalName = '';

  // Getter for overall progress
  double get overallProgress => _overallProgress;

  void setGoalName(String newName) {
    goalName = newName;
    notifyListeners();
  }
  // double _overallProgress = 0.6;
  // TextEditingController searchController = TextEditingController();
  // String goalName = '';
  List<Map<String, dynamic>> _filteredGoals = [];
  bool _isSearching = false;

  // Getters
  // double get overallProgress => _overallProgress;
  List<Map<String, dynamic>> get filteredGoals => _filteredGoals;
  bool get isSearching => _isSearching;

  // void setGoalName(String newName) {
  //   goalName = newName;
  //   notifyListeners();
  // }

  void searchGoalByName(String name) async {
    _isSearching = true;
    if (name.isEmpty) {
      _filteredGoals = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    try {
      final allGoals = await getAllGoals();
      _filteredGoals = allGoals.where((goal) {
        final goalName = goal['goalName'].toString().toLowerCase();
        return goalName.contains(name.toLowerCase());
      }).toList();
    } catch (e) {
      debugPrint('Error searching goals: $e');
      _filteredGoals = [];
    }

    _isSearching = false;
    notifyListeners();
  }
  Stream<List<Map<String, dynamic>>> getSubGoalsStream() {
    try {
      final userUid = FirebaseAuth.instance.currentUser?.uid;
      if (userUid == null) {
        throw Exception('User is not authenticated.');
      }

      return FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userUid)
          .child('subGoals')
          .child(goalName)
          .onValue
          .map((event) {
        try {
          final data = event.snapshot.value as Map<Object?, Object?>?;
          if (data == null) return [];

          return data.entries.map((entry) {
            final key = entry.key as String;
            final value = entry.value;

            if (value is Map<Object?, Object?>) {
              return {
                'title': key,
                'progress': value['progress'] ?? 0.0,
              };
            } else {
              debugPrint('Unexpected value type for subGoal: $value');
              return {
                'title': key,
                'progress': 0.0,
              };
            }
          }).toList();
        } catch (e) {
          debugPrint('Error parsing Firebase data: $e');
          return [];
        }
      });
    } catch (e) {
      debugPrint('Error initializing subGoalsStream: $e');
      return Stream.value([]);
    }
  }

  Future<List<Map<String, dynamic>>> getAllGoals() async {
    try {
      final userUid = FirebaseAuth.instance.currentUser?.uid;
      if (userUid == null) {
        throw Exception('User is not authenticated.');
      }

      final snapshot = await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userUid)
          .child('subGoals')
          .get();

      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<Object?, Object?>;
        List<Map<String, dynamic>> goals = [];

        data.forEach((key, value) {
          if (value is Map<Object?, Object?>) {
            goals.add({
              'goalName': key as String,
              'data': Map<String, dynamic>.from(value as Map),
            });
          }
        });

        return goals;
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching all goals: $e');
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> getAllGoalsStream() {
    try {
      final userUid = FirebaseAuth.instance.currentUser?.uid;
      if (userUid == null) {
        throw Exception('User is not authenticated.');
      }

      return FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userUid)
          .child('subGoals')
          .onValue
          .map((event) {
        try {
          final data = event.snapshot.value as Map<Object?, Object?>?;
          if (data == null) return [];

          return data.entries.map((entry) {
            return {
              'goalName': entry.key as String,
              'data': Map<String, dynamic>.from(entry.value as Map),
            };
          }).toList();
        } catch (e) {
          debugPrint('Error parsing Firebase  $e');
          return [];
        }
      });
    } catch (e) {
      debugPrint('Error initializing goals stream: $e');
      return Stream.value([]);
    }
  }
}