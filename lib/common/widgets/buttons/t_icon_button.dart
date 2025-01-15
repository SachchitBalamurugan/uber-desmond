import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class TIconButton extends StatelessWidget {
  const TIconButton({
    super.key,required this.shadowColor,
    required this.icon,required this.onPressed
  });
  final IconData icon;
  final VoidCallback onPressed;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: shadowColor,offset: Offset(-1, 1),blurRadius: 4,spreadRadius: 1)],
            borderRadius:
            BorderRadius.circular(TSizes.borderRadiusLg),
            color: TColors.white),
        child: Icon(
icon,          size: TSizes.iconSm,
        ),
      ),
    );
  }
}