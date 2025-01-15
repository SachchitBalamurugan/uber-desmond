import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/constants/sizes.dart';

class ChipWidget extends StatelessWidget {
  const ChipWidget({
    super.key, required this.title, required this.iconPath,

  });
  final String title;
  final String iconPath;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        padding: EdgeInsets.all(TSizes.sm),
        side: BorderSide.none,
        backgroundColor:Color(0xFF8EB1BB).withOpacity(0.3),
        avatar: SvgPicture.asset(iconPath),
        label: Text(title,style: Theme.of(context).textTheme.titleMedium,),
      ),
    );
  }
}
