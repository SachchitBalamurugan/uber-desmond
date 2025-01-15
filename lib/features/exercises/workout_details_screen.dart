import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthapp/common/widgets/appbar/t_app_bar.dart';
import 'package:healthapp/features/exercises/video_screen.dart';
import 'package:healthapp/providers/workout_provider.dart';
import 'package:healthapp/utils/constants/colors.dart';
import 'package:healthapp/utils/constants/image_strings.dart';
import 'package:healthapp/utils/devices/device_utility.dart';
import 'package:healthapp/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/sizes.dart';

class WorkoutDetailsScreen extends StatelessWidget {
  const WorkoutDetailsScreen(
      {super.key, this.dateTime = '', this.workoutId = ''});
  final String dateTime;
  final String workoutId;
  @override
  Widget build(BuildContext context) {
    final workoutPro = Provider.of<WorkoutViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Section
          WorkoutImageSection(),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(TSizes.defaultSpaceSm),
              height: TDeviceUtils.getScreenHeight(context) * 0.7,
              width: TDeviceUtils.getScreenWidth(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(TSizes.borderRadiusXL),
                  right: Radius.circular(TSizes.borderRadiusXL),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full body Workout',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1 Exercise | 25 mins | 250 Calories Burnt',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    WorkoutReusableCard(
                      leadingIcon: Iconsax.calendar_1,
                      title: "Schedule Workout",
                      dateTime: THelperFunctions.formatDateTime(dateTime),
                      trailingIcon: Icons.arrow_forward_ios,
                      bgColor: Color(0xFF9DCEFF),
                    ),
                    WorkoutReusableCard(
                      leadingIcon: Iconsax.filter,
                      title: "Difficulty",
                      dateTime: "Beginner",
                      trailingIcon: Icons.arrow_forward_ios,
                      bgColor: Color(0xFFEEA4CE),
                    ),
                    Text(
                      'You\'ll Need',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        _buildItem('Dumbbell'),
                        SizedBox(width: 16),
                        _buildItem('Skipping Rope'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Exercises',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    _buildExerciseList(context),
                    SizedBox(height: 70),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 30,
              right: 30,
              left: 30,
              child: ElevatedButton(
                  onPressed: () => workoutPro.markWorkoutAsCompletedAndMove(
                      context, workoutId, dateTime),
                  child: Text("Complete"))),
          if (workoutPro.isCompleting)
            Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6)
                  ),
                    height: TDeviceUtils.getScreenHeight(context),
                    width: TDeviceUtils.getScreenWidth(context),
                    child: Center(child: CircularProgressIndicator())))
        ],
      ),
    );
  }

  Widget _buildItem(String title) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.fitness_center),
        ),
        SizedBox(height: 8),
        Text(title),
      ],
    );
  }

  Widget _buildExerciseList(BuildContext context) {
    List<Map<String, String>> exercises = [
      {'name': 'Warm-up', 'time': '00:30', 'video': 'assets/warm_up.mp4'},
      {
        'name': 'Jumping Jack',
        'time': '1m',
        'video': 'assets/jumping_jack.mp4'
      },
      {'name': 'Skipping', 'time': '00:30', 'video': 'assets/skipping.mp4'},
      {'name': 'Squats', 'time': '00:30', 'video': 'assets/squats.mp4'},
      {'name': 'Arm Raises', 'time': '00:30', 'video': 'assets/arm_raises.mp4'},
      {
        'name': 'Incline Push-ups',
        'time': '00:30',
        'video': 'assets/incline_pushups.mp4'
      },
      {'name': 'Push-ups', 'time': '00:30', 'video': 'assets/pushups.mp4'},
    ];

    return Column(
      children: exercises.map((exercise) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoScreen(
                  title: exercise['name']!,
                  videoPath: exercise['video']!,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFFF5F6FA),
                  child: Icon(Icons.play_arrow),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    exercise['name']!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentItem(String name, IconData icon) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 16.0),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 30, color: Colors.blue),
        ),
        SizedBox(height: 8),
        Text(name),
      ],
    );
  }

  Widget _buildExerciseSet(String title, List<Widget> exercises) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...exercises,
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildExerciseItem(String name, String details) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade50,
        child: Icon(Icons.fitness_center, color: Colors.blue),
      ),
      title: Text(name),
      trailing: Text(details),
    );
  }
}

class WorkoutReusableCard extends StatelessWidget {
  const WorkoutReusableCard({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.dateTime,
    required this.trailingIcon,
    required this.bgColor,
  });
  final IconData leadingIcon;
  final String title;
  final String dateTime;
  final IconData trailingIcon;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: TSizes.defaultSpaceSm),
      padding: EdgeInsets.all(TSizes.sm),
      width: TDeviceUtils.getScreenWidth(context) * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          color: bgColor.withOpacity(0.2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            leadingIcon,
            color: TColors.darkGrey,
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: TColors.darkGrey),
          ),
          Text(dateTime,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: TColors.darkGrey)),
          Icon(
            trailingIcon,
            color: TColors.darkGrey,
            size: 17,
          )
        ],
      ),
    );
  }
}

class WorkoutImageSection extends StatelessWidget {
  const WorkoutImageSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)])),
            height: TDeviceUtils.getScreenHeight(context) * 0.4,
            width: TDeviceUtils.getScreenWidth(context),
          ),
          Positioned(
            height: TDeviceUtils.getScreenHeight(context) * 0.4,
            width: TDeviceUtils.getScreenWidth(context),
            child: Center(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    horizontal: TDeviceUtils.getScreenWidth(context) * 0.3,
                    vertical: TDeviceUtils.getScreenHeight(context) * 0.3),
                height: TDeviceUtils.getScreenHeight(context) * 0.3,
                width: TDeviceUtils.getScreenHeight(context) * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(300),
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
          Positioned(
            height: TDeviceUtils.getScreenHeight(context) * 0.4,
            width: TDeviceUtils.getScreenWidth(context),
            child: Container(
              alignment: Alignment.center,
              height: 400,
              child: Center(
                child: SvgPicture.asset(
                  TSvgPath.men10, // Replace with your image path
                  height: 300,
                ),
              ),
            ),
          ),
          TAppBar(
            shadowColorTrailing: Color(0xFF92A3FD),
            shadowColorLeading: Color(0xFF92A3FD),
          ),
        ],
      ),
    );
  }
}
