// State management class
import 'package:flutter/material.dart';

class MealScheduleProvider with ChangeNotifier {
  DateTime selectedDate = DateTime(2021, 5, 14);

  void selectDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}