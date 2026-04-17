import 'package:flutter/material.dart';

Color getRatingColor(double rating) {
  if (rating == 0) {
    return Colors.grey; // no ratings yet
  } else if (rating >= 4.5) {
    return const Color(0xFF2E7D32); // dark green
  } else if (rating >= 4.0) {
    return const Color(0xFF66BB6A); // light green
  } else if (rating >= 3.0) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}