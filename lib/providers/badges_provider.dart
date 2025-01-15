import 'package:flutter/material.dart';
import '../services/badges_repository.dart';
import 'package:rxdart/rxdart.dart';

class BadgeModel {
  final String id;
  final String name;
  final String description;
  final String iconPath; // Path to the badge icon (asset or URL)
  final bool isUnlocked; // Whether the badge is unlocked
  final DateTime? unlockedAt; // When the badge was unlocked (null if not unlocked)
  final double progress; // Progress toward unlocking the badge (0.0 to 1.0)

  BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
  });

  // Convert BadgeModel to JSON for storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'iconPath': iconPath,
    'isUnlocked': isUnlocked,
    'unlockedAt': unlockedAt?.toIso8601String(),
    'progress': progress,
  };

  // Create BadgeModel from JSON
  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconPath: json['iconPath'],
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
      progress: (json['progress'] ?? 0.0).toDouble(),
    );
  }
}
extension BadgeModelExtension on BadgeModel {
  BadgeModel copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    bool? isUnlocked,
    DateTime? unlockedAt,
    double? progress,
  }) {
    return BadgeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
    );
  }
}



class BadgeProvider with ChangeNotifier {
  final List<BadgeModel> _badges = [
    // Water intake badges
    BadgeModel(
        id: 'hydration_hero',
        name: 'Hydration Hero',
        description: 'For meeting the daily water intake goal.',
        iconPath: 'Iconsax.drop'),
    BadgeModel(
        id: 'water_warrior',
        name: 'Water Warrior',
        description: 'For completing a week of consistent hydration.',
        iconPath: 'Iconsax.calendar_check'),
    BadgeModel(
        id: 'aqua_achiever',
        name: 'Aqua Achiever',
        description: 'For surpassing the water intake goal by 20%.',
        iconPath: 'Iconsax.trophy'),
    BadgeModel(
        id: 'ocean_champion',
        name: 'Ocean Champion',
        description: 'For consistently hitting water intake goals for a month.',
        iconPath: 'Iconsax.award'),
    BadgeModel(
        id: 'h2overachiever',
        name: 'H2Overachiever',
        description: 'For drinking double the daily recommended amount in a day.',
        iconPath: 'Iconsax.fire'),

    // Step counting badges
    BadgeModel(
        id: 'step_starter',
        name: 'Step Starter',
        description: 'For taking 1,000 steps in a day.',
        iconPath: 'Iconsax.walk'),
    BadgeModel(
        id: 'stride_seeker',
        name: 'Stride Seeker',
        description: 'For hitting 5,000 steps in a day.',
        iconPath: 'Iconsax.walk'),
    BadgeModel(
        id: 'walking_warrior',
        name: 'Walking Warrior',
        description: 'For walking 10,000 steps in a day.',
        iconPath: 'Iconsax.sneaker'),
    BadgeModel(
        id: 'mile_master',
        name: 'Mile Master',
        description: 'For walking 5 miles in a single day.',
        iconPath: 'Iconsax.map'),
    BadgeModel(
        id: 'trailblazer',
        name: 'Trailblazer',
        description: 'For completing 100,000 steps in a week.',
        iconPath: 'Iconsax.route'),

    // Full-body workout badges
    BadgeModel(
        id: 'workout_rookie',
        name: 'Workout Rookie',
        description: 'For completing the first full-body workout.',
        iconPath: 'Iconsax.dumbbell'),
    BadgeModel(
        id: 'fitness_finisher',
        name: 'Fitness Finisher',
        description: 'For completing 5 full-body workouts.',
        iconPath: 'Iconsax.dumbbell'),
    BadgeModel(
        id: 'sweat_specialist',
        name: 'Sweat Specialist',
        description: 'For completing 10 full-body workouts.',
        iconPath: 'Iconsax.body'),
    BadgeModel(
        id: 'body_sculptor',
        name: 'Body Sculptor',
        description: 'For completing 50 full-body workouts.',
        iconPath: 'Iconsax.star'),
    BadgeModel(
        id: 'champion_of_change',
        name: 'Champion of Change',
        description: 'For completing 100 full-body workouts.',
        iconPath: 'Iconsax.trophy'),

    // Consistency and milestone badges
    BadgeModel(
        id: 'daily_devotee',
        name: 'Daily Devotee',
        description: 'For logging activity every day for a week.',
        iconPath: 'Iconsax.calendar_check'),
    BadgeModel(
        id: 'habit_hero',
        name: 'Habit Hero',
        description: 'For logging activity every day for a month.',
        iconPath: 'Iconsax.award'),
    BadgeModel(
        id: 'fitness_streaker',
        name: 'Fitness Streaker',
        description: 'For maintaining a workout streak for 7 days.',
        iconPath: 'Iconsax.flash'),
    BadgeModel(
        id: 'persistence_pro',
        name: 'Persistence Pro',
        description: 'For staying active consistently for 3 months.',
        iconPath: 'Iconsax.medal'),
    BadgeModel(
        id: 'epic_achiever',
        name: 'Epic Achiever',
        description: 'For reaching 1 year of consistent fitness activity.',
        iconPath: 'Iconsax.medal'),

    // Special achievements
    BadgeModel(
        id: 'morning_mover',
        name: 'Morning Mover',
        description: 'For completing a workout before 8 AM.',
        iconPath: 'Iconsax.sun'),
    BadgeModel(
        id: 'night_owl_ninja',
        name: 'Night Owl Ninja',
        description: 'For completing a workout after 9 PM.',
        iconPath: 'Iconsax.moon'),
    BadgeModel(
        id: 'weekend_warrior',
        name: 'Weekend Warrior',
        description: 'For working out every weekend for a month.',
        iconPath: 'Iconsax.calendar'),
    BadgeModel(
        id: 'first_timer',
        name: 'First Timer',
        description: 'For completing the first-ever fitness milestone.',
        iconPath: 'Iconsax.trophy'),
    BadgeModel(
        id: 'goal_getter',
        name: 'Goal Getter',
        description: 'For achieving the first weight or fitness goal.',
        iconPath: 'Iconsax.target'),

    // Community and sharing badges
    BadgeModel(
        id: 'team_player',
        name: 'Team Player',
        description: 'For joining a group workout session.',
        iconPath: 'Iconsax.people'),
    BadgeModel(
        id: 'social_star',
        name: 'Social Star',
        description: 'For sharing your progress on social media.',
        iconPath: 'Iconsax.share'),
    BadgeModel(
        id: 'motivation_master',
        name: 'Motivation Master',
        description: 'For inspiring others by achieving personal goals.',
        iconPath: 'Iconsax.inspire'),
  ];
  final BadgeRepository _repository = BadgeRepository();

