import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/common/widgets/user_name_builder.dart';
import 'package:healthapp/features/home/widget/alarm_detailed_widget.dart';
import 'package:healthapp/features/home/workout_tracker.dart';
import 'package:healthapp/features/calendar.dart';
import 'package:healthapp/features/goals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthapp/features/home/home.dart';
import 'package:healthapp/features/sleep-week.dart';
import 'package:healthapp/utils/route_const.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/heart_rate.dart';
import '../../main.dart';
import '../../providers/add_alarm_provider.dart';
import '../../utils/helpers/notifications.dart';
import '../sleep_tracking/widgets/alarm_detailed_card.dart';

class SleepTrackerScreen extends StatefulWidget {
  const SleepTrackerScreen({super.key});

  @override
  _SleepTrackerScreenState createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends State<SleepTrackerScreen> {
  String userName = ''; // Store the user name here

  @override
  void initState() {
    super.initState();
    _getUserName();
    _getUserData();
  }

  // Function to get the user's height and weight from Firestore and calculate BMI
  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // User ID from FirebaseAuth
          .get();

      if (userDoc.exists) {
        // Get height and weight values
        var height = userDoc['height'];
        var weight = userDoc['weight'];

        // Convert them to double if needed
        double heightInCm = (height is String
                ? double.tryParse(height)
                : (height is int ? height.toDouble() : 0.0)) ??
            0.0;
        double weightInKg = (weight is String
                ? double.tryParse(weight)
                : (weight is int ? weight.toDouble() : 0.0)) ??
            0.0;

        // Calculate BMI if both height and weight are available
        if (heightInCm > 0 && weightInKg > 0) {
          setState(() {
            // Convert height to meters and calculate BMI
            double heightInM = heightInCm / 100;
            _bmi = weightInKg / (heightInM * heightInM);
          });
        }
      } else {
        print('User document not found!');
      }
    }
  }

  // Function to get the user's name from Firestore
  Future<void> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // User ID from FirebaseAuth
          .get();

      if (userDoc.exists) {
        // setState(() {
        userName = userDoc['name'] ?? 'No name available';
        // });
      } else {
        print('User document not found!');
      }
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  double _bmi = 0; // Initial BMI value
  List<double> pieData = [20.1, 79.9]; // Placeholder pie data for BMI
  int _currentWaterIntake = 0; // Current water intake in milliliters
  final int _dailyWaterGoal = 2000; // Daily water intake goal in milliliters
  void _showBmiCalculator() {
    final TextEditingController weightController = TextEditingController();
    final TextEditingController heightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        // card weight and height
        return AlertDialog(
          title: Text('Update'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
              ),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Height (cm)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Parse the weight and height values
                double? weight = double.tryParse(weightController.text);
                double? height = double.tryParse(heightController.text);

                if (weight != null && height != null && height > 0) {
                  // Update Firestore with the new values
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    try {
                      // Update height and weight under the user's document
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid) // Use the logged-in user's ID
                          .update({
                        'weight': weight,
                        'height': height,
                      });

                      // Calculate BMI
                      double heightInM = height / 100; // Convert cm to meters
                      double bmi = weight / (heightInM * heightInM);

                      setState(() {
                        _bmi = bmi; // Update BMI value
                      });

                      Navigator.of(context).pop(); // Close the dialog
                    } catch (e) {
                      // Handle error while updating Firestore
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Failed to update information: $e'),
                      ));
                    }
                  } else {
                    // User is not logged in
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('You must be logged in to update information.'),
                    ));
                    Navigator.of(context)
                        .pop(); // Close the dialog if not logged in
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Please enter valid weight and height values'),
                  ));
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _addWaterIntake(int amount) {
    setState(() {
      _currentWaterIntake += amount;
      if (_currentWaterIntake > _dailyWaterGoal) {
        _currentWaterIntake = _dailyWaterGoal;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AddAlarmProvider>(context);
// For periodic notifications until a specific time

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // Welcome Section
            Text(
              'Sleep Tracker',
              style: GoogleFonts.poppins(
                fontSize: 18, // Smaller size
                fontWeight: FontWeight.normal, // Regular weight
                color: Colors.grey, // Gray color
              ),
            ),
            // Name in a new line, bigger and bold
           UserNameBuilder(),

            SizedBox(height: 16),
            // BMI Card
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8EB1BB), Color(0xFFB7D5DE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF8EB1BB), Color(0xFFB7D5DE)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last Night Sleep',
                              style: TextStyle(
                                fontFamily: 'Poppins', // Use Poppins font
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8), // Add spacing between texts
                            Text(
                              '7 hours, 45 minutes',
                              style: TextStyle(
                                fontFamily: 'Poppins', // Use Poppins font
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Positioned image at the bottom
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Image.asset(
                          'assets/Sleep-Graph.png', // Replace with your asset path
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Target
            Container(
              padding: EdgeInsets.all(16.0),
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
                    color: Colors.grey
                        .withOpacity(0.3), // Shadow color with transparency
                    spreadRadius: 2, // How far the shadow spreads
                    blurRadius: 6, // The softness of the shadow
                    offset: Offset(0, 3), // Position of the shadow (x, y)
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Daily Sleep Schedule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Adjust if needed
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(32, 32), // Smaller button size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 0, // Optional: Remove shadow for a flat look
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, GRoute.sleepScheduleScreen);
                      // Add your button action here
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => SleepWeek()),
                      // );
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF8EB1BB), Color(0xFFB7D5DE)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          'Check',
                          style: TextStyle(
                            fontSize: 12, // Smaller text size
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bold "Today's Schedule" Text
                Text(
                  'Today\'s Schedule',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16), // Spacing below the header
                // First Card (Bedtime)
                StreamBuilder<Map<String, dynamic>?>(
                  stream: alarmProvider.fetchAlarm(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: Text("No alarm data available"),
                      );
                    }

                    final alarmData = snapshot.data!;
                    final bedtime = alarmData["bedtime"] ?? "09:00 PM";
                    final sleepHours =
                        alarmData["sleepHours"] ?? "8 Hours 30 Minutes";
                    // sendNotification(bedtime);
                    return Center(
                      child: AlarmDetailedWidget(
                        time: bedtime,
                        timeLeft: sleepHours,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateRow(String time, String intake) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            intake,
            style: TextStyle(fontSize: 16, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final Gradient gradient;

  GradientCircularProgressPainter({
    required this.progress,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint backgroundPaint = Paint()
      ..color = Color(0xFFF7F8F8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final Paint progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    canvas.drawCircle(
        size.center(Offset.zero), size.width / 2, backgroundPaint);

    // Draw progress arc
    final double startAngle = -90 * (3.14159 / 180); // Start at the top
    final double sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
