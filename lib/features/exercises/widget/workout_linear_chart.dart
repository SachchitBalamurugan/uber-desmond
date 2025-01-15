import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WorkoutTrackerLineChart extends StatelessWidget {
  final Map<String, List<dynamic>> workoutData;

  const WorkoutTrackerLineChart({super.key, required this.workoutData});

  @override
  Widget build(BuildContext context) {
    final spots = _generateSpots(workoutData);
    final maxY = _getMaxY(workoutData); // Calculate the max Y dynamically

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false), // Hide unnecessary grid lines
          lineBarsData: [
            LineChartBarData(
              isCurved: false,
              spots: spots,
              color: Colors.blue,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        days[value.toInt()],
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                interval: 1,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          minX: 0,
          maxX: 6, // Ensure only one week (0 to 6) is displayed
          minY: 0,
          maxY: maxY, // Dynamically set the max Y based on data
        ),
      ),
    );
  }

  List<FlSpot> _generateSpots(Map<String, List<dynamic>> data) {
    // Map the workout data to FlSpot points for the week
    const weekDays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    final now = DateTime.now();
    final spots = <FlSpot>[];

    // Loop through each day of the current week
    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: i));
      final dayName = weekDays[day.weekday % 7]; // Get day name

      // Aggregate the workouts by getting the list length
      final value = data[dayName]?.length ?? 0; // Default to 0 if no data for the day
      spots.add(FlSpot(6 - i.toDouble(), value.toDouble())); // Reverse X for chronological order
    }

    return spots;
  }

  double _getMaxY(Map<String, List<dynamic>> data) {
    // Find the day with the maximum workouts
    int maxWorkouts = 0;

    data.forEach((day, workouts) {
      maxWorkouts = maxWorkouts > workouts.length ? maxWorkouts : workouts.length;
    });

    // Return a slightly higher value than the maximum for better visualization
    return (maxWorkouts + 4).toDouble();
  }
}
