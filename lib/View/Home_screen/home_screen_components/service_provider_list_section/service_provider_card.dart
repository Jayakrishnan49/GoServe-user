
// import 'package:flutter/material.dart';
// import 'package:project_2/Constants/app_color.dart';
// import 'package:project_2/model/service_model.dart';

// class ServiceProviderCard extends StatelessWidget {
//   final ServiceProviderModel provider;

//   const ServiceProviderCard({super.key, required this.provider});

//   @override
//   Widget build(BuildContext context) {
//     const double rating = 4.5; 
//     return Container(
//       width: 160,
//       margin: const EdgeInsets.only(right: 16),
//       child: Stack(
//         children: [
//           // Main Card
//           Container(
//             decoration: BoxDecoration(
//               color: AppColors.secondary,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.textColor.withValues(alpha: 0.05),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Image Section
//                 Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(16),
//                         topRight: Radius.circular(16),
//                       ),
//                       child: Image.network(
//                         provider.profilePhoto,
//                         width: double.infinity,
//                         height: 140,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             width: double.infinity,
//                             height: 140,
//                             color: AppColors.grey.withValues(alpha: 0.4),
//                             child: const Icon(Icons.person, size: 50),
//                           );
//                         },
//                       ),
//                     ),
//                     // Work Type Badge
//                     Positioned(
//                       bottom: 8,
//                       left: 8,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColors.primary,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           provider.selectService,
//                           style: TextStyle(
//                             color: AppColors.secondary,
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Rating Badge
//                     Positioned(
//                       top: 8,
//                       right: 8,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColors.secondary,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: AppColors.textColor.withValues(alpha:0.1),
//                               blurRadius: 4,
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Icon(
//                               Icons.star,
//                               color: Color(0xFFFFC107),
//                               size: 14,
//                             ),
//                             const SizedBox(width: 3),
//                             Text(
//                               rating.toString(),
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.textColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 // Info Section
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         provider.name,
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.textColor,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                            Icon(
//                             Icons.location_on_outlined,
//                             size: 14,
//                             color: AppColors.hintText,
//                           ),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: Text(
//                               provider.location,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: AppColors.hintText,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.work_outline,
//                             size: 14,
//                             color: AppColors.hintText,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${provider.yearsOfexperience} years exp',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: AppColors.hintText,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }






import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_2/Constants/app_color.dart';
import 'package:project_2/View/service_provider_details_page/service_provider_details_page.dart';
import 'package:project_2/controllers/rating_provider/rating_provider.dart';
import 'package:project_2/model/service_model.dart';
import 'package:project_2/utilities/rating_color_helper.dart';
import 'package:provider/provider.dart';

class ServiceProviderCard extends StatelessWidget {
  final ServiceProviderModel provider;

  const ServiceProviderCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    const double rating = 4.5;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceProviderDetailsPage(provider: provider),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            // Main Card
            Container(
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textColor.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.network(
                          provider.profilePhoto,
                          width: double.infinity,
                          height: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 140,
                              color: AppColors.grey.withValues(alpha: 0.4),
                              child: const Icon(Icons.person, size: 50),
                            );
                          },
                        ),
                      ),
                      // Work Type Badge
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            provider.selectService,
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      // Rating Badge

                      Positioned(
  top: 8,
  right: 8,
  child: StreamBuilder<QuerySnapshot>(
    stream: context
        .read<RatingProvider>()
        .getProviderRatings(provider.providerId),
    builder: (context, snapshot) {

      double rating = 0;

      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
        double total = 0;

        for (var doc in snapshot.data!.docs) {
          total += (doc['rating'] ?? 0).toDouble();
        }

        rating = total / snapshot.data!.docs.length;
      }

      Color ratingColor = getRatingColor(rating);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.textColor.withValues(alpha: 0.1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             Icon(
              Icons.star,
              color: ratingColor,
              size: 14,
            ),
            const SizedBox(width: 3),
            Text(
              rating == 0 ? "New" : rating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: ratingColor,
              ),
            ),
          ],
        ),
      );
    },
  ),
),


        //               Positioned(
        //                 top: 8,
        //                 right: 8,
        //                 child: StreamBuilder(
        //                   stream: context.read<RatingProvider>().getProviderRatings(provider.providerId),
        //                   builder: (context, snapshot) {
        //                     double rating=0;
        //                     if(snapshot.hasData&&snapshot.data!.docs.isNotEmpty){
        //                       double total=0;
        //                       for (var doc in snapshot.data!.docs) {
        //   total += (doc['rating'] ?? 0).toDouble();
        // }

        // rating = total / snapshot.data!.docs.length;
        //                     }
        //                   },
        //                   return Container(
        //                     padding: const EdgeInsets.symmetric(
        //                       horizontal: 8,
        //                       vertical: 4,
        //                     ),
        //                     decoration: BoxDecoration(
        //                       color: AppColors.secondary,
        //                       borderRadius: BorderRadius.circular(12),
        //                       boxShadow: [
        //                         BoxShadow(
        //                           color: AppColors.textColor.withValues(alpha: 0.1),
        //                           blurRadius: 4,
        //                         ),
        //                       ],
        //                     ),
        //                     child: Row(
        //                       mainAxisSize: MainAxisSize.min,
        //                       children: [
        //                         const Icon(
        //                           Icons.star,
        //                           color: Color(0xFFFFC107),
        //                           size: 14,
        //                         ),
        //                         const SizedBox(width: 3),
        //                         Text(
        //                           rating.toString(),
        //                           style: TextStyle(
        //                             fontSize: 12,
        //                             fontWeight: FontWeight.bold,
        //                             color: AppColors.textColor,
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ),
                    ],
                  ),
                  // Info Section
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.hintText,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                provider.location,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.hintText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.work_outline,
                              size: 14,
                              color: AppColors.hintText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${provider.yearsOfexperience} years exp',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.hintText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}