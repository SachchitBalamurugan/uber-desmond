// steps_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../providers/step_provider.dart';
import '../home/home_screen_widgets/stat_chart.dart';
import '../home/home_screen_widgets/stat_row.dart';
import '../home/home_screen_widgets/step_progress_painter.dart';

class StepsScreen extends StatelessWidget {
  const StepsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            Provider.of<StepsProvider>(context,listen: false).saveTodaySteps();
          },
        ),
        title: const Text(
          'Steps',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<StepsProvider>(
        builder: (context, stepsProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Consumer<StepsProvider>(
                    builder: (context, stepsProvider, child) {
                      // Check if tracking is active
                      if (!stepsProvider.isTracking) {
                        return const Center(
                          child: Text('Step tracking is not available'),
                        );
                      }

                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Add status indicator
                              Text(
                                'Status: ${stepsProvider.status}',
                                style: TextStyle(
                                  color: stepsProvider.status == 'walking'
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // ... rest of your existing widgets ...
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  StepsProgressIndicator(
                    steps: stepsProvider.currentSteps,
                  ),
                  const SizedBox(height: 40),
                  StatsRow(
                    calories: stepsProvider.caloriesBurned,
                    minutes: stepsProvider.activeMinutes,
                  ),
                  const SizedBox(height: 40),
                  StepsChart(
                    data: stepsProvider.stepHistory,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StepsProgressIndicator extends StatelessWidget {
  final int steps;

  const StepsProgressIndicator({
    super.key,
    required this.steps,
  });
  double calculateProgress(int steps) {
    const int maxSteps = 6000;
    return (steps / maxSteps).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        children: [
          SizedBox.expand(
            child: CustomPaint(
              painter: StepsProgressPainter(
                progress: calculateProgress(steps), // Example progress
                progressColor: Colors.orange,
                backgroundColor: Colors.blue.withOpacity(0.3),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  steps.toString(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Steps',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
