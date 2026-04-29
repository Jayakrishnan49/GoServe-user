import 'package:flutter/material.dart';

class HelpSupportProvider extends ChangeNotifier {
  int? _expandedIndex;
  int? get expandedIndex => _expandedIndex;

  void toggleFaq(int index) {
    _expandedIndex = _expandedIndex == index ? null : index;
    notifyListeners();
  }
}

