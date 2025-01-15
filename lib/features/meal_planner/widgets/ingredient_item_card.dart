import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/constants/sizes.dart';

class IngredientsItemCard extends StatelessWidget {
  const IngredientsItemCard({
    super.key, required this.svgPath, required this.title, required this.subtitle,
  });
  final String svgPath;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 80,
          width: 80,
          decoration: BoxDecoration(
              color: Color(0xFFF7F8F8),
              borderRadius: BorderRadius.circular(TSizes.borderRadiusLg)
          ),
          child: SvgPicture.asset(svgPath,width: 41,),
        ),
        SizedBox(height: 8),
        Text(title),
        Text(subtitle,style: Theme.of(context).textTheme.bodySmall,),
      ],
    );
  }
}
