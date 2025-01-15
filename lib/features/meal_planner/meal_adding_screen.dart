import 'package:flutter/material.dart';
import 'package:healthapp/common/widgets/appbar/t_app_bar.dart';
import 'package:healthapp/common/widgets/text/display_title.dart';
import 'package:healthapp/features/meal_planner/widgets/date_picking_section.dart';
import 'package:healthapp/features/meal_planner/widgets/detailed_progress_card.dart';
import 'package:healthapp/features/meal_planner/widgets/meal_category.dart';
import 'package:healthapp/features/meal_planner/widgets/meal_item.dart';
import 'package:healthapp/features/meal_planner/widgets/today_meal_nutritions.dart';
import 'package:healthapp/utils/constants/colors.dart';
import 'package:healthapp/utils/constants/sizes.dart';
import 'package:provider/provider.dart';

import '../../providers/meal_adding_provider.dart';
import 'meal_schedule_screen.dart';

// Meal Schedule Screen
class MealAddingScreen extends StatelessWidget {
  const MealAddingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            TAppBar(titleTrue: true,titleWidget: DisplayTitleMd(title: 'Meal Schedule'), shadowColorLeading: Colors.grey.shade200, shadowColorTrailing: Colors.grey.shade200),
            DatePickerSection(),
            MealSection(),
            TodayMealNutritionSection()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(39)),
        backgroundColor: TColors.primary,
        child:  Icon(Icons.add, color: TColors.white),
      ),
    );
  }
}



// Meal Section
class MealSection extends StatelessWidget {
  const MealSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          MealCategory(
            title: "Breakfast",
            subtitle: "2 meals | 230 calories",
            meals: [
              TMealItem(
                  icon: Icons.breakfast_dining,
                  name: "Honey Pancake",
                  time: "07:00am"),
              TMealItem(icon: Icons.coffee, name: "Coffee", time: "07:30am"),
            ],
          ),
          MealCategory(
            title: "Lunch",
            subtitle: "2 meals | 500 calories",
            meals: [
              TMealItem(
                  icon: Icons.lunch_dining,
                  name: "Chicken Steak",
                  time: "01:00pm"),
              TMealItem(icon: Icons.local_drink, name: "Milk", time: "01:20pm"),
            ],
          ),
          MealCategory(
            title: "Snacks",
            subtitle: "2 meals | 140 calories",
            meals: [
              TMealItem(
                  icon: Icons.local_pizza, name: "Orange", time: "04:30pm"),
              TMealItem(icon: Icons.cake, name: "Apple Pie", time: "04:40pm"),
            ],
          ),
          MealCategory(
            title: "Dinner",
            subtitle: "2 meals | 120 calories",
            meals: [
              TMealItem(icon: Icons.rice_bowl, name: "Salad", time: "07:10pm"),
              TMealItem(
                  icon: Icons.local_dining, name: "Oatmeal", time: "08:10pm"),
            ],
          ),
        ],
      ),
    );
  }
}






