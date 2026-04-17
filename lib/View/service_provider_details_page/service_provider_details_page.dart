import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2/View/booking_request_form_page/booking_request_form_page_main.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/rating_provider/rating_provider.dart';
import 'package:project_2/controllers/service_provider_details_provider/service_provider_favorite_provider.dart';
import 'package:project_2/model/service_model.dart';
import 'package:project_2/View/service_provider_details_page/widgets/provider_info_card.dart';
import 'package:project_2/View/service_provider_details_page/widgets/provider_experience_section.dart';
import 'package:project_2/widgets/custom_button.dart';
import 'package:project_2/widgets/custom_modern_snackbar.dart';
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

                Consumer<RatingProvider>(
  builder: (context, ratingProvider, child) {
    return StreamBuilder<QuerySnapshot>(
      stream: ratingProvider.getProviderRatings(provider.providerId),
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          ratingProvider.calculateRating(snapshot.data!);
        }

        return ProviderInfoCard(
          provider: provider,
          rating: ratingProvider.avgRating,
          totalReviews: ratingProvider.reviewCount,
        );
      },
    );
  },
),
                // ProviderInfoCard(provider: provider),
                
                const SizedBox(height: 16),
 
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
                
                // const SizedBox(height: 120),

                const SizedBox(height: 25),
                _buildReviewsSection(context),
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
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: 
        IconButton(
          icon: const Icon(Icons.arrow_back_rounded,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Consumer<FavoriteProvider>(
          builder: (context, favoriteProvider, child) {
            final isFavorite = favoriteProvider.isFavorite(provider.providerId);
            return Container(
              margin: const EdgeInsets.all(6),
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
                  isFavorite ? Icons.favorite_rounded : FontAwesomeIcons.heart,
                  color: isFavorite ? const Color(0xFFEF4444) : const Color(0xFF1F2937),
                ),
                onPressed: () async {
                  try {
                    await favoriteProvider.toggleFavorite(provider.providerId);
                    if (context.mounted) {
 
                      ModernSnackBar.show(
                        context: context,
                        message: isFavorite?'Removed from favorites' : 'Added to favorites',
                        customIcon: isFavorite?Icons.heart_broken :Icons.favorite,
                        customColor: AppColors.favorite,
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


  Widget _buildReviewsSection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),

        // StreamBuilder<QuerySnapshot>(
        //   stream: FirebaseFirestore.instance
        //       .collection('ratings')
        //       .where('providerId', isEqualTo: provider.providerId)
        //       .orderBy('createdAt', descending: true)
        //       .snapshots(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(child: CircularProgressIndicator());
        //     }

        //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        //       return _emptyReviewState();
        //     }

        //     return Column(
        //       children: snapshot.data!.docs.map((doc) {
        //         final data = doc.data() as Map<String, dynamic>;
        //         return _reviewCard(data);
        //       }).toList(),
        //     );
        //   },
        // ),

        StreamBuilder<QuerySnapshot>(
  stream: context.read<RatingProvider>().getProviderReviews(provider.providerId),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return _emptyReviewState();
    }

    return Column(
      children: snapshot.data!.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return _reviewCard(data);
      }).toList(),
    );
  },
)
      ],
    ),
  );
}


Widget _reviewCard(Map<String, dynamic> data) {
  final rating = (data['rating'] ?? 0).toDouble();
  final review = data['review'] ?? '';
  final createdAt = data['createdAt'] as Timestamp?;
  final userId = data['userId'];

  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get(),
    builder: (context, snapshot) {

      String userName = "User";
      String? profilePic;

      if (snapshot.hasData && snapshot.data!.exists) {
        final userData =
            snapshot.data!.data() as Map<String, dynamic>;
        userName = userData['name'] ?? "User";
        profilePic = userData['profilePhoto']; // 👈 your field name
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 Avatar + Name + Stars Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                /// Profile Image
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: profilePic != null
                      ? NetworkImage(profilePic)
                      : null,
                  child: profilePic == null
                      ? const Icon(Icons.person, size: 20)
                      : null,
                ),

                const SizedBox(width: 12),

                /// Name + Rating
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                                
                const SizedBox(height: 4),
                                

              ],
            ),
            SizedBox(height: 10,),
            Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < rating.round()
                          ? Icons.star
                          : Icons.star_border,
                      size: 16,
                      color: AppColors.rating,
                    ),
                  ),
                ),

            const SizedBox(height: 15),

            /// Review text
            Text(
              review,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 8),

            /// Date
            if (createdAt != null)
              Text(
                _formatReviewDate(createdAt.toDate()),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
          ],
        ),
      );
    },
  );
}

Widget _emptyReviewState() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Center(
      child: Text(
        'No reviews yet',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    ),
  );
}

  String _formatReviewDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
