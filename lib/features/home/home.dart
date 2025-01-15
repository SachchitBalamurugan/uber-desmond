import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/components/t_elevated_tile.dart';
import 'package:healthapp/features/home/widget/bmi_calculator.dart';
import 'package:healthapp/features/home/widget/bmi_update_dialog.dart';
import 'package:healthapp/features/home/widget/bottom_elevated_card_left.dart';
import 'package:healthapp/features/home/widget/bottom_elevated_card_right.dart';
import 'package:healthapp/features/home/widget/water_intake.dart';
import 'package:healthapp/services/user_info_repository.dart';
import 'package:healthapp/utils/constants/colors.dart';
import 'package:healthapp/utils/constants/sizes.dart';
import 'package:healthapp/utils/route_const.dart';
import '../../AI/ai_home.dart';
import '../../app_info.dart';
import '../../common/widgets/bmi_pie_builder.dart';
import '../../common/widgets/user_name_builder.dart';
import '../../components/heart_rate.dart';
import 'package:provider/provider.dart';
import '../../notifications.dart';
import '../../providers/user_data_provider.dart';
import '../../providers/user_info_provider.dart';
import '../../providers/water_intake_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sleepRepository = SleepRepository();

    return Consumer2<UserProvider, WaterIntakeProvider>(
      builder: (context, userProvider, waterIntakeProvider, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                // Welcome Section
                Row(
                  children: [
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // IconButton(onPressed: ()=>Navigator.pushNamed(context, GRoute.testerScreen), icon: Icon(Icons.transfer_within_a_station)),
                    IconButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, GRoute.gymNearYou),
                        icon: Icon(
                          Icons.pin_drop,
                          color: TColors.darkGrey,
                        )),
                    IconButton(
                        onPressed: () =>
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AppInfoPage())),
                        icon: Icon(
                          Icons.info_outline,
                          color: TColors.darkGrey,
                        )),
                    IconButton(
                        onPressed: () =>
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen())),
                        icon: Icon(
                          Icons.notifications_active_outlined,
                          color: TColors.darkGrey,
                        )),
                    IconButton(
                        onPressed: () =>
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AIscreen())),
                        icon: Icon(
                          Icons.rocket_launch_outlined,
                          color: TColors.darkGrey,
                        ))
                  ],
                ),
                UserNameBuilder(),
                SizedBox(height: 16),
                BMICalculatorCard(
                  onUpdatePressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BMIUpdateDialog();
                    },
                  ), animatedBmiPie: BmiPieBuilder(),

                ),
                // BMI Card

                SizedBox(height: TSizes.spaceBtwSections),

                // Target
                TElevatedTile(
                    buttonTitle: "Check",
                    onCheckPressed: () {},
                    title: "Today's Target",),

                // Adjust Add Goals Section
                TElevatedTile(
                    buttonTitle: "Add/Adjust",
                    onCheckPressed: () =>
                        Navigator.pushNamed(context, GRoute.goalsScreen),
                    title: "Adjust Add Goals"),

                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF044051),
                        Color(0xFFE9EDFF)
                      ], // Gradient colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: HeartBPMComponent(),
                ),
                // Water Intake Tracker
                SizedBox(height: 16),
                WaterIntakeWidget(
                  currentWaterIntake: waterIntakeProvider.currentWaterIntake,
                  dailyWaterGoal: waterIntakeProvider.dailyWaterGoal,
                  onAdding200: () {
                    Provider.of<UserProvider>(context, listen: false)
                        .addWaterIntake(200);
                    waterIntakeProvider.addWaterIntake(200);
                  },
                  onAdding500: () {
                    Provider.of<UserProvider>(context, listen: false)
                        .addWaterIntake(500);
                    waterIntakeProvider.addWaterIntake(500);
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    // First Box
                    Expanded(
                      child: BottomCalorieCard(),
                    ),
                    // Second Box
                    Expanded(
                      child: BottomElevatedCardRight(
                        sleepRepository: sleepRepository,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:healthapp/common/widgets/pie_chart/pie_chart.dart';
// import 'package:healthapp/components/t_elevated_tile.dart';
// import 'package:healthapp/features/home/widget/bmi_calculator.dart';
// import 'package:healthapp/features/home/widget/bottom_elevated_card_left.dart';
// import 'package:healthapp/features/home/widget/bottom_elevated_card_right.dart';
// import 'package:healthapp/features/home/widget/water_intake.dart';
// import 'package:healthapp/features/home/workout_tracker.dart';
// import 'package:healthapp/features/calendar.dart';
// import 'package:healthapp/features/home/profile.dart';
// import 'package:healthapp/features/goals.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:healthapp/features/meal_planner/meal_schedule_screen.dart';
// import 'package:healthapp/features/home/sleep_tracker.dart';
// import 'package:healthapp/utils/constants/colors.dart';
// import 'package:healthapp/utils/constants/sizes.dart';
// import 'package:healthapp/utils/route_const.dart';
// import '../../components/heart_rate.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   String userName = ''; // Store the user name here
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserName();
//     _getUserData();
//   }
//
//   // Function to get the user's height and weight from Firestore and calculate BMI
//   Future<void> _getUserData() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       // Fetch user data from Firestore
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid) // User ID from FirebaseAuth
//           .get();
//
//       if (userDoc.exists) {
//         // Get height and weight values
//         var height = userDoc['height'];
//         var weight = userDoc['weight'];
//
//         // Convert them to double if needed
//         double heightInCm = (height is String
//                 ? double.tryParse(height)
//                 : (height is int ? height.toDouble() : 0.0)) ??
//             0.0;
//         double weightInKg = (weight is String
//                 ? double.tryParse(weight)
//                 : (weight is int ? weight.toDouble() : 0.0)) ??
//             0.0;
//
//         // Calculate BMI if both height and weight are available
//         if (heightInCm > 0 && weightInKg > 0) {
//           setState(() {
//             // Convert height to meters and calculate BMI
//             double heightInM = heightInCm / 100;
//             _bmi = weightInKg / (heightInM * heightInM);
//           });
//         }
//       } else {
//         print('User document not found!');
//       }
//     }
//   }
//
//   // Function to get the user's name from Firestore
//   Future<void> _getUserName() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       // Fetch user data from Firestore
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid) // User ID from FirebaseAuth
//           .get();
//
//       if (userDoc.exists) {
//         // setState(() {
//         //   userName = userDoc['name'] ?? 'No name available';
//         // });
//       } else {
//         print('User document not found!');
//       }
//     }
//   }
//
//   double _bmi = 0; // Initial BMI value
//   List<double> pieData = [20.1, 79.9]; // Placeholder pie data for BMI
//   int _currentWaterIntake = 0; // Current water intake in milliliters
//   final int _dailyWaterGoal = 2000; // Daily water intake goal in milliliters
//   void _showBmiCalculator() {
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
//                       content:
//                           Text('You must be logged in to update information.'),
//                     ));
//                     Navigator.of(context)
//                         .pop(); // Close the dialog if not logged in
//                   }
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content:
//                         Text('Please enter valid weight and height values'),
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
//
//   void _addWaterIntake(int amount) {
//     setState(() {
//       _currentWaterIntake += amount;
//       if (_currentWaterIntake > _dailyWaterGoal) {
//         _currentWaterIntake = _dailyWaterGoal;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: SafeArea(
//         child: ListView(
//           padding: EdgeInsets.all(16.0),
//           children: [
//             // Welcome Section
//             Row(
//               children: [
//                 Text(
//                   'Welcome Back',
//                   style: GoogleFonts.poppins(
//                     fontSize: 18, // Smaller size
//                     fontWeight: FontWeight.normal, // Regular weight
//                     color: Colors.grey, // Gray color
//                   ),
//                 ),
//                 Spacer(),
//                 IconButton(
//                     onPressed: () =>
//                         Navigator.pushNamed(context, GRoute.gymNearYou),
//                     icon: Icon(
//                       Icons.pin_drop,
//                       color: TColors.darkGrey,
//                     ))
//               ],
//             ),
//             // Name in a new line, bigger and bold
//             Text(
//               userName.isNotEmpty ? userName : 'Loading...',
//               style: GoogleFonts.poppins(
//                 fontSize: 28, // Bigger size
//                 fontWeight: FontWeight.bold, // Bold weight
//               ),
//             ),
//
//             SizedBox(height: 16),
//
//             // BMI Card
//             BMICalculatorCard(onUpdatePressed: _showBmiCalculator, bmi: _bmi),
//             SizedBox(height: TSizes.spaceBtwSections),
//
//             // Target
//             TElevatedTile(
//                 buttonTitle: "Check",
//                 onCheckPressed: () {},
//                 title: "Today's Target"),
//
//             // Adjust Add Goals Section
//             TElevatedTile(
//                 buttonTitle: "Add/Adjust",
//                 onCheckPressed: () =>
//                     Navigator.pushNamed(context, GRoute.goalsScreen),
//                 title: "Adjust Add Goals"),
//
//             SizedBox(height: 16),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xFF044051),
//                     Color(0xFFE9EDFF)
//                   ], // Gradient colors
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey
//                         .withOpacity(0.3), // Shadow color with transparency
//                     spreadRadius: 2, // How far the shadow spreads
//                     blurRadius: 6, // The softness of the shadow
//                     offset: Offset(0, 3), // Position of the shadow (x, y)
//                   ),
//                 ],
//               ),
//               padding: EdgeInsets.all(16),
//               child:
//                   HeartBPMComponent(), // The original component inside the container
//             ),
//             //water
//             SizedBox(height: 16),
//             // Water Intake Tracker
//             WaterIntakeWidget(
//                 currentWaterIntake: _currentWaterIntake,
//                 dailyWaterGoal: _dailyWaterGoal,
//                 onAdding200: () => _addWaterIntake(200),
//                 onAdding500: () => _addWaterIntake(500)), /////////
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 // First Box
//                 Expanded(
//                   child: BottomElevatedCard(),
//                 ),
//                 // Second Box
//                 Expanded(
//                   child: BottomElevatedCardRight(),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
