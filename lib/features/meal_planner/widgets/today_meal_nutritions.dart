import 'package:flutter/material.dart';

import '../../../common/widgets/text/display_title.dart';
import '../../../utils/constants/sizes.dart';
import 'detailed_progress_card.dart';

class TodayMealNutritionSection extends StatelessWidget {
  const TodayMealNutritionSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DisplayTitleMd(title: "Today Meal Nutritions"),
        SizedBox(height: TSizes.spaceBtwItems,),
        CaloriesCard(progress: 0.8,icon: Icons.local_fire_department, title: 'Calories', value: '320 kCal',),
        CaloriesCard(progress: 0.8,icon: Icons.local_fire_department, title: 'Calories', value: '320 kCal',),
        CaloriesCard(progress: 0.8,icon: Icons.local_fire_department, title: 'Calories', value: '320 kCal',),
        CaloriesCard(progress: 0.8,icon: Icons.local_fire_department, title: 'Calories', value: '320 kCal',),

      ],
    );
  }
}
