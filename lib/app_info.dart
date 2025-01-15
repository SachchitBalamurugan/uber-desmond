import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF044051),
        hintColor: Color(0xFF8EB1BB),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF044051)),
          bodyMedium: TextStyle(color: Color(0xFF8EB1BB)),
        ),
      ),
      home: AppInfoPage(),
    );
  }
}

class AppInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health App Info'),
        backgroundColor: Color(0xFFFFFFFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Welcome to Your Health App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF044051),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'This app is your ultimate tool for improving your health and wellness. Track your workouts, monitor your diet, stay on top of your hydration, and take care of your mental well-being.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF8EB1BB),
              ),
            ),
            SizedBox(height: 20),
            FeatureSection(
              title: 'Track Your Workout',
              description:
              'Keep track of your workouts, set goals, and monitor progress. Whether you\'re lifting weights, running, or doing yoga, this app will help you stay fit.',
            ),
            FeatureSection(
              title: 'Step Tracking',
              description:
              'Set your daily step goals and track your steps throughout the day. Make every step count towards a healthier you.',
            ),
            FeatureSection(
              title: 'Diet Tracker',
              description:
              'Log your meals, track calories, and stay on top of your nutritional goals. Achieve your diet goals with personalized guidance.',
            ),
            FeatureSection(
              title: 'Mental Health Courses',
              description:
              'Access a wide variety of mental health resources and courses designed to help you cope with stress, anxiety, and improve your overall mental well-being.',
            ),
            FeatureSection(
              title: 'Water Intake Tracker',
              description:
              'Stay hydrated with our easy-to-use water intake tracker. Set reminders to drink more water and track your daily hydration goals.',
            ),
            FeatureSection(
              title: 'Sleep Tracker',
              description:
              'Track your sleep patterns and improve your sleep quality with insights and tips tailored to your needs.',
            ),
            FeatureSection(
              title: 'Earn Badges',
              description:
              'As you achieve your health goals, earn badges to celebrate your success and motivate yourself to keep going.',
            ),
            SizedBox(height: 20),
            Text(
              'Thank you for using our Health App. We are committed to helping you live a healthier and happier life!',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF044051),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureSection extends StatelessWidget {
  final String title;
  final String description;

  FeatureSection({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF044051),
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8EB1BB),
            ),
          ),
        ],
      ),
    );
  }
}
