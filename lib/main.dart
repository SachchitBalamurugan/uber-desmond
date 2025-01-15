import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:healthapp/features/alarm_add_update.dart';
import 'package:healthapp/features/auth/auth.dart';
import 'package:healthapp/features/auth/forgot_password_screen.dart';
import 'package:healthapp/features/auth/login_screen.dart';
import 'package:healthapp/features/exercises/badge_screen.dart';
import 'package:healthapp/features/exercises/gym_near_you.dart';
import 'package:healthapp/features/exercises/steps_screen.dart';
import 'package:healthapp/features/exercises/workout.dart';
import 'package:healthapp/features/exercises/workout_details_screen.dart';
import 'package:healthapp/features/goals/goals_screen.dart';
import 'package:healthapp/features/meal_planner/breakfast_screen.dart';
import 'package:healthapp/features/meal_planner/meal_adding_screen.dart';
import 'package:healthapp/features/meal_planner/meal_planner_screen.dart';
import 'package:healthapp/features/meal_planner/meal_schedule_screen.dart';
import 'package:healthapp/features/meal_planner/popular_meal_next_screen.dart';
import 'package:healthapp/features/auth/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/features/progress_result/result_screen.dart';
import 'package:healthapp/providers/add_alarm_provider.dart';
import 'package:healthapp/providers/auth_provider.dart';
import 'package:healthapp/providers/badges_provider.dart';
import 'package:healthapp/providers/get_goals_provider.dart';
import 'package:healthapp/providers/goal_provider.dart';
import 'package:healthapp/providers/gym_provider.dart';
import 'package:healthapp/providers/home_provider.dart';
import 'package:healthapp/providers/meal_adding_provider.dart';
import 'package:healthapp/providers/progress_photo_provider.dart';
import 'package:healthapp/providers/step_provider.dart';
import 'package:healthapp/providers/user_data_provider.dart';
import 'package:healthapp/providers/user_info_provider.dart';
import 'package:healthapp/providers/water_intake_provider.dart';
import 'package:healthapp/providers/workout_data_provider.dart';
import 'package:healthapp/providers/workout_provider.dart';
import 'package:healthapp/tester_file.dart';
import 'package:healthapp/utils/helpers/notifications.dart';
import 'package:healthapp/utils/route_const.dart'; // Route constants
import 'package:healthapp/utils/theme/theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'features/home/bottom_nav_bar.dart';
import 'features/home/home.dart';
import 'features/progress_tracker/progress_tracker.dart';
import 'features/sleep-week.dart';
import 'firebase_options.dart'; // Generated Firebase options


void main() async {
  // Ensure widgets are bound and Firebase is initialized.
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.init(); // Ensure the init method is awaited

  // Request permission.
  requestNotificationPermission();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    runApp(const MyApp());
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutViewModel()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutDataProvider()),
        ChangeNotifierProvider(create: (_) => GymProvider()),
        ChangeNotifierProvider(create: (_) => SaveGoalProvider()),
        ChangeNotifierProvider(create: (_) => BadgeProvider()),
        ChangeNotifierProvider(create: (_) => StepsProvider()),
        ChangeNotifierProvider(create: (_) => WaterIntakeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProgressPhotoProvider()),
        ChangeNotifierProvider(create: (_) => AddAlarmProvider()),
        ChangeNotifierProvider(create: (_) => GetGoalsProvider()),
        ChangeNotifierProvider(create: (_) => MealScheduleProvider()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => UserInfoModelProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Health App',
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        themeMode: ThemeMode.light,
        initialRoute: GRoute.auth,
        routes: {
          GRoute.auth: (_) => AuthScreen(),
          GRoute.login: (_) => GetStartedScreen(),
          GRoute.signUp: (_) => SignUpScreen(),
          GRoute.home: (_) => HomeScreen(),
          GRoute.breakFastScreen: (_) => BreakFastScreen(),
          GRoute.popularMealNextScreen: (_) => MealDetailsScreen(),
          GRoute.workoutDetailsScreen: (_) => WorkoutDetailsScreen(),
          GRoute.mealPlannerScreen: (_) => MealPlannerScreen(),
          GRoute.mealScheduleScreen: (_) => MealScheduleScreen(),
          GRoute.bottomNavBar: (_) => TBottomNavigationBar(),
          GRoute.workoutScreen: (_) => WorkoutScreen(),
          GRoute.sleepScheduleScreen: (_) => SleepScheduleScreen(),
          GRoute.addAlarmScreen: (_) => AddAlarmScreen(),
          GRoute.progressTracker: (_) => ProgressPhotoScreen(),
          GRoute.gymNearYou: (_) => GymNearListScreen(),
          GRoute.goalsScreen: (_) => GoalsScreen(),
          GRoute.badgeScreen: (_) => BadgesScreen(),
          GRoute.stepsScreen: (_) => StepsScreen(),
          GRoute.testerScreen: (_) => NotificationTester(),
          GRoute.mealAddingScreen:(_)=> MealAddingScreen(),
          GRoute.resultScreen:(_)=> ResultScreen(),
          GRoute.forgotScreen:(_)=> ForgotPasswordScreen(),
        },
      ),
    );
  }
}

void requestNotificationPermission() async {
  // Check if the app is running on Android 13+.
  if (await Permission.notification.isDenied ||
      await Permission.notification.isPermanentlyDenied) {
    // Request the notification permission.
    final status = await Permission.notification.request();

    if (status.isGranted) {
      print('Notification permission granted.');
    } else {
      print('Notification permission denied.');
    }
  } else {
    print('Notification permission already granted or not required.');
  }
}
