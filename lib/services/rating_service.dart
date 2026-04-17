// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class RatingService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String userId = FirebaseAuth.instance.currentUser!.uid;

//   Future<void> submitRating({
//     required double rating,
//     required String review,
//     required String providerId,
//     required String bookingId,
//   }) async {
//     await _firestore.collection('ratings').add({
//       'userId': userId,
//       'providerId': providerId,
//       'bookingId': bookingId,
//       'rating': rating,
//       'review': review,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   }

  
// }




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;


  Stream<QuerySnapshot> getProviderRatings(String providerId) {
    return _firestore
      .collection('ratings')
      .where('providerId', isEqualTo: providerId)
      .snapshots();
  }


  Stream<QuerySnapshot> getProviderReviews(String providerId) {
  return _firestore
      .collection('ratings')
      .where('providerId', isEqualTo: providerId)
      .orderBy('createdAt', descending: true)
      .snapshots();
}


  Future<void> submitRating({
    required double rating,
    required String review,
    required String providerId,
    required String bookingId,
  }) async {

    // 🔒 Prevent duplicate rating
    final existing = await _firestore
        .collection('ratings')
        .where('bookingId', isEqualTo: bookingId)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      throw Exception('Rating already submitted');
    }

    // ⭐ Save rating
    await _firestore.collection('ratings').add({
      'userId': userId,
      'providerId': providerId,
      'bookingId': bookingId,
      'rating': rating,
      'review': review,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // ✅ Mark booking as rated
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('my_bookings')
        .doc(bookingId)
        .update({
      'hasRated': true,
    });
  }
}
