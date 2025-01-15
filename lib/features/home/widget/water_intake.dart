import 'package:flutter/material.dart';
class WaterIntakeWidget extends StatelessWidget {
  const WaterIntakeWidget(
      {super.key,
        required this.currentWaterIntake,
        required this.dailyWaterGoal,
        required this.onAdding200,
        required this.onAdding500});
  final int currentWaterIntake;
  final int dailyWaterGoal;
  final VoidCallback onAdding200;
  final VoidCallback onAdding500;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vertical Progress Bar
          Stack(
            alignment: Alignment
                .bottomCenter, // Ensure the fill starts from the bottom
            children: [
              Container(
                width: 20,
                height: 300, // Increase the height of the bar
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
              ),
              Container(
                width: 20,
                height: (currentWaterIntake / dailyWaterGoal) *
                    300, // Dynamic height calculation
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [Color(0xFF8EB1BB), Color(0xFFB4C0FE)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
          // Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Water Intake',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins', // Set Poppins font
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '4 Liters',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins', // Set Poppins font
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [Color(0xFF8EB1BB), Color(0xFFB7D5DE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Real-time updates',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins', // Set Poppins font
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUpdateRow('6am - 8am', '600ml'),
                    _buildUpdateRow('9am - 11am', '500ml'),
                    _buildUpdateRow('11am - 2pm', '1000ml'),
                    _buildUpdateRow('2pm - 4pm', '700ml'),
                    _buildUpdateRow('4pm - now', '900ml'),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: onAdding200, //_addWaterIntake(200),
                      child: Text(
                        '+200 ml',
                        style: TextStyle(
                            fontFamily: 'Poppins'), // Set Poppins font
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onAdding500,
                      child: Text(
                        '+500 ml',
                        style: TextStyle(
                            fontFamily: 'Poppins'), // Set Poppins font
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateRow(String time, String intake) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            intake,
            style: TextStyle(fontSize: 16, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}
