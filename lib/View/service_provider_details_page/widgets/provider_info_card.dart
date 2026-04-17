import 'package:flutter/material.dart';
import 'package:project_2/Constants/app_color.dart';
import 'package:project_2/model/service_model.dart';
import 'package:project_2/utilities/rating_color_helper.dart';

class ProviderInfoCard extends StatelessWidget {
  final ServiceProviderModel provider;
  final double rating;
  final int totalReviews;

  const ProviderInfoCard({
    super.key,
    required this.provider,
    required this.rating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    Color ratingColor=getRatingColor(rating);
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.textColor.withValues(alpha: 0.05),
            blurRadius: 40,
            offset: const Offset(0, 16),
            spreadRadius: -8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Subtle gradient overlay
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.05),
                      AppColors.primary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with name and badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.name,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textColor,
                                height: 1.2,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Rating row moved here for better visual hierarchy



                          Row(
  children: [
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ratingColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
           Icon(
            Icons.star_rounded,
            color: ratingColor,
            size: 30,
          ),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style:  TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: ratingColor,
            ),
          ),
        ],
      ),
    ),
    const SizedBox(width: 8),
    Text(
      '$totalReviews reviews',
      style: TextStyle(
        fontSize: 14,
        color: AppColors.hintText,
        fontWeight: FontWeight.w500,
      ),
    ),
  ],
)



                            // Row(
                            //   children: [
                            //     Container(
                            //       padding: const EdgeInsets.symmetric(
                            //         horizontal: 8,
                            //         vertical: 4,
                            //       ),
                            //       decoration: BoxDecoration(
                            //         color: const Color(0xFFFFC107)
                            //             .withValues(alpha: 0.15),
                            //         borderRadius: BorderRadius.circular(8),
                            //       ),
                            //       child: Row(
                            //         mainAxisSize: MainAxisSize.min,
                            //         children: [
                            //           const Icon(
                            //             Icons.star_rounded,
                            //             color: Color(0xFFFFC107),
                            //             size: 23,
                            //           ),
                            //           const SizedBox(width: 4),
                            //           Text(
                            //             rating.toStringAsFixed(1),
                            //             style: const TextStyle(
                            //               fontSize: 20,
                            //               fontWeight: FontWeight.bold,
                            //               color: Color(0xFFFFC107),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //     const SizedBox(width: 8),
                            //     Text(
                            //       '$totalReviews reviews',
                            //       style: TextStyle(
                            //         fontSize: 14,
                            //         color: AppColors.hintText,
                            //         fontWeight: FontWeight.w500,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Service badge with modern styling
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          provider.selectService,
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Divider
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.textColor.withValues(alpha: 0),
                          AppColors.textColor.withValues(alpha: 0.1),
                          AppColors.textColor.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Info rows with enhanced styling
                  _buildInfoRow(
                    Icons.person_rounded,
                    provider.gender,
                    const Color(0xFFEC4899),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.location_on_rounded,
                    provider.location,
                    AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.work_rounded,
                    '${provider.yearsOfexperience} years of experience',
                    const Color(0xFF6366F1),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color accentColor) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: accentColor,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}