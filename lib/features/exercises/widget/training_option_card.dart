import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingOptionCard extends StatelessWidget {
  final String title;
  final String exercises;

  const TrainingOptionCard({
    super.key,
    required this.title,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: const Icon(Icons.directions_run, color: Colors.green),
        ),
        title: Text(title, style: GoogleFonts.poppins()),
        subtitle: Text(exercises, style: GoogleFonts.poppins(fontSize: 12)),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("View more"),
        ),
      ),
    );
  }
}