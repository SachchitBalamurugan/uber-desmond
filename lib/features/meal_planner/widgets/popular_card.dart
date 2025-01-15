import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/devices/device_utility.dart';
class PopularCard extends StatelessWidget {
  const PopularCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.symmetric(horizontal: TSizes.md,vertical: TSizes.md),
      height: 80,
      width: TDeviceUtils.getScreenWidth(context)*0.9,
      decoration: BoxDecoration(
          color: TColors.white,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          boxShadow: [
            BoxShadow(
                offset: Offset(-3, 3),color: TColors.grey,spreadRadius: 0.1,blurRadius: 4
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(TSvgPath.pie,height: 45,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Blueberry Pancake",style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 17),),
              Text("Medium | 30mins | 230kCal",style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 15,color: TColors.darkGrey),)
            ],
          ),
          Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: TColors.grey)
              ),
              child: Icon(Icons.arrow_forward_ios,size: 20.0,color: TColors.grey,)
          ),
        ],
      ),
    );
  }
}
