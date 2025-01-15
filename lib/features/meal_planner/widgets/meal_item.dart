// Meal Item Widget
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/utils/constants/sizes.dart';

class TMealItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final String time;

  const TMealItem({super.key, required this.icon, required this.name, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: TSizes.sm),
              height: 49,width:49, decoration:BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(TSizes.borderRadiusMd)

            ),child: Icon(icon, color: Colors.orange,size: 29,),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ],
    );
  }
}