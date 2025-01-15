// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class AuthController extends GetxController {
//   // Simulate a current user (replace with your actual user object)
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final Rx<TUser?> _currentUser = Rx<TUser?>(null);
//   User?  getCurrentUser() => _auth.currentUser;
//   // Getter for the current user
//   TUser? get currentUser => _currentUser.value;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Simulate checking if the user is logged in (replace with your actual logic)
//     checkLoginStatus();
//   }
//
//   Future<void> checkLoginStatus() async {
//     // Replace this with your actual logic to check if the user is logged in
//     // For example, you might check for a token in shared preferences or
//     // make an API call to verify the user's session.
//     await Future.delayed(const Duration(seconds: 2)); // Simulate a delay
//
//     // Example: Check if a token exists in shared preferences
//     // final prefs = await SharedPreferences.getInstance();
//     // final token = prefs.getString('token');
//     // _isLoggedIn.value = token != null;
//
//     // For this example, let's just toggle the value randomly
//     // _isLoggedIn.value = [true, false].sample()!;
//     // _currentUser.value = [User(id: '1', name: 'user'), null].sample()!;
//
//     // Navigate to the appropriate screen
//     navigateToAppropriateScreen();
//   }
//
//   void navigateToAppropriateScreen() {
//     if (currentUser != null) {
//       Get.offAllNamed('/home'); // Navigate to home and remove previous routes
//     } else {
//       Get.offAllNamed('/login'); // Navigate to login and remove previous routes
//     }
//   }
//
//   // Example login method (replace with your actual login logic)
//   Future<void> login(String username, String password) async {
//     // Simulate login process
//     await Future.delayed(const Duration(seconds: 1));
//
//     // Check credentials (replace with your actual logic)
//     if (username == 'user' && password == 'password') {
//       _currentUser.value = TUser(id: '1', name: 'user');
//       // Store token in shared preferences (if needed)
//       // final prefs = await SharedPreferences.getInstance();
//       // await prefs.setString('token', 'your_token');
//       navigateToAppropriateScreen();
//     } else {
//       Get.snackbar('Error', 'Invalid credentials');
//     }
//   }
//
//   // Example logout method (replace with your actual logout logic)
//   Future<void> logout() async {
//     // Simulate logout process
//     await Future.delayed(const Duration(seconds: 1));
//
//     _currentUser.value = null;
//     // Remove token from shared preferences (if needed)
//     // final prefs = await SharedPreferences.getInstance();
//     // await prefs.remove('token');
//     navigateToAppropriateScreen();
//   }
// }
//
// // Example User class (replace with your actual User model)
// class TUser {
//   final String id;
//   final String name;
//
//   TUser({required this.id, required this.name});
// }