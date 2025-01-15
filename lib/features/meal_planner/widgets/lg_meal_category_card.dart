import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthapp/utils/constants/image_strings.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class LgMealCategoryCard extends StatelessWidget {
  const LgMealCategoryCard(
      {super.key,
      required this.svgPath,
      required this.title,
        required this.subtitle,
      required this.colors});
  final String svgPath;
  final String title;
  final String subtitle;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 239,
      width: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          gradient: LinearGradient(colors: colors)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: TSizes.sm),
          SvgPicture.asset(
            svgPath,
            height: 90,
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 17),
          ),
          Text(
            subtitle,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 15,color: TColors.darkGrey),
          ),
          SizedBox(height: TSizes.spaceBtwItems,),

          Container(
            alignment: Alignment.center,
            height: 38,
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: LinearGradient(colors: [Color(0xFF92A3FD).withOpacity(0.8),Color(0xFF9DCEFF).withOpacity(0.8)])
            ),
            child: Text("View",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: TColors.white),),
          )
        ],
      ),
    );
  }
}
