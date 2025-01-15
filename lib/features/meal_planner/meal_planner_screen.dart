import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthapp/features/meal_planner/widgets/chip_widget.dart';
import 'package:healthapp/features/meal_planner/widgets/ingredient_item_card.dart';
import 'package:healthapp/utils/constants/image_strings.dart';
import 'package:healthapp/utils/constants/sizes.dart';

class MealPlannerScreen extends StatelessWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Content
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "Blueberry Pancake",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              // Rich Text

              SizedBox(height: 16),
              // Nutrition Chips
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(4, (index) {
                    return listOfChipWidgets.elementAt(index);
                  }),
                ),
              ),
              SizedBox(height: 16),
              // Description
              Text(
                "Descriptions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Text(
                    "Pancakes are some people's favorite breakfast, who doesn't like pancakes? Especially with the real honey splash on top of the pancakes, of course everyone loves that! Besides being a healthy option, it...",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700]),
                  );
                },
              ),
              TextButton(
                onPressed: () {},
                child: Text("Read More..."),
              ),
              SizedBox(height: 16),
              // Ingredients Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ingredients That You Will Need",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "6 items",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  separatorBuilder: (_,i)=>SizedBox(width: TSizes.spaceBtwItems,),
                  scrollDirection: Axis.horizontal,
                  itemCount: listOfIngredientItems.length,
                  itemBuilder: (context, index) {
                    return listOfIngredientItems.elementAt(index);
                  },
                ),
              ),
              SizedBox(height: 16),
              // Steps Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Step by Step",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "8 steps",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              SvgPicture.asset(TSvgPath.stepsOfBlueberryPancake),

              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemCount: 5,
              //   itemBuilder: (context, index) {
              //     return ListTile(
              //       leading: CircleAvatar(
              //         child: Text("${index + 1}"),
              //       ),
              //       title: Text("Step ${index + 1}"),
              //       subtitle: Text(
              //           "Description for step ${index + 1}..."),
              //     ) ;
              //   },
              // ),
              SizedBox(height: 80), // For spacing before the button
            ],
          ),
        ),
        // Floating Button
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF61828C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              "Add to Breakfast Meal",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}


List<Widget> listOfIngredientItems =[
  IngredientsItemCard(svgPath: TSvgPath.flour,title: "Wheat Flour",subtitle: "100gr",),
  IngredientsItemCard(svgPath: TSvgPath.sugar,title: "Sugar",subtitle: "3 tbsp",),
  IngredientsItemCard(svgPath: TSvgPath.bakingSoda,title: "Baking Soda",subtitle: "2 tsp",),
  IngredientsItemCard(svgPath: TSvgPath.eggs,title: "Eggs",subtitle: "2 items",),
];
List<Widget> listOfChipWidgets = [
ChipWidget(title: "180kCal",iconPath: TSvgPath.calories,),
ChipWidget(title: "30g fats",iconPath: TSvgPath.eggs,),
ChipWidget(title: "20g proteins",iconPath: TSvgPath.proteins,),
ChipWidget(title: "50g carbo",iconPath: TSvgPath.eggs,),
];