// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:provider/provider.dart';

// class RatingPage extends StatefulWidget {
//   const RatingPage({super.key});

//   @override
//   State<RatingPage> createState() => _RatingPageState();
// }

// class _RatingPageState extends State<RatingPage> {
//   double _rating = 0;
//   final _reviewController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final ratingProvider = context.watch<RatingProvider>();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Rate Us")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const Text(
//               "How was your experience?",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 20),

//             RatingBar.builder(
//               minRating: 1,
//               allowHalfRating: true,
//               itemCount: 5,
//               itemSize: 40,
//               itemBuilder: (_, __) =>
//                   const Icon(Icons.star, color: Colors.amber),
//               onRatingUpdate: (value) {
//                 _rating = value;
//               },
//             ),

//             const SizedBox(height: 20),

//             TextFormField(
//               controller: _reviewController,
//               maxLines: 4,
//               decoration: InputDecoration(
//                 hintText: "Write your review...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             ElevatedButton(
//               onPressed: ratingProvider.isLoading
//                   ? null
//                   : () async {
//                       if (_rating == 0 ||
//                           _reviewController.text.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Add rating & review"),
//                           ),
//                         );
//                         return;
//                       }

//                       await ratingProvider.submitRating(
//                         rating: _rating,
//                         review: _reviewController.text.trim(),
//                       );

//                       _reviewController.clear();
//                       _rating = 0;

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Review submitted successfully ✅"),
//                         ),
//                       );
//                     },
//               child: ratingProvider.isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text("Submit"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:project_2/controllers/rating_provider/rating_provider.dart';
// import 'package:provider/provider.dart';

// class RatingPage extends StatelessWidget {
//   final String providerId;
//   final String bookingId;

//   RatingPage({
//     super.key,
//     required this.providerId,
//     required this.bookingId,
//   });

//   final TextEditingController _reviewController = TextEditingController();
//   double _rating = 0;

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<RatingProvider>();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Rate Us")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             RatingBar.builder(
//               minRating: 1,
//               allowHalfRating: true,
//               itemCount: 5,
//               itemSize: 40,
//               itemBuilder: (_, __) =>
//                   const Icon(Icons.star, color: Colors.amber),
//               onRatingUpdate: (value) => _rating = value,
//             ),

//             const SizedBox(height: 20),

//             TextField(
//               controller: _reviewController,
//               maxLines: 4,
//               decoration: const InputDecoration(
//                 hintText: "Write your review",
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             const SizedBox(height: 30),

//             ElevatedButton(
//               onPressed: provider.isLoading
//                   ? null
//                   : () async {
//                       await provider.submitRating(
//                         rating: _rating,
//                         review: _reviewController.text.trim(),
//                         providerId: providerId,
//                         bookingId: bookingId,
//                         context: context,
//                       );
//                     },
//               child: provider.isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text("Submit"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:project_2/controllers/rating_provider/rating_provider.dart';
// import 'package:provider/provider.dart';

// class RatingPage extends StatelessWidget {
//   final String providerId;
//   final String bookingId;

//   const RatingPage({
//     super.key,
//     required this.providerId,
//     required this.bookingId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<RatingProvider>();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Rate Us")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             RatingBar.builder(
//               minRating: 1,
//               allowHalfRating: true,
//               itemCount: 5,
//               itemSize: 40,
//               itemBuilder: (_, __) =>
//                   const Icon(Icons.star, color: Colors.amber),
//               onRatingUpdate: provider.updateRating,
//             ),

//             const SizedBox(height: 20),

//             TextField(
//               controller: provider.reviewController,
//               maxLines: 4,
//               decoration: const InputDecoration(
//                 hintText: "Write your review",
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             const SizedBox(height: 30),

//             ElevatedButton(
//               onPressed: provider.isLoading
//                   ? null
//                   : () => provider.submitRating(
//                         providerId: providerId,
//                         bookingId: bookingId,
//                         context: context,
//                       ),
//               child: provider.isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text("Submit"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:project_2/controllers/rating_provider/rating_provider.dart';
// import 'package:provider/provider.dart';

