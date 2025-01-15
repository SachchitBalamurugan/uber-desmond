import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class MealCategoryCard extends StatelessWidget {
  const MealCategoryCard({
    super.key, required this.svgPath, required this.title,required this.colors
  });
  final String svgPath;
  final String title;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          gradient: LinearGradient(
              colors:colors)    ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: TColors.white,

            ),
            child: SvgPicture.asset(svgPath,width: TSizes.lg,),
          ),
          SizedBox(height: TSizes.sm),
          Text(title,style: Theme.of(context).textTheme.bodyMedium,)
        ],
      ),
    );
  }
}