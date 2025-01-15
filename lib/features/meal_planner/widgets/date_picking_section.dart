// Date Picker Section
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/meal_adding_provider.dart';

class DatePickerSection extends StatelessWidget {
  const DatePickerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MealScheduleProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back_ios, size: 16, color: Colors.grey),
          SizedBox(width: 10),
          Text(
            "May 2021",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}