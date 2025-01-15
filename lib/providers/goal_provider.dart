// save_goal_provider.dart
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/utils/helpers/helper_functions.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class SaveGoalProvider with ChangeNotifier {
  TextEditingController goalNameController = TextEditingController();
  String goalName = '';

  // Map to track the options for each goal
  final Map<String, List<String>> _goalOptions = {
    'Water Intake Goals': ['5 Liters', '10 Liters', '15 Liters'],
    'Hours of Sleep': ['6 hours', '8 hours', '10 hours'],
    'Calories': ['1000 cal', '2000 cal', '3000 cal'],
    'Minutes Workout per day': ['15 minutes', '30 minutes', '1 hour'],
    'Step Per Day': ['3000 Steps', '5000 Steps', '10000 Steps'],
  };

  // Map to track the selected values for each goal
  final Map<String, String?> _selectedValues = {};

  void setGoalName(String newName) {
    goalName = newName;
    goalNameController.text = goalName;
    notifyListeners();
  }

  void resetGoalSelections() {
    _selectedValues.clear();
    notifyListeners();
  }

  // Getters
  List<String> getGoalOptions(String key) => _goalOptions[key] ?? [];
  String? getSelectedValue(String key) => _selectedValues[key];

  void updateSelectedValue(String key, String? value) {
    _selectedValues[key] = value;
    notifyListeners();
  }

  Future<void> saveGoalToFirebase(BuildContext context) async {
    if (goalName.isEmpty) {
      THelperFunctions.showSnackBar("Goal name cannot be empty", context);
      throw Exception('Goal name cannot be empty');
    }

    final Map<String, dynamic> goalData = {
      'goalName': goalName,
      'progress': 0.0,
      for (var key in _selectedValues.keys) key: _selectedValues[key],
    };

    final userUid = FirebaseAuth.instance.currentUser?.uid;
    if (userUid == null) {
      THelperFunctions.showSnackBar("User not authenticated", context);
      throw Exception('User not authenticated');
    }

    try {
      await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userUid)
          .child('subGoals')
          .child(goalName)
          .set(goalData);

      THelperFunctions.showSnackBar("Goal saved successfully", context);
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error saving goal: $e");
      THelperFunctions.showSnackBar("Failed to save goal", context);
      throw Exception("Failed to save goal");
    }
  }

  @override
  void dispose() {
    goalNameController.dispose();
    super.dispose();
  }
  Future<void> exportGoalsToPDF(BuildContext context) async {
    try {
      final userUid = FirebaseAuth.instance.currentUser?.uid;
      if (userUid == null) {
        THelperFunctions.showSnackBar("User not authenticated", context);
        return;
      }

      // Fetch goals data from Firebase
      final snapshot = await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userUid)
          .child('subGoals')
          .get();

      if (!snapshot.exists) {
        THelperFunctions.showSnackBar("No goals found to export", context);
        return;
      }

      // Create PDF document
      final pdf = pw.Document();

      // Add title page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text('Goals Progress Report',
                      style: pw.TextStyle(
                          fontSize: 24, fontWeight: pw.FontWeight.bold)),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Generated on: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}'),
                pw.SizedBox(height: 40),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    // Header row
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Goal Name',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Progress',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Target',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                      ],
                    ),
                    // Data rows
                    ...snapshot.children.map((goal) {
                      final goalData = goal.value as Map<dynamic, dynamic>;
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(goalData['goalName']?.toString() ?? ''),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('${goalData['progress']?.toString() ?? '0'}%'),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                if (goalData['Water Intake Goals'] != null)
                                  pw.Text('Water: ${goalData['Water Intake Goals']}'),
                                if (goalData['Hours of Sleep'] != null)
                                  pw.Text('Sleep: ${goalData['Hours of Sleep']}'),
                                if (goalData['Calories'] != null)
                                  pw.Text('Calories: ${goalData['Calories']}'),
                                if (goalData['Minutes Workout per day'] != null)
                                  pw.Text('Workout: ${goalData['Minutes Workout per day']}'),
                                if (goalData['Step Per Day'] != null)
                                  pw.Text('Steps: ${goalData['Step Per Day']}'),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'goals_progress_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.pdf';
      final file = File('${directory.path}/$fileName');

      // Save the PDF
      await file.writeAsBytes(await pdf.save());

      // Open the PDF file
      await OpenFile.open(file.path);

      THelperFunctions.showSnackBar("PDF exported successfully", context);
    } catch (e) {
      debugPrint("Error exporting PDF: $e");
      THelperFunctions.showSnackBar("Failed to export PDF", context);
    }
  }
  Future<void> shareGoalsProgress(BuildContext context) async {
    try {
      final userUid = FirebaseAuth.instance.currentUser?.uid;
      if (userUid == null) {
        THelperFunctions.showSnackBar("User not authenticated", context);
        return;
      }

      // Fetch goals data from Firebase
      final snapshot = await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userUid)
          .child('subGoals')
          .get();

      if (!snapshot.exists) {
        THelperFunctions.showSnackBar("No goals found to share", context);
        return;
      }

      // Create a formatted message string
      StringBuffer messageBuffer = StringBuffer();
      messageBuffer.writeln('🎯 My Goals Progress Report 🎯\n');
      messageBuffer.writeln('Generated on: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}\n');

      // Add goals data
      snapshot.children.forEach((goal) {
        final goalData = goal.value as Map<dynamic, dynamic>;
        messageBuffer.writeln('Goal: ${goalData['goalName']}');
        messageBuffer.writeln('Progress: ${goalData['progress']}%');

        // Add target information if available
        if (goalData['Water Intake Goals'] != null) {
          messageBuffer.writeln('Water Target: ${goalData['Water Intake Goals']}');
        }
        if (goalData['Hours of Sleep'] != null) {
          messageBuffer.writeln('Sleep Target: ${goalData['Hours of Sleep']}');
        }
        if (goalData['Calories'] != null) {
          messageBuffer.writeln('Calories Target: ${goalData['Calories']}');
        }
        if (goalData['Minutes Workout per day'] != null) {
          messageBuffer.writeln('Workout Target: ${goalData['Minutes Workout per day']}');
        }
        if (goalData['Step Per Day'] != null) {
          messageBuffer.writeln('Steps Target: ${goalData['Step Per Day']}');
        }
        messageBuffer.writeln('------------------------\n');
      });

      // Add a motivational message
      messageBuffer.writeln('💪 Keep pushing towards your goals! 🌟');

      // Share the message
      await Share.share(
        messageBuffer.toString(),
        subject: 'My Health Goals Progress',
      );

    } catch (e) {
      debugPrint("Error sharing goals: $e");
      THelperFunctions.showSnackBar("Failed to share goals", context);
    }
  }
}

