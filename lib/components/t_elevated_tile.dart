import 'package:flutter/material.dart';
import 'package:healthapp/utils/constants/sizes.dart';

import '../../../utils/route_const.dart';

class TElevatedTile extends StatelessWidget {
  const TElevatedTile({
    super.key, required this.onCheckPressed, required this.title, required this.buttonTitle,
  });

  final VoidCallback onCheckPressed;
  final String title;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: TSizes.spaceBtwItems),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF044051), Color(0xFFE9EDFF)], // Gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Shadow color with transparency
            spreadRadius: 2, // How far the shadow spreads
            blurRadius: 6, // The softness of the shadow
            offset: Offset(0, 3), // Position of the shadow (x, y)
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Changed color to white for the title
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(32, 32), // Smaller button size
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 0, // Optional: Remove shadow for a flat look
            ),
            onPressed: onCheckPressed,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  buttonTitle,
                  style: TextStyle(
                    fontSize: 12, // Smaller text size
                    color: Colors.white, // Button text color is already white
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
