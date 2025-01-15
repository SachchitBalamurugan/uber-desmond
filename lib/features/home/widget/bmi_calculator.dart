import 'package:flutter/material.dart';
import 'package:healthapp/features/home/widget/bmi_scorrer.dart';
import 'package:healthapp/utils/constants/colors.dart';

class BMICalculatorCard extends StatelessWidget {
  const BMICalculatorCard(
      {super.key, required this.onUpdatePressed,  required this.animatedBmiPie});
  final VoidCallback onUpdatePressed;
  final Widget animatedBmiPie;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8EB1BB), Color(0xFFB7D5DE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.transparent,
        elevation: 8, // Shadow intensity
        shadowColor:
            Colors.black.withOpacity(0.2), // Shadow color with transparency
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BMI (Body Mass Index)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Set text color to white
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your calculated BMI is below:',
                    style: TextStyle(
                      color: Colors.white, // Set text color to white
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onUpdatePressed,
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF918EBB), Color(0xFFD3A4EE)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        child: Text(
                          'Update Weight and Height',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              animatedBmiPie
            ],
          ),
        ),
      ),
    );
  }
}

