

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
              // Container(
              //   width: 64,
              //   height: 64,
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [
              //         AppColors.grey.withOpacity(0.2),
              //         AppColors.grey.withOpacity(0.1),
              //       ],
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ),
              //     shape: BoxShape.circle,
              //   ),
              //   child: Icon(
              //     Icons.star_rounded,
              //     size: 36,
              //     color: AppColors.rating,
              //   ),
              // ),
              

              const SizedBox(height: 16),

              // Title
              Text(
                "Rate your service provider",
                textAlign: TextAlign.center,
                // style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                //       fontWeight: FontWeight.bold,
                //       color: AppColors.primary,
                //     ),
                style: TextStyle(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 23
                  ),
              ),

              const SizedBox(height: 12),

              Text(
                "Share your experience to help others\nmake better choices",
                textAlign: TextAlign.center,
                // style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //       color: AppColors.info.withOpacity(0.6),
                //     ),
                style: TextStyle(color: AppColors.info),
              ),
              Image.asset(
                'assets/rating_and_review/rating_and_review.png',
                // width: 1000,
                fit: BoxFit.contain,
                ),

              const SizedBox(height: 20),

              // Rating stars
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.rating.withOpacity(0.2),
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


