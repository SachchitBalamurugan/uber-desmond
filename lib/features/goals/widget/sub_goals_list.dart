import 'package:flutter/material.dart';
import 'package:healthapp/features/goals/widget/progress_widget.dart';
import 'package:healthapp/providers/get_goals_provider.dart';
import 'package:provider/provider.dart';

import '../../../providers/goal_provider.dart';

class SubGoalsListCustom extends StatelessWidget {
  const SubGoalsListCustom({super.key});

  @override
  Widget build(BuildContext context) {
    final goalProvider = context.watch<GetGoalsProvider>(); // Using watch instead of read

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: goalProvider.getSubGoalsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No sub-goals available'));
        }

        final subGoals = snapshot.data!;

        // Log the data to inspect its structure
        debugPrint('SubGoals data: $subGoals');

        return Expanded(
          child: ListView.builder(
            itemCount: subGoals.length,
            itemBuilder: (context, index) {
              final subGoal = subGoals[index];

              // Ensure 'progress' is a double or fallback to 0.0
              final progress = _getProgressValue(subGoal);
              final title = _getTitle(subGoal, index);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ProgressBar(
                    progress: progress,
                    color: Colors.pink,
                  ),
                  const SizedBox(height: 16.0),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // Method to safely handle the title value
  String _getTitle(Map<String, dynamic> subGoal, int index) {
    try {
      // Check if 'title' exists and is a string, if not use default title
      if (subGoal['title'] is String) {
        return subGoal['title'] ?? 'Sub-goal ${index + 1}';
      }
    } catch (e) {
      debugPrint("Error parsing title: $e");
    }
    return 'Sub-goal ${index + 1}'; // Default if error or not found
  }

  // Method to safely handle the progress value
  double _getProgressValue(Map<String, dynamic> subGoal) {
    try {
      // Check if 'progress' exists and is a number, if not return 0.0
      if (subGoal['progress'] is num) {
        return (subGoal['progress'] as num).toDouble();
      }
    } catch (e) {
      debugPrint("Error parsing progress: $e");
    }
    return 0.0; // Default if error or not found
  }
}
