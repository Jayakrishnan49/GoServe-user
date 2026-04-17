// import 'package:flutter/material.dart';
// import 'package:project_2/services/rating_service.dart';

// class RatingProvider extends ChangeNotifier {
//   final RatingService _service = RatingService();

//   double rating = 0;
//   final TextEditingController reviewController = TextEditingController();
//   bool isLoading = false;

//   void updateRating(double value) {
//     rating = value;
//     notifyListeners();
//   }

//   Future<void> submitRating({
//     required String providerId,
//     required String bookingId,
//     required BuildContext context,
//   }) async {
//     if (rating == 0 || reviewController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Add rating & review")),
//       );
//       return;
//     }

//     isLoading = true;
//     notifyListeners();

//     try {
//       await _service.submitRating(
//         rating: rating,
//         review: reviewController.text.trim(),
//         providerId: providerId,
//         bookingId: bookingId,
//       );

//       rating = 0;
//       reviewController.clear();

//       Navigator.pop(context);
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Review submitted ✅")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   @override
//   void dispose() {
//     reviewController.dispose();
//     super.dispose();
//   }
// }






import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_2/services/rating_service.dart';
import 'package:project_2/widgets/custom_modern_snackbar.dart';

class RatingProvider extends ChangeNotifier {
  final RatingService _service = RatingService();

  /// ⭐ Rating input
  double rating = 0;
  final TextEditingController reviewController = TextEditingController();
  bool isLoading = false;

  /// ⭐ Provider rating display
  double avgRating = 0;
  int reviewCount = 0;

  /// Update rating when user selects stars
  void updateRating(double value) {
    rating = value;
    notifyListeners();
  }

  /// 🔥 Submit rating
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

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Review submitted ✅")),
      // );
      ModernSnackBar.show(
        context: context, 
        message: 'We appreciate your feedback. It helps us improve!',
        title: 'Review Submitted 🎉',
        type: SnackBarType.success
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


  Stream<QuerySnapshot> getProviderReviews(String providerId) {
  return _service.getProviderReviews(providerId);
}

  /// ⭐ Get ratings stream
  Stream<QuerySnapshot> getProviderRatings(String providerId) {
    return _service.getProviderRatings(providerId);
  }

  /// ⭐ Calculate average rating
  void calculateRating(QuerySnapshot snapshot) {
    double total = 0;
    reviewCount = snapshot.docs.length;

    for (var doc in snapshot.docs) {
      total += (doc['rating'] ?? 0).toDouble();
    }

    avgRating = reviewCount > 0 ? total / reviewCount : 0;

    // notifyListeners();
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
}