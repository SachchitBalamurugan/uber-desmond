import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/devices/device_utility.dart';

class TSearchField extends StatelessWidget {
   TSearchField({
    super.key, required this.hintText, required this.controller,this.onChanged
  });
  final String hintText;
  final TextEditingController controller;
   // Function(String)? onChanged;
   ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: TSizes.md),
        height: 50,
        width: TDeviceUtils.getScreenWidth(context) * 0.9,
        decoration: BoxDecoration(
            color: TColors.white,
            borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(-2, 2),
                  spreadRadius: 0.1,
                  blurRadius: 4)
            ]),
        child: Row(
          children: [
            Icon(Iconsax.search_normal_14),
            SizedBox(
              width: TSizes.md,
            ),
            Expanded(
                child: TextFormField(
                  onChanged: onChanged,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                )),
            SizedBox(
              width: TSizes.md,
            ),
            Icon(Iconsax.document_filter)
          ],
        ),
      ),
    );
  }
}