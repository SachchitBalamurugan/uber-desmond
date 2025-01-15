import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/services/user_info_repository.dart';

import '../model/user_info.dart';

class UserInfoModelProvider extends ChangeNotifier {
  final UserInfoModelRepository _repository = UserInfoModelRepository();

  Stream<Map<String, UserInfoModel>> getUserInfoModelStream() {
    // Get the current user's UID
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value({});
    }
    return _repository.getUserInfoModelStream();
  }

  double calculateIncrease(double previous, double current) {
    if (previous == 0 || current == 0) return 0;
    return ((current - previous) / previous * 100).abs();
  }

  Future<void> updateUserData(double weight, double height) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Get a reference to the user's node
        DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${user.uid}');

        // Retrieve the current user info
        DataSnapshot currentInfoSnapshot = await userRef.child('userCurrentInfo').get();
        if (currentInfoSnapshot.exists) {
          // Save the current user info to the userPreviousInfo node
          await userRef.child('userPreviousInfo').set(currentInfoSnapshot.value);
        }

        // Update the userCurrentInfo node with new data
        await userRef.child('userCurrentInfo').set({
          'weight': weight,
          'height': height,
        });

        // Update local variables
        double heightInM = height / 100;
        double bmi = weight / (heightInM * heightInM);

        // Optionally, add logic to notify listeners or handle UI updates if needed
        print("User data updated successfully. New BMI: $bmi");
      } catch (e) {
        print("Error updating user data: $e");
      }
    }
  }

  String getProgressStatus(double previous, double current) {
    if (previous == 0 || current == 0) return 'static';
    if (current > previous) return 'increase';
    if (current < previous) return 'decrease';
    return 'static';
  }


  // Stream for user's name
  Stream<String> getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value('User');
    }
    return _repository.getCurrentUserName();
  }

  // Stream for user's BMI
  Stream<double> getUserBMI() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value(0.0);
    }
    return _repository.getCurrentUserBMI();
  }

  // Helper method to get BMI category
  String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Overweight';
    } else if (bmi >= 30) {
      return 'Obese';
    } else {
      return 'Unknown';
    }
  }

  // Helper method to get BMI category color
  Color getBMICategoryColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.orange;
    } else if (bmi >= 18.5 && bmi < 25) {
      return Colors.green;
    } else if (bmi >= 25 && bmi < 30) {
      return Colors.orange;
    } else if (bmi >= 30) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }



}