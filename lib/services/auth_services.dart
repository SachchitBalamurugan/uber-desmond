import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/utils/route_const.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // User stream to listen to authentication changes
  Stream<User?> get user => _auth.authStateChanges();

  // Function to sign up
  Future<void> signUp(context, {
    required TextEditingController emailCtr,
    required TextEditingController passwordCtr,
    required TextEditingController nameCtr,
    required TextEditingController ageCtr,
    required TextEditingController weightCtr,
    required TextEditingController heightCtr,
  }) async {
    try {
      // Check if the email is already in use
      final signInMethods = await _auth.fetchSignInMethodsForEmail(emailCtr.text);
      if (signInMethods.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The email is already in use. Please log in.')),
        );
        return;
      }

      // Proceed with sign-up
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailCtr.text,
        password: passwordCtr.text,
      );

      // Store additional user information
      User? user = userCredential.user;
      if (user != null) {
        // First save as current info
        await _database.child('users').child(user.uid).child('userCurrentInfo').set({
          'name': nameCtr.text,
          'age': int.parse(ageCtr.text),
          'weight': double.parse(weightCtr.text),
          'height': double.parse(heightCtr.text),
          'email': emailCtr.text,
          'muscleMass': 0.0,  // Default value
          'abs': 0.0,         // Default value
          'timestamp': ServerValue.timestamp,
        });

        // Also save as previous info for initial state
        await _database.child('users').child(user.uid).child('usersPreviousInfo').set({
          'name': nameCtr.text,
          'age': int.parse(ageCtr.text),
          'weight': double.parse(weightCtr.text),
          'height': double.parse(heightCtr.text),
          'email': emailCtr.text,
          'muscleMass': 0.0,  // Default value
          'abs': 0.0,         // Default value
          'timestamp': ServerValue.timestamp,
        });

        Navigator.pushReplacementNamed(context, GRoute.auth);
      }
    } catch (e) {
      print('Sign-up error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-up failed: $e')),
      );
    }
  }

  // Update user information
  Future<void> updateUserInfo({
    required String userUid,
    required double weight,
    required double height,
    required double muscleMass,
    required double abs,
  }) async {
    try {
      // First, get the current info
      DatabaseEvent event = await _database
          .child('users')
          .child(userUid)
          .child('userCurrentInfo')
          .once();

      if (event.snapshot.value != null) {
        // Move current info to previous info
        await _database
            .child('users')
            .child(userUid)
            .child('usersPreviousInfo')
            .set(event.snapshot.value);
      }

      // Update current info with new values
      await _database
          .child('users')
          .child(userUid)
          .child('userCurrentInfo')
          .update({
        'weight': weight,
        'height': height,
        'muscleMass': muscleMass,
        'abs': abs,
        'timestamp': ServerValue.timestamp,
      });
    } catch (e) {
      print('Update user info error: $e');
      throw e;
    }
  }

  // Function to log in
  Future<void> login(BuildContext context, {
    required TextEditingController emailCtr,
    required TextEditingController passwordCtr,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailCtr.text,
        password: passwordCtr.text,
      );
      Navigator.pushReplacementNamed(context, GRoute.auth);
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  // Sign out the current user
  Future<void> signOut(BuildContext ctx) async {
    try {
      await _auth.signOut();
      Navigator.restorablePopAndPushNamed(ctx, GRoute.auth);
    } catch (e) {
      debugPrint('Error in signOut: $e');
      throw e;
    }
  }

  // Send a password reset email
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Error in forgotPassword: $e');
      throw e;
    }
  }

  // Delete user account and data
  Future<void> deleteAccount(String userUid) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete user data from Realtime Database
        await _database.child('users').child(userUid).remove();
        // Delete user account
        await user.delete();
      }
    } catch (e) {
      debugPrint('Error in deleteAccount: $e');
      throw e;
    }
  }

// Other authentication methods remain the same...
}