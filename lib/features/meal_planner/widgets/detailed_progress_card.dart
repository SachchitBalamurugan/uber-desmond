import 'package:flutter/material.dart';
import 'package:healthapp/utils/constants/sizes.dart';
import 'package:healthapp/utils/devices/device_utility.dart';

import '../meal_adding_screen.dart';

class CaloriesCard extends StatelessWidget {
  const CaloriesCard(
      {super.key,
      required this.progress,
      required this.icon,
      required this.title,
      required this.value});
  final double progress;
  final IconData icon;
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          // Custom Shadow Background
          CustomPaint(
            painter: CardShadowPainter(),
            child: SizedBox(
              width: TDeviceUtils.getScreenWidth(context)*0.9,
              height: 100,
            ),
          ),
          // Main Card Content
          Container(
            width: TDeviceUtils.getScreenWidth(context)*0.9,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left side: Calories and icon
                  Row(
                    children: [
                      // Fire Icon

                      // "Calories" Text
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(icon, color: Colors.red, size: 24),
                      Spacer(),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  // Right side: Calories and Progress Bar
                  Container(
                    width: TDeviceUtils.getScreenWidth(context) * 0.9,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300,
                    ),
                    child: FractionallySizedBox(
                      widthFactor: progress, // 320 out of 500 = 64%
                      alignment: Alignment.topLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15);

    // Draw the shadow for the card
    final rect = Rect.fromLTRB(0, 10, size.width, size.height + 10);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(20));
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
