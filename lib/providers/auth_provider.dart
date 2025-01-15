import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  User? _currentUser;
  bool _isInitialized = false;

  User? get currentUser => _currentUser;
  bool get isInitialized => _isInitialized;

  // Listen to Firebase auth state changes
  AuthController() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _currentUser = user;
      _isInitialized = true;
      notifyListeners();  // Notify listeners when state changes
    });
  }
}