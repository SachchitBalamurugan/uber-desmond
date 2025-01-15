import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  int _screenIndex = 0;
  int get screenIndex => _screenIndex;
  void jumpToScreen(int newIndex) {
    _screenIndex = newIndex;
    notifyListeners();
  }
}
