import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/common/widgets/text/display_title.dart';
import 'package:healthapp/components/t_elevated_tile.dart';
import 'package:healthapp/features/exercises/widget/workout_linear_chart.dart';
import 'package:healthapp/features/exercises/workout_details_screen.dart';
import 'package:healthapp/providers/step_provider.dart';
import 'package:healthapp/providers/workout_data_provider.dart';
import 'package:healthapp/utils/devices/device_utility.dart';
import 'package:healthapp/utils/route_const.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../exercises/widget/daily_workout_button.dart';
import '../exercises/widget/training_option_card.dart';
import '../exercises/widget/workout_card.dart';

class WorkoutTrackerScreen extends StatelessWidget {
  const WorkoutTrackerScreen({super.key});


  String formatDateTime(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      final now = DateTime.now();
      final isToday = date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;

      if (isToday) {
        return 'Today, ${DateFormat('hh:mm a').format(date)}';
      } else {
        return DateFormat('MMMM d, hh:mm a')
            .format(date); // e.g., "January 5, 07:00 AM"
      }
    } catch (e) {
      return 'Invalid date';
    }
  }



  @override
  Widget build(BuildContext context) {
    // final chartData =  Provider.of<WorkoutDataProvider>(context).workoutData;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Workout Tracker",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Graph Section
              Consumer<WorkoutDataProvider>(
                builder: (context,chartData ,child) {
                  return WorkoutTrackerLineChart(
                    workoutData: chartData.workoutData,
                    // days: chartData.days,
                  );
                }
              ),
              const SizedBox(height: 20),
              // Daily Workout Section
              DailyWorkoutScheduledButton(),
              TElevatedTile(onCheckPressed: ()=> Navigator.pushNamed(context, GRoute.badgeScreen), title: "Badges",buttonTitle: "Check"),
              TElevatedTile(onCheckPressed: (){
                Navigator.pushNamed(context, GRoute.stepsScreen);
                Provider.of<StepsProvider>(context,listen: false).saveTodaySteps();
              }, title: "Today Steps",buttonTitle: "Check"),
              const SizedBox(height: 20),
              // Upcoming Workouts Section
              DisplayTitleMd(title: "Upcoming Workout"),
              Consumer<WorkoutViewModel>(
                builder: (context, workoutViewModel, _) {
                  if (workoutViewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final schedules = workoutViewModel.workoutSchedules;

                  if (schedules.isEmpty) {
                    return const Center(
                      child: Text('No workouts scheduled.'),
                    );
                  }

                  // Convert to a list and sort by date in ascending order (most recent first)
                  final sortedSchedules = schedules.keys.toList()
                    ..sort((a, b) {
                      final aDate = DateTime.parse(schedules[a]![0]['scheduledDateTime']);
                      final bDate = DateTime.parse(schedules[b]![0]['scheduledDateTime']);
                      return aDate.compareTo(bDate); // Ascending order
                    });
                  return SizedBox(
                    height: 200,
                    width: TDeviceUtils.getScreenWidth(context) * 0.9,
                    child: ListView.builder(
                      itemCount: sortedSchedules.length,
                      itemBuilder: (context, index) {
                        final date = sortedSchedules[index];
                        final workouts = schedules[date]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...workouts.map((workout) {
                              final workoutName = workout['workoutName'];
                              final workoutId = workout['workoutId'];

                              final scheduledDateTime = workout['scheduledDateTime'];
                              final formattedDate = formatDateTime(scheduledDateTime);

                              return WorkoutCard(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutDetailsScreen(
                                      dateTime: scheduledDateTime,
                                      workoutId: workoutId,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {},
                                title: workoutName,
                                date: formattedDate,
                                isActive: true, // This can be dynamic if needed
                              );
                            }),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),


              const SizedBox(height: 20),
              // Training Options Section
              Text(
                "What Do You Want to Train",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              TrainingOptionCard(
                title: "Full body Workout",
                exercises: "11 Exercises | 32mins",
              ),
              TrainingOptionCard(
                title: "Lowbody Workout",
                exercises: "12 Exercises | 40mins",
              ),
              TrainingOptionCard(
                title: "AB Workout",
                exercises: "14 Exercises | 20mins",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
