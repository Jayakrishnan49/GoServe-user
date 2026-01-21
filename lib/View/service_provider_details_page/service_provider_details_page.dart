// import 'package:flutter/material.dart';
// import 'package:project_2/Constants/app_color.dart';
// import 'package:project_2/View/booking_request_form_page/booking_request_form_page_main.dart';
// import 'package:project_2/controllers/service_provider_details_provider/service_provider_favorite_provider.dart';
// import 'package:project_2/model/service_model.dart';
// import 'package:project_2/View/service_provider_details_page/widgets/provider_info_card.dart';
// import 'package:project_2/View/service_provider_details_page/widgets/provider_status_badge.dart';
// import 'package:project_2/View/service_provider_details_page/widgets/provider_experience_section.dart';
// import 'package:project_2/widgets/custom_button.dart';
// import 'package:provider/provider.dart';

// class ServiceProviderDetailsPage extends StatelessWidget {
//   final ServiceProviderModel provider;

//   const ServiceProviderDetailsPage({super.key, required this.provider});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.secondary,
//       body: CustomScrollView(
//         slivers: [
//           _buildAppBar(context),
//           SliverToBoxAdapter(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ProviderInfoCard(provider: provider),
//                 ProviderStatusBadge(status: provider.status),
//                 const SizedBox(height: 16),
//                 ProviderExperienceSection(
//                   yearsOfExperience: provider.yearsOfexperience,
//                   service: provider.selectService,
//                 ),
//                 const SizedBox(height: 500),
//                 Text('scroll down'),
//                 SizedBox(height: 200),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: _buildBottomBar(context),
//     );
//   }

//   Widget _buildBottomBar(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.secondary,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.textColor.withValues(alpha: 0.1),
//             blurRadius: 8,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             // Price Details Section
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'First Hour Charge',
//                     style: TextStyle(
//                       color: AppColors.textColor.withValues(alpha: 0.6),
//                       fontSize: 12,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '₹${provider.yearsOfexperience}',
//                     style: TextStyle(
//                       color: AppColors.textColor,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 16),
//             // Book Now Button
//             CustomButton(
//               text: 'Request Booking',
//               onTap: () {
//                 // Add your booking logic here
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => BookingRequestFormPage(provider: provider,)));
//               },
//               height: 50,
//               width: 200,
//               borderRadius: 12,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return SliverAppBar(
//       expandedHeight: 300,
//       pinned: true,
//       backgroundColor: AppColors.primary,
//       leading: Container(
//         margin: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: AppColors.secondary,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.textColor.withValues(alpha: 0.1),
//               blurRadius: 8,
//             ),
//           ],
//         ),
//         child: IconButton(
//           icon: Icon(Icons.arrow_back, color: AppColors.textColor),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       actions: [
//         Consumer<FavoriteProvider>(
//           builder: (context, favoriteProvider, child) {
//             final isFavorite = favoriteProvider.isFavorite(provider.providerId);
//             return Container(
//               margin: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: AppColors.secondary,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.textColor.withValues(alpha: 0.1),
//                     blurRadius: 8,
//                   ),
//                 ],
//               ),
//               child: IconButton(
//                 icon: Icon(
//                   isFavorite ? Icons.favorite : Icons.favorite_border,
//                   color: isFavorite ? Colors.red : AppColors.textColor,
//                 ),
//                 onPressed: () async {
//                   try {
//                     await favoriteProvider.toggleFavorite(provider.providerId);
//                     if (context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             isFavorite
//                                 ? 'Removed from favorites'
//                                 : 'Added to favorites',
//                           ),
//                           duration: const Duration(seconds: 1),
//                           behavior: SnackBarBehavior.floating,
//                         ),
//                       );
//                     }
//                   } catch (e) {
//                     if (context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('Error: ${e.toString()}'),
//                           backgroundColor: Colors.red,
//                           duration: const Duration(seconds: 2),
//                           behavior: SnackBarBehavior.floating,
//                         ),
//                       );
//                     }
//                   }
//                 },
//               ),
//             );
//           },
//         ),
//       ],
//       flexibleSpace: FlexibleSpaceBar(
//         background: Stack(
//           fit: StackFit.expand,
//           children: [
//             Image.network(
//               provider.profilePhoto,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   color: AppColors.grey.withValues(alpha: 0.4),
//                   child: const Icon(Icons.person, size: 80),
//                 );
//               },
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     AppColors.textColor.withValues(alpha: 0.3),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:project_2/Constants/app_color.dart';
import 'package:project_2/View/booking_request_form_page/booking_request_form_page_main.dart';
import 'package:project_2/controllers/service_provider_details_provider/service_provider_favorite_provider.dart';
import 'package:project_2/model/service_model.dart';
import 'package:project_2/View/service_provider_details_page/widgets/provider_info_card.dart';
import 'package:project_2/View/service_provider_details_page/widgets/provider_status_badge.dart';
import 'package:project_2/View/service_provider_details_page/widgets/provider_experience_section.dart';
import 'package:project_2/widgets/custom_button.dart';
import 'package:project_2/widgets/response_time_badge.dart';
import 'package:provider/provider.dart';

