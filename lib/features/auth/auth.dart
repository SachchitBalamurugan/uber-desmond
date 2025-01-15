import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthapp/features/auth/sign_up.dart';

import '../../providers/auth_provider.dart';
import '../home/bottom_nav_bar.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Wait for Firebase initialization
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error initializing Firebase"));
        } else {
          // Firebase has been initialized, now listen to the auth state
          return Consumer<AuthController>(
            builder: (context, authController, _) {
              // Check if Firebase auth is initialized
              if (!authController.isInitialized) {
                return const Center(child: CircularProgressIndicator());
              }

              // Check if the user is logged in
              if (authController.currentUser != null) {
                // Navigate to Home Screen
                return  TBottomNavigationBar();
              } else {
                // Navigate to Sign Up Screen
                return const SignUpScreen();
              }
            },
          );
        }
      },
    );
  }
}