// class RatingDialog extends StatelessWidget {
//   final String providerId;
//   final String bookingId;

//   const RatingDialog({
//     super.key,
//     required this.providerId,
//     required this.bookingId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<RatingProvider>();

//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       title: const Text("Rate your experience"),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           RatingBar.builder(
//             minRating: 1,
//             allowHalfRating: true,
//             itemSize: 32,
//             itemBuilder: (_, __) =>
//                 const Icon(Icons.star, color: Colors.amber),
//             onRatingUpdate: provider.updateRating,
//           ),

//           const SizedBox(height: 16),

//           TextField(
//             controller: provider.reviewController,
//             maxLines: 3,
//             decoration: const InputDecoration(
//               hintText: "Write a review",
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: provider.isLoading
//               ? null
//               : () {
//                   provider.reviewController.clear();
//                   provider.rating = 0;
//                   Navigator.pop(context);
//                 },
//           child: const Text("Cancel"),
//         ),
//         ElevatedButton(
//           onPressed: provider.isLoading
//               ? null
//               : () => provider.submitRating(
//                     providerId: providerId,
//                     bookingId: bookingId,
//                     context: context,
//                   ),
//           child: provider.isLoading
//               ? const SizedBox(
//                   height: 18,
//                   width: 18,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 )
//               : const Text("Submit"),
//         ),
//       ],
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/rating_provider/rating_provider.dart';
import 'package:provider/provider.dart';

class RatingDialog extends StatelessWidget {
  final String providerId;
  final String bookingId;

  const RatingDialog({
    super.key,
    required this.providerId,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RatingProvider>();
    // final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      backgroundColor: AppColors.textColor,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.textColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              // Decorative top element
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.grey.withOpacity(0.2),
                      AppColors.grey.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.star_rounded,
                  size: 36,
                  color: AppColors.rating,
                ),
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                "Rate your experience",
                // style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                //       fontWeight: FontWeight.bold,
                //       color: AppColors.primary,
                //     ),
                style: TextStyle(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                  ),
              ),

              const SizedBox(height: 8),

              Text(
                "Your feedback helps us improve",
                // style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //       color: AppColors.info.withOpacity(0.6),
                //     ),
                style: TextStyle(color: AppColors.info),
              ),

              const SizedBox(height: 20),

              // Rating stars
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: RatingBar.builder(
                  minRating: 1,
                  allowHalfRating: true,
                  itemSize: 40,
                  glow: true,
                  glowColor: AppColors.rating.withOpacity(0.3),
                  unratedColor: AppColors.grey.withOpacity(0.3),
                  itemBuilder: (_, __) => const Icon(
                    Icons.star_rounded,
                    color: AppColors.rating,
                  ),
                  onRatingUpdate: provider.updateRating,
                ),
              ),

              const SizedBox(height: 20),

              // Review text field
              TextField(
                controller: provider.reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Share your experience...",
                  hintStyle: TextStyle(
                    color: AppColors.hintText.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: AppColors.grey.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () {
                              provider.reviewController.clear();
                              provider.rating = 0;
                              Navigator.pop(context);
                            },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () => provider.submitRating(
                                providerId: providerId,
                                bookingId: bookingId,
                                context: context,
                              ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: AppColors.buttonColor,
                        foregroundColor: AppColors.buttonColor,
                        elevation: 0,
                      ),
                      child: provider.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            )
                          : const Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}













// class RatingProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String userId = FirebaseAuth.instance.currentUser!.uid;

//   bool isLoading = false;

//   Future<void> submitRating({
//     required double rating,
//     required String review,
//   }) async {
//     isLoading = true;
//     notifyListeners();

//     await _firestore
//         .collection('users')
//         .doc(userId)
//         .collection('ratings')
//         .add({
//       'rating': rating,
//       'review': review,
//       'createdAt': FieldValue.serverTimestamp(),
//     });

//       await _firestore
//         .collection('service_provider')
//         .doc(userId)
//         .collection('ratings')
//         .add({
//       'rating': rating,
//       'review': review,
//       'createdAt': FieldValue.serverTimestamp(),
//     });

//     isLoading = false;
//     notifyListeners();
//   }
// }

