import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthapp/common/widgets/text/display_title.dart';
import 'package:healthapp/features/meal_planner/meal_planner_screen.dart';
import 'package:healthapp/utils/constants/colors.dart';
import 'package:healthapp/utils/constants/image_strings.dart';
import 'package:healthapp/utils/constants/sizes.dart';
import 'package:healthapp/utils/devices/device_utility.dart';
import 'package:healthapp/utils/route_const.dart';
import 'package:iconsax/iconsax.dart';

import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/appbar/t_app_bar.dart';
import '../../common/widgets/buttons/t_icon_button.dart';
import 'meal_planner_screen.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [

            Positioned(
              top: 0,
              child: Container(
                height: TDeviceUtils.getScreenHeight(context) * 0.6,
                width: TDeviceUtils.getScreenWidth(context) * 1,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color(0xFF61828C),
                  Color(0xFF8EB1BB),
                ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 288,
                      width: 288,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(300),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: SvgPicture.asset(
                        TSvgPath.pancake2,
                        height: 240,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 0,
                child: TAppBar(shadowColorLeading: Colors.blue,shadowColorTrailing: Colors.blue,)),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(TSizes.defaultSpace),
                height: TDeviceUtils.getScreenHeight(context) * 0.63,
                width: TDeviceUtils.getScreenWidth(context),
                decoration: BoxDecoration(
                    color: TColors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: MealPlannerScreen(),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     DisplayTitleMd(title: "Blueberry Pancake"),
                //     GestureDetector(onTap:()=>Navigator.pushNamed(context, GRoute.mealPlannerScreen),child: Text("data"))
                //
                //   ],
                // ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}




