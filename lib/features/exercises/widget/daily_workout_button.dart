import 'package:flutter/material.dart';

import '../../../utils/route_const.dart';
class DailyWorkoutScheduledButton extends StatelessWidget {
  const DailyWorkoutScheduledButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            color:
            Colors.grey.withOpacity(0.3), // Shadow color with transparency
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
            "Daily Workout Schedule",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Adjust if needed
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
            onPressed: () {
              // Add your button action here
              Navigator.pushNamed(context, GRoute.workoutScreen);
            },
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
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Check',
                  style: TextStyle(
                    fontSize: 12, // Smaller text size
                    color: Colors.white,
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