  List<BadgeModel> get badges => _badges;

  Stream<List<BadgeModel>> badgeStream(
) {
    final stepsStream = _repository.streamDailySteps();
    final waterIntakeStream = _repository.streamWaterIntake();
    final workoutsStream = _repository.streamCompletedWorkouts();
    return Rx.combineLatest3<int, int, List<String>, List<BadgeModel>>(
      stepsStream,
      waterIntakeStream,
      workoutsStream,
          (steps, waterIntake, workouts) {
        return _badges.map((badge) {
          double progress = 0.0;
          bool isUnlocked = false;

          switch (badge.id) {
            case 'hydration_hero':
              final progress = (waterIntake / 2000).clamp(0.0, 1.0);
              return badge.copyWith(progress: progress, isUnlocked: progress >= 1.0);
            case 'water_warrior':
              final progress = (waterIntake / 7).clamp(0.0, 1.0);
              return badge.copyWith(progress: progress, isUnlocked: progress >= 1.0);
            case 'aqua_achiever':
              final progress = (waterIntake / 2400).clamp(0.0, 1.0);
              return badge.copyWith(progress: progress, isUnlocked: progress >= 1.0);
            case 'ocean_champion':
              final progress = (waterIntake / 30).clamp(0.0, 1.0);
              return badge.copyWith(progress: progress, isUnlocked: progress >= 1.0);
            case 'h2overachiever':
              final progress = (waterIntake / 4000).clamp(0.0, 1.0);
              return badge.copyWith(progress: progress, isUnlocked: progress >= 1.0);

          // Steps counting badges
            case 'step_starter':
              final progress = (steps / 1000).clamp(0.0, 1.0);
              return badge.copyWith(progress: progress, isUnlocked: progress >= 1.0);
            case 'stride_seeker':
              final progress = (steps / 5000).clamp(0.0, 1.0);
              return badge.copyWith(progress: progress, isUnlocked: progress >= 1.0);
            case 'walking_warrior':
              final progress = (steps / 10000).clamp(0.0, 1.0);
              return badge.copyWith(progress: progress, isUnlocked: progress >= 1.0);
            case 'mile_master':
              final progress = (steps / 5.0).clamp(0.0, 1.0);
              return badge.copyWith(progress: progress, isUnlocked: progress >= 1.0);
            case 'trailblazer':
              final progress = (steps / 100000).clamp(0.0, 1.0);
              return badge.copyWith(progress: progress, isUnlocked: progress >= 1.0);

          // Full-body workout badges
            case 'workout_rookie':
              final progress = (workouts.length / 1).clamp(0.0, 1.0);
              return badge.copyWith(progress: progress, isUnlocked: progress >= 1.0);
            case 'fitness_finisher':
              final progress = (workouts.length / 5).clamp(0.0, 1.0);
              return badge.copyWith(progress: progress, isUnlocked: progress >= 1.0);
            case 'sweat_specialist':
              final progress = (workouts.length / 10).clamp(0.0, 1.0);
              return badge.copyWith(progress: progress, isUnlocked: progress >= 1.0);
            case 'body_sculptor':
              final progress = (workouts.length / 50).clamp(0.0, 1.0);
              return badge.copyWith(progress: progress, isUnlocked: progress >= 1.0);
            case 'champion_of_change':
              final progress = (workouts.length / 100).clamp(0.0, 1.0);
              return badge.copyWith(progress: progress, isUnlocked: progress >= 1.0);

            default:
              return badge;
          }

          return badge.copyWith(progress: progress, isUnlocked: isUnlocked);
        }).toList();
      },
    );
  }
}

