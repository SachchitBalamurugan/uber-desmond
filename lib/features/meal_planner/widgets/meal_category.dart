// Meal Category Widget


import 'package:flutter/material.dart';

import 'meal_item.dart';


class MealCategory extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<TMealItem> meals;

  const MealCategory(
      {super.key, required this.title, required this.subtitle, required this.meals});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),     Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),

        SizedBox(height: 10),
        ...meals.map((meal) => meal),
        SizedBox(height: 20),
      ],
    );
  }
}