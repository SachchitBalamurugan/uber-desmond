import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _userName = '';
  double _bmi = 0;
  double _height = 0;  // Changed to double
  double _weight = 0;  // Changed to double

  String get userName => _userName;
  double get bmi => _bmi;
  double get height => _height;
  double get weight => _weight;

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          _userName = userDoc['name'] ?? 'No name available';

          // Safely fetch and convert height and weight to double
          _height = (userDoc['height'] is double)
              ? userDoc['height']
              : (userDoc['height'] is int)
              ? (userDoc['height'] as int).toDouble()
              : 0.0;  // Default to 0.0 if data type is invalid

          _weight = (userDoc['weight'] is double)
              ? userDoc['weight']
              : (userDoc['weight'] is int)
              ? (userDoc['weight'] as int).toDouble()
              : 0.0;  // Default to 0.0 if data type is invalid

          // Calculate BMI
          if (_height > 0 && _weight > 0) {
            double heightInM = _height / 100;
            _bmi = _weight / (heightInM * heightInM);
          }
          debugPrint(">>>>>>>>>>>>>>>>>>>>>>$_bmi<<<<<<<<<<<<<<<");
          notifyListeners();
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  Future<void> updateUserData(double weight, double height) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'weight': weight, 'height': height});

        _weight = weight;
        _height = height;

        // Update BMI
        double heightInM = height / 100;
        _bmi = weight / (heightInM * heightInM);

        notifyListeners();
      } catch (e) {
        print("Error updating user data: $e");
      }
    }
  }
  Future<void> addWaterIntake(int intakeAmount) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        String userId = user.uid;
        String todayDate = DateTime.now().toIso8601String().split('T')[0]; // Format: YYYY-MM-DD

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
        int updatedIntake = currentIntake + intakeAmount;
        await waterIntakeRef.set(updatedIntake);

        notifyListeners();
      } catch (e) {
        print("Error updating water intake: $e");
      }
    }
  }
}
