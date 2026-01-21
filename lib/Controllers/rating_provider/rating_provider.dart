// import 'package:flutter/material.dart';
// import 'package:project_2/services/rating_service.dart';

// class RatingProvider extends ChangeNotifier {
//   final RatingService _service = RatingService();
//   bool isLoading = false;

//   Future<void> submitRating({
//     required double rating,
//     required String review,
//     required String providerId,
//     required String bookingId,
//     required BuildContext context,
//   }) async {
//     if (rating == 0 || review.isEmpty) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Add rating & review")));
//       return;
//     }

//     isLoading = true;
//     notifyListeners();

//     await _service.submitRating(
//       rating: rating,
//       review: review,
//       providerId: providerId,
//       bookingId: bookingId,
//     );

//     isLoading = false;
//     notifyListeners();

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Review submitted ✅")),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:project_2/services/rating_service.dart';

class RatingProvider extends ChangeNotifier {
  final RatingService _service = RatingService();

  double rating = 0;
  final TextEditingController reviewController = TextEditingController();
  bool isLoading = false;

  void updateRating(double value) {
    rating = value;
    notifyListeners();
  }

  Future<void> submitRating({
    required String providerId,
    required String bookingId,
    required BuildContext context,
  }) async {
    if (rating == 0 || reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Add rating & review")),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      await _service.submitRating(
        rating: rating,
        review: reviewController.text.trim(),
        providerId: providerId,
        bookingId: bookingId,
      );

      rating = 0;
      reviewController.clear();

      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review submitted ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
}
