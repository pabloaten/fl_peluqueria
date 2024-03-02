import 'package:flutter/material.dart';

class HorarioProvider with ChangeNotifier {
  TimeOfDay? _morningOpeningTime;
  TimeOfDay? _afternoonOpeningTime;
  TimeOfDay? _morningClosingTime; // Add this line
  TimeOfDay? _afternoonClosingTime; // Add this line

  TimeOfDay? get morningOpeningTime => _morningOpeningTime;
  TimeOfDay? get afternoonOpeningTime => _afternoonOpeningTime;
  TimeOfDay? get morningClosingTime => _morningClosingTime; // Add this line
  TimeOfDay? get afternoonClosingTime => _afternoonClosingTime; // Add this line

  void setMorningOpeningTime(TimeOfDay time) {
    _morningOpeningTime = time;
    notifyListeners();
  }

  void setAfternoonOpeningTime(TimeOfDay time) {
    _afternoonOpeningTime = time;
    notifyListeners();
  }

  void setMorningClosingTime(TimeOfDay time) { // Add this method
    _morningClosingTime = time;
    notifyListeners();
  }

  void setAfternoonClosingTime(TimeOfDay time) { // Add this method
    _afternoonClosingTime = time;
    notifyListeners();
  }
}