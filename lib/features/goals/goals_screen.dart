// goals_screen.dart
import 'package:flutter/material.dart';
import 'package:healthapp/features/goals/widget/add_goal_bottom_sheet.dart';
import 'package:healthapp/features/goals/widget/progress_widget.dart';
import 'package:healthapp/features/goals/widget/sub_goals_list.dart';
import 'package:provider/provider.dart';

import '../../providers/get_goals_provider.dart';
import '../../providers/goal_provider.dart';
import '../meal_planner/widgets/t_search_field.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final saveGoalsProvider = context.watch<SaveGoalProvider>();
    final getGoalsProvider = context.watch<GetGoalsProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Goals',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TSearchField(
              hintText: "Search Goal",
              controller: getGoalsProvider.searchController,
              onChanged: getGoalsProvider.searchGoalByName,
            ),
            const SizedBox(height: 16.0),

            // Search Results Section
            if (getGoalsProvider.searchController.text.isNotEmpty) ...[
              const Text(
                'Search Results',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16.0),
              if (getGoalsProvider.isSearching)
                const Center(child: CircularProgressIndicator())
              else if (getGoalsProvider.filteredGoals.isEmpty)
                const Center(
                  child: Text(
                    'No goals found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: getGoalsProvider.filteredGoals.length,
                    itemBuilder: (context, index) {
                      final goal = getGoalsProvider.filteredGoals[index];
                      double goalProgress = (goal['data']['progress'] as num).toDouble();
                      return GoalProgressCard(
                        title: goal['goalName'],
                        progress: goalProgress,
                      );
                    },
                  ),
                ),
            ] else ...[
              const Text(
                'Goals',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  4,
                      (index) => Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.blue[100] : Colors.pink[100],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Goal Overall Progress',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8.0),
              ProgressBar(
                progress: getGoalsProvider.overallProgress,
                color: Colors.blue,
              ),
              const SizedBox(height: 16.0),
              SubGoalsListCustom(),
              const SizedBox(height: 16.0),
            ],

            // Bottom Buttons (Hidden if search field is active)
            if (getGoalsProvider.searchController.text.isEmpty) ...[
              ElevatedButton(
                onPressed: () => saveGoalsProvider.exportGoalsToPDF(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('Export All Goals Progress'),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () => saveGoalsProvider.shareGoalsProgress(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('Share Goal Progress'),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () =>
                    _showCreateGoalBottomSheet(context, saveGoalsProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('Create Custom Goals'),
              ),
            ],
          ],
        ),
      ),
    );
  }


  void _showCreateGoalBottomSheet(
      BuildContext context, SaveGoalProvider goalProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return CreateGoalBottomSheet(
          goalProvider: goalProvider,
        );
      },
    );
  }
}

class GoalProgressCard extends StatelessWidget {
  const GoalProgressCard({super.key, required this.title, required this.progress});
  final String title;
  final double progress;

  @override
  Widget build(BuildContext context) {
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
  }
}
