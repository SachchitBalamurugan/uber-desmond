// user_info_repository.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/user_info.dart';

class UserInfoModelRepository {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Stream<Map<String, UserInfoModel>> getUserInfoModelStream() {
    final String userUid = FirebaseAuth.instance.currentUser!.uid;
    return _database
        .child('users')
        .child(userUid)
        .onValue
        .map((event) {
      if (event.snapshot.value == null) {
        return {};
      }

      try {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);

        final previousInfo = data['usersPreviousInfo'] != null
            ? UserInfoModel.fromJson(Map<String, dynamic>.from(data['usersPreviousInfo']))
            : null;

        final currentInfo = data['userCurrentInfo'] != null
            ? UserInfoModel.fromJson(Map<String, dynamic>.from(data['userCurrentInfo']))
            : null;

        return {
          'previous': previousInfo ?? UserInfoModel.fromJson({}),
          'current': currentInfo ?? UserInfoModel.fromJson({}),
        };
      } catch (e) {
        print('Error parsing user info: $e');
        return {};
      }
    });
  }

  // Stream for user's current name
  Stream<String> getCurrentUserName() {
    final String userUid = FirebaseAuth.instance.currentUser!.uid;
    return _database
        .child('users')
        .child(userUid)
        .child('userCurrentInfo')
        .child('name')
        .onValue
        .map((event) {
      return event.snapshot.value?.toString() ?? 'User';
    });
  }

  // Stream for user's current BMI
  Stream<double> getCurrentUserBMI() {
    final String userUid = FirebaseAuth.instance.currentUser!.uid;
    return _database
        .child('users')
        .child(userUid)
        .child('userCurrentInfo')
        .onValue
        .map((event) {
      if (event.snapshot.value == null) {
        return 0.0;
      }

      try {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        final height = (data['height'] ?? 0.0).toDouble() / 100; // Convert cm to meters
        final weight = (data['weight'] ?? 0.0).toDouble();

        if (height <= 0 || weight <= 0) return 0.0;

        // BMI formula: weight (kg) / (height (m))²
        return double.parse((weight / (height * height)).toStringAsFixed(1));
      } catch (e) {
        print('Error calculating BMI: $e');
        return 0.0;
      }
    });
  }
}