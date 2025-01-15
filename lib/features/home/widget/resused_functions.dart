// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class HomeReusedFunctions {
//   void _showBmiCalculator(BuildContext context) {
//     final TextEditingController weightController = TextEditingController();
//     final TextEditingController heightController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         // card weight and height
//         return AlertDialog(
//           title: Text('Update'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               PieChartExample(),
//               TextField(
//                 controller: weightController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(labelText: 'Weight (kg)'),
//               ),
//               TextField(
//                 controller: heightController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(labelText: 'Height (cm)'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 // Parse the weight and height values
//                 double? weight = double.tryParse(weightController.text);
//                 double? height = double.tryParse(heightController.text);
//
//                 if (weight != null && height != null && height > 0) {
//                   // Update Firestore with the new values
//                   User? user = FirebaseAuth.instance.currentUser;
//                   if (user != null) {
//                     try {
//                       // Update height and weight under the user's document
//                       await FirebaseFirestore.instance
//                           .collection('users')
//                           .doc(user.uid) // Use the logged-in user's ID
//                           .update({
//                         'weight': weight,
//                         'height': height,
//                       });
//
//                       // Calculate BMI
//                       double heightInM = height / 100; // Convert cm to meters
//                       double bmi = weight / (heightInM * heightInM);
//
//                       setState(() {
//                         _bmi = bmi; // Update BMI value
//                       });
//
//                       Navigator.of(context).pop(); // Close the dialog
//                     } catch (e) {
//                       // Handle error while updating Firestore
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text('Failed to update information: $e'),
//                       ));
//                     }
//                   } else {
//                     // User is not logged in
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       content: Text('You must be logged in to update information.'),
//                     ));
//                     Navigator.of(context).pop(); // Close the dialog if not logged in
//                   }
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text('Please enter valid weight and height values'),
//                   ));
//                 }
//               },
//               child: Text('Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }