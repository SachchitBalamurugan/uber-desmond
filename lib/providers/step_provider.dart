import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepData {
  final String month;
  final double steps;
  final double calories;
  final double minutes;

  StepData({
    required this.month,
    required this.steps,
    required this.calories,
    required this.minutes,
  });

  Map<String, dynamic> toJson() => {
    'month': month,
    'steps': steps,
    'calories': calories,
    'minutes': minutes,
  };

  factory StepData.fromJson(Map<String, dynamic> json) => StepData(
    month: json['month'],
    steps: json['steps'].toDouble(),
    calories: json['calories'].toDouble(),
    minutes: json['minutes'].toDouble(),
  );
}

class StepsProvider with ChangeNotifier {
  static const String STEPS_KEY = 'daily_steps';
  static const String LAST_RESET_KEY = 'last_reset_date';

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  int _currentDaySteps = 0;
  int _lastSavedSteps = 0;
  int _baseSteps = 0;
  int _currentCalories = 0;
  int _currentMinutes = 0;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;
  String _status = 'unknown';
  bool _isTracking = false;

  List<StepData> _stepHistory = [];

  // Getters
  int get currentSteps => _currentDaySteps;
  int get caloriesBurned => _currentCalories;
  int get activeMinutes => _currentMinutes;
  List<StepData> get stepHistory => _stepHistory;
  bool get isTracking => _isTracking;
  String get status => _status;

  StepsProvider() {
    initPlatformState();
    _loadTodaySteps();
    _loadStepHistory();
    _setupRealtimeSync();
  }

  void _setupRealtimeSync() {
    _database
        .child('users')
        .child(_userId!)
        .child('daily_steps')
        .child(_getTodayKey())
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        _currentDaySteps = data['steps'] as int;
        _currentCalories = data['calories'] as int;
        _currentMinutes = data['minutes'] as int;
        notifyListeners();
      }
    });

    _database
        .child('users')
        .child(_userId!)
        .child('step_history')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final historyData = event.snapshot.value as Map;
        _stepHistory = historyData.values
            .map((e) => StepData.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        notifyListeners();
      }
    });
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadTodaySteps() async {
    try {
      final snapshot = await _database
          .child('users')
          .child(_userId!)
          .child('daily_steps')
          .child(_getTodayKey())
          .get();

      if (snapshot.value != null) {
        final data = snapshot.value as Map;
        _currentDaySteps = data['steps'] as int;
        _baseSteps = data['base_steps'] as int;
        _currentCalories = data['calories'] as int;
        _currentMinutes = data['minutes'] as int;
        notifyListeners();
      }
    } catch (e) {
      print('Error loading today\'s steps: $e');
    }
  }

  Future<void> _loadStepHistory() async {
    try {
      final snapshot = await _database
          .child('users')
          .child(_userId!)
          .child('step_history')
          .orderByKey()
          .limitToLast(7)
          .get();

      if (snapshot.value != null) {
        final historyData = snapshot.value as Map;
        _stepHistory = historyData.values
            .map((e) => StepData.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading step history: $e');
    }
  }

  void initPlatformState() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _initPedometer();
    } else {
      _status = 'Permission denied';
      notifyListeners();
    }
  }

  void _initPedometer() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _stepCountStream = Pedometer.stepCountStream;

    _pedestrianStatusStream.listen(
      onPedestrianStatusChanged,
      onError: onPedestrianStatusError,
    );

    _stepCountStream.listen(
      onStepCount,
      onError: onStepCountError,
    );

    _isTracking = true;
    notifyListeners();
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    _status = event.status;
    notifyListeners();
  }

  void onPedestrianStatusError(error) {
    _status = 'Pedestrian Status error: $error';
    notifyListeners();
  }

  void onStepCount(StepCount event) async {
    if (_lastSavedSteps == 0) {
      _lastSavedSteps = event.steps;
      if (_baseSteps == 0) {
        _baseSteps = event.steps;
        await saveTodaySteps();
      }
    }

    final newSteps = event.steps - _baseSteps;
    if (newSteps != _currentDaySteps) {
      _currentDaySteps = newSteps;
      // Calculate calories (approximately 0.04 calories per step)
      _currentCalories = (_currentDaySteps * 0.04).round();
      // Calculate minutes (approximately 0.008 minutes per step)
      _currentMinutes = (_currentDaySteps * 0.008).round();
      await saveTodaySteps();
      _updateStepHistory();
    }
  }

  void onStepCountError(error) {
    _status = 'Step Count error: $error';
    notifyListeners();
  }

  Future<void> saveTodaySteps() async {
    try {
      if (_userId != null) {
        await _database
            .child('users')
            .child(_userId!)
            .child('daily_steps')
            .child(_getTodayKey())
            .set({
          'steps': _currentDaySteps,
          'base_steps': _baseSteps,
          'calories': _currentCalories,
          'minutes': _currentMinutes,
          'last_updated': ServerValue.timestamp,
        });
        incrementSubGoalProgress();
      }
    } catch (e) {
      print('Error saving steps: $e');
    }
  }


  Future<void> incrementSubGoalProgress() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        String userUid = user.uid;
        String todayKey = _getTodayKey();

        // Reference to today's steps
        DatabaseReference stepsRef = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userUid)
            .child('daily_steps')
            .child(todayKey);

        // Reference to subGoals
        DatabaseReference subGoalsRef = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userUid)
            .child('subGoals');

        // Get last processed steps from subGoals metadata
        DatabaseReference metadataRef = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userUid)
            .child('subGoals_metadata');

        // Get today's steps
        DatabaseEvent stepsEvent = await stepsRef.once();
        if (stepsEvent.snapshot.exists) {
          Map<Object?, Object?>? stepsData = stepsEvent.snapshot.value as Map<Object?, Object?>?;
          int currentSteps = (stepsData?['steps'] as num?)?.toInt() ?? 0;

          // Get last processed steps
          DatabaseEvent metadataEvent = await metadataRef.child('last_processed_steps').once();
          int lastProcessedSteps = 0;
          if (metadataEvent.snapshot.exists) {
            lastProcessedSteps = (metadataEvent.snapshot.value as num?)?.toInt() ?? 0;
          }

          // Calculate new steps since last update
          int newSteps = currentSteps - lastProcessedSteps;

          // Only process if there are new steps
          if (newSteps > 0) {
            // Calculate progress increment for new steps only
            // 0.000033 per step, so at 6000 steps we get 0.2
            double progressIncrement = newSteps * 0.00003;

            // Get current subGoal data
            DatabaseEvent subGoalsEvent = await subGoalsRef.once();
            if (subGoalsEvent.snapshot.exists) {
              Map<Object?, Object?>? subGoalsData = subGoalsEvent.snapshot.value as Map<Object?, Object?>?;

              // Update each subGoal's progress
              subGoalsData?.forEach((goalName, goalData) async {
                if (goalData is Map<Object?, Object?>) {
                  String goalNameStr = goalName as String;
                  double currentProgress = (goalData['progress'] as num?)?.toDouble() ?? 0.0;

                  // Add increment from new steps only
                  double updatedProgress = currentProgress + progressIncrement;

                  // Ensure progress doesn't exceed 1.0 (100%)
                  updatedProgress = updatedProgress.clamp(0.0, 1.0);

                  // Update the progress for this subGoal
                  await subGoalsRef.child(goalNameStr).update({
                    'progress': updatedProgress,
                  });

                  debugPrint('Goal: $goalNameStr, New Steps: $newSteps, Increment: $progressIncrement, Updated Progress: $updatedProgress');
                }
              });

              // Update last processed steps
              await metadataRef.update({
                'last_processed_steps': currentSteps,
                'last_updated': ServerValue.timestamp,
              });
            }
          }
        }
      } catch (e) {
        print('Error updating progress for subgoals: $e');
      }
    }
  }

  void _updateStepHistory() {
    final now = DateTime.now();
    final month = '${now.month}/${now.day}';

    final stepData = StepData(
      month: month,
      steps: _currentDaySteps / 10000,
      calories: _currentCalories / 1000,
      minutes: _currentMinutes / 60, // Normalize to hours
    );

    try {
      _database
          .child('users')
          .child(_userId!)
          .child('step_history')
          .child(_getTodayKey())
          .set(stepData.toJson());
    } catch (e) {
      print('Error updating step history: $e');
    }
  }

  Future<void> checkAndResetDaily() async {
    final today = _getTodayKey();
    final prefs = await SharedPreferences.getInstance();
    final lastResetDate = prefs.getString(LAST_RESET_KEY);

    if (lastResetDate != today) {
      _baseSteps = _lastSavedSteps;
      _currentDaySteps = 0;
      _currentCalories = 0;
      _currentMinutes = 0;
      await saveTodaySteps();
      await prefs.setString(LAST_RESET_KEY, today);
    }
  }

  @override
  void dispose() {
    _isTracking = false;
    super.dispose();
  }
}