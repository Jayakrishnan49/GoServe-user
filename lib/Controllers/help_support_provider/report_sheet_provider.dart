import 'package:flutter/material.dart';

class ReportSheetProvider extends ChangeNotifier {
  String? _selected;
  String? get selected => _selected;

  void select(String issue) {
    _selected = issue;
    notifyListeners();
  }

  void reset() {
    _selected = null;
    notifyListeners();
  }
}