// // // badge_model.dart
// // import 'package:flutter/material.dart';
// //
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// class BadgeModel {
//   final String title;
//   final String subtitle;
//   final double progress;
//
//   BadgeModel({
//     required this.title,
//     required this.subtitle,
//     required this.progress,
//   });
// }
//
//
// class BadgesProvider with ChangeNotifier {
//   final List<BadgeModel> _badges = [];
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();
//
//   List<BadgeModel> get badges => _badges;
//
//   // Fetch badges from Firebase
//   Future<void> fetchUserBadges(String userUid) async {
//     try {
//       DatabaseEvent event = await _database
//           .child('users')
//           .child(userUid)
//           .child('subGoals')
//           .once();
//
//       if (event.snapshot.value != null) {
//         final subGoals = Map<String, dynamic>.from(event.snapshot.value as Map);
//
//         _badges.clear(); // Clear existing badges
//
//         subGoals.forEach((key, value) {
//           final goal = Map<String, dynamic>.from(value as Map);
//           double progress = (goal['progress'] ?? 0.0).toDouble();
//
//           _badges.add(
//             BadgeModel(
//               title: goal['goalName'] ?? 'Unknown Goal',
//               subtitle: progress == 1.0 ? 'Completed' : 'In Progress',
//               progress: progress,
//             ),
//           );
//         });
//
//         notifyListeners();
//       }
//     } catch (error) {
//       print('Error fetching badges: $error');
//     }
//   }
//
//   void updateBadgeProgress(int index, double progress) {
//     if (index >= 0 && index < _badges.length) {
//       _badges[index] = BadgeModel(
//         title: _badges[index].title,
//         subtitle: progress == 1.0 ? 'Completed' : 'In Progress',
//         progress: progress,
//       );
//       notifyListeners();
//     }
//   }
// }
// // // badges_provider.dart
// //
// // class BadgesProvider with ChangeNotifier {
// //   final List<BadgeModel> _badges = [
// //     BadgeModel(title: 'First Goal', subtitle: 'Completed', progress: 0.92),
// //     BadgeModel(title: 'Completed 2', subtitle: 'Goals', progress: 0.85),
// //     BadgeModel(title: 'Water Champion', subtitle: 'Drink 15 cups', progress: 0.95),
// //     BadgeModel(title: 'Workout Master', subtitle: '20 hours', progress: 0.88),
// //     BadgeModel(title: 'Healthy Party', subtitle: '2500 Calories per day', progress: 0.90),
// //     BadgeModel(title: 'Hot Squad', subtitle: 'Burn 5000 Calories', progress: 0.82),
// //   ];
// //
// //   List<BadgeModel> get badges => _badges;
// //
// //   void updateBadgeProgress(int index, double progress) {
// //     if (index >= 0 && index < _badges.length) {
// //       _badges[index] = BadgeModel(
// //         title: _badges[index].title,
// //         subtitle: _badges[index].subtitle,
// //         progress: progress,
// //       );
// //       notifyListeners();
// //     }
// //   }
// // }
// // badges_provider.dart
