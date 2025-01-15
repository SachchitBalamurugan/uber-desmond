import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutCard extends StatelessWidget {
  final String title;
  final String date;
  final bool isActive;
  final ValueChanged onChanged;
  final VoidCallback onTap;
  const WorkoutCard({
    super.key,
    required this.title,
    required this.date,
    required this.onTap,
    required this.isActive,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.fitness_center, color: Colors.blue),
        ),
        title: Text(title, style: GoogleFonts.poppins()),
        subtitle: Text(date, style: GoogleFonts.poppins(fontSize: 12)),
        trailing: Switch(
          value: isActive,
          onChanged: onChanged,
          activeTrackColor: const Color(0xFF8EB1BB),
          activeColor: const Color(0xFFEEA4CE),
        ),
      ),
    );
  }
}