import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/devices/device_utility.dart';
import '../buttons/t_icon_button.dart';
class TAppBar extends StatelessWidget {
  const TAppBar({
    super.key,  this.titleWidget =const SizedBox.shrink(), this.titleTrue =false, required this.shadowColorLeading,required  this.shadowColorTrailing, this.leadingOnPress,
  });
  final Widget? titleWidget;
  final bool?titleTrue;
  final Color shadowColorLeading;
  final Color shadowColorTrailing;
  final VoidCallback? leadingOnPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: TDeviceUtils.getScreenWidth(context),
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TIconButton(icon: Icons.arrow_back_ios_new, onPressed: () =>Navigator.pop(context), shadowColor: shadowColorLeading,),
          if(titleTrue!) titleWidget!,
          TIconButton(icon: Iconsax.more, onPressed: (){},shadowColor: shadowColorTrailing,),

        ],
      ),
    );
  }
}

