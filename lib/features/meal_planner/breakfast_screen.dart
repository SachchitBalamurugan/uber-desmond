import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthapp/generated/assets.dart';
import 'package:healthapp/features/meal_planner/widgets/lg_meal_category_card.dart';
import 'package:healthapp/utils/constants/colors.dart';
import 'package:healthapp/utils/constants/image_strings.dart';
import 'package:healthapp/utils/constants/sizes.dart';
import 'package:healthapp/utils/devices/device_utility.dart';
import 'package:healthapp/utils/route_const.dart';
import 'package:iconsax/iconsax.dart';

import '../../common/widgets/text/display_title.dart';
import 'widgets/meal_category_card.dart';
import 'widgets/popular_card.dart';
import 'widgets/t_search_field.dart';

class BreakFastScreen extends StatelessWidget {
  const BreakFastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Breakfast",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpaceSm),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TSearchField(hintText: "Search Pancake",controller: TextEditingController(),),
                SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DisplayTitleMd(title: "Category",),

                      SizedBox(height: TSizes.spaceBtwItems),
                      Container(
                          height: 100,
                          width: TDeviceUtils.getScreenWidth(context) * 0.99,
                          child: ListView.separated(
                              separatorBuilder: (_, i) => SizedBox(
                                    width: TSizes.spaceBtwItems,
                                  ),
                              itemCount: listOfMealCategoryCard.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, i) => MealCategoryCard(
                                  svgPath: listOfMealCategoryCard[i].svgPath,
                                  title: listOfMealCategoryCard[i].title,
                                  colors: listOfMealCategoryCard[i].colors))),
                      SizedBox(
                        height: TSizes.spaceBtwSections,
                      ),
                      DisplayTitleMd(title: "Recommendation for Diet",),
                      SizedBox(height: TSizes.spaceBtwItems),
                      Container(
                        height: 239,
                        width: TDeviceUtils.getScreenWidth(context) * 0.99,
                        child: ListView.separated(
                          separatorBuilder: (_, i) => SizedBox(
                            width: TSizes.spaceBtwItems,
                          ),
                          itemCount: listOfLgMealCategoryCard.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, i) => LgMealCategoryCard(
                              svgPath: listOfLgMealCategoryCard[i].svgPath,
                              title: listOfLgMealCategoryCard[i].title,
                              colors: listOfLgMealCategoryCard[i].colors, subtitle: listOfLgMealCategoryCard[i].subtitle,),
                        ),
                      ),
                      SizedBox(height: TSizes.spaceBtwSections),

                      DisplayTitleMd(title: "Popular",),
                      SizedBox(height: TSizes.spaceBtwItems),
                      GestureDetector(child: PopularCard(),onTap: ()=>Navigator.pushNamed(context, GRoute.popularMealNextScreen),),
                      SizedBox(height: TSizes.spaceBtwItems,),
                      PopularCard()
                    ],
                  ),
                ),
                SizedBox(height: TSizes.spaceBtwSections,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}




List<MealCategoryCard> listOfMealCategoryCard = [
  MealCategoryCard(
    title: "Salad",
    svgPath: TSvgPath.salad,
    colors: [
      Color(0xFF92A3FD).withOpacity(0.3),
      Color(0xFF9DCEFF).withOpacity(0.3)
    ],
  ),
  MealCategoryCard(
    title: "Cake",
    svgPath: TSvgPath.cake,
    colors: [
      Color(0xFF8EB1BB).withOpacity(0.3),
      Color(0xFFEEA4CE).withOpacity(0.3)
    ],
  ),
  MealCategoryCard(
    title: "Pie",
    svgPath: TSvgPath.pie,
    colors: [
      Color(0xFF92A3FD).withOpacity(0.3),
      Color(0xFF9DCEFF).withOpacity(0.3)
    ],
  ),
  MealCategoryCard(
    title: "Smoothies",
    svgPath: TSvgPath.smoothies,
    colors: [
      Color(0xFF8EB1BB).withOpacity(0.3),
      Color(0xFFEEA4CE).withOpacity(0.3)
    ],
  ),
];
List<LgMealCategoryCard> listOfLgMealCategoryCard = [
  LgMealCategoryCard(
    svgPath: TSvgPath.cake,
    title: 'Honey Pancake',
    subtitle: "Easy | 30mins | 180kCal",
    colors: [
      Color(0xFF8EB1BB).withOpacity(0.3),
      Color(0xFFEEA4CE).withOpacity(0.3)
    ],
  ),
  LgMealCategoryCard(
    svgPath: TSvgPath.pie,
    title: 'Canai Bread',
    subtitle: "Easy | 20mins | 230kCal",
    colors: [
      Color(0xFF8EB1BB).withOpacity(0.3),
      Color(0xFFEEA4CE).withOpacity(0.3)
    ],
  ),
];


