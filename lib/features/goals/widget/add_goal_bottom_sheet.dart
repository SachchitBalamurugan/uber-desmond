import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/goal_provider.dart';

class CreateGoalBottomSheet extends StatelessWidget {
  const CreateGoalBottomSheet({super.key, required this.goalProvider});
  final SaveGoalProvider goalProvider;
  @override
  Widget build(BuildContext context) {
    // final goalProvider = context.read<GoalProvider>();

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Goal Name',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              TextField(
                controller: goalProvider.goalNameController,
                onChanged: (value) {
                  goalProvider.setGoalName(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Enter goal name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Using Consumer for GoalProvider
              Consumer<SaveGoalProvider>(
                builder: (context, goalProvider, child) {
                  return Column(
                    children: [
                      _buildDropdown(
                          context, 'Water Intake Goals', goalProvider),
                      _buildDropdown(context, 'Hours of Sleep', goalProvider),
                      _buildDropdown(context, 'Calories', goalProvider),
                      _buildDropdown(
                          context, 'Minutes Workout per day', goalProvider),
                      _buildDropdown(context, 'Step Per Day', goalProvider),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => goalProvider.saveGoalToFirebase(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('Save Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
      BuildContext context, String title, SaveGoalProvider goalProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: DropdownButton<String>(
              value: goalProvider.getSelectedValue(title),
              isExpanded: true,
              hint: const Text('Select an option'),
              items: goalProvider.getGoalOptions(title).map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                goalProvider.updateSelectedValue(title, newValue);
              },
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ],
      ),
    );
  }
}