class ServiceProviderDetailsPage extends StatelessWidget {
  final ServiceProviderModel provider;

  const ServiceProviderDetailsPage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: CustomScrollView(
        slivers: [
          _buildModernAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // Provider Info Card
                ProviderInfoCard(provider: provider),
                
                const SizedBox(height: 16),
                
                // Status and Response Time Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(child: ProviderStatusBadge(status: provider.status)),
                      const SizedBox(width: 12),
                      ResponseTimeBadge(provider: provider),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Response Time Detail Card
                ResponseTimeCard(provider: provider),
                
                const SizedBox(height: 20),
                
                // Experience Section
                ProviderExperienceSection(
                  yearsOfExperience: provider.yearsOfexperience,
                  service: provider.selectService,
                ),
                
                const SizedBox(height: 20),
                
                // Additional Info Cards
                _buildInfoSection(context),
                
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildModernBottomBar(context),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          
          // Contact Cards
          _buildContactCard(
            icon: Icons.phone_rounded,
            title: 'Phone',
            value: provider.phoneNumber,
            color: const Color(0xFF10B981),
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            icon: Icons.email_rounded,
            title: 'Email',
            value: provider.email,
            color: const Color(0xFF3B82F6),
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            icon: Icons.location_on_rounded,
            title: 'Location',
            value: provider.location,
            color: const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Price Section
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.payments_rounded,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'First Hour Charge',
                        style: TextStyle(
                          color: AppColors.textColor.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          // letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${provider.firstHourPrice}',
                        style: const TextStyle(
                          color: Color(0xFF1F2937),
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1,
                          letterSpacing: -0.5,
                        ),
                      ),
      
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // Book Button

            CustomButton(
              text: 'Request Booking',
              onTap: () {
                // Add your booking logic here
                Navigator.push(context, MaterialPageRoute(builder: (context) => BookingRequestFormPage(provider: provider,)));
              },
              height: 50,
              width: 200,
              borderRadius: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Consumer<FavoriteProvider>(
          builder: (context, favoriteProvider, child) {
            final isFavorite = favoriteProvider.isFavorite(provider.providerId);
            return Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFavorite ? const Color(0xFFEF4444) : const Color(0xFF1F2937),
                ),
                onPressed: () async {
                  try {
                    await favoriteProvider.toggleFavorite(provider.providerId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite ? 'Removed from favorites' : 'Added to favorites',
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: const Color(0xFFEF4444),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              provider.profilePhoto,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 100,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
















// CustomSnackBar.show(
//                       context: context,
//                       title: "Favorite",
//                       message: isFavorite?'Removed from favorites':'Added to favorites',
//                       icon:isFavorite?FontAwesomeIcons.heartCrack :FontAwesomeIcons.heartCircleCheck,
//                       iconColor: Colors.pink,
//                       backgroundColor:isFavorite? const Color.fromARGB(255, 91, 9, 53):const Color.fromARGB(255, 188, 10, 105),
//                       duration: Duration(seconds: 2),
//                     );