import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_2/Constants/app_color.dart';
import 'package:project_2/controllers/bottom_nav_provider/bottom_nav_provider.dart';
import 'package:project_2/controllers/service_provider_details_provider/service_provider_favorite_provider.dart';
import 'package:project_2/services/service_provider_details_service.dart';
import 'package:project_2/model/service_model.dart';
import 'package:project_2/View/home_screen/home_screen_components/service_provider_list_section/service_provider_card.dart';
import 'package:project_2/widgets/shimmer/favorite_screen_shimmer.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(   
        centerTitle: true, 
        title: Text(
                  'My favorites',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
                final navProvider =
                    Provider.of<NavigationProvider>(context, listen: false);

                if (notification.direction == ScrollDirection.reverse) {
                  navProvider.hideBottomNav();
                } else if (notification.direction ==
                    ScrollDirection.forward) {
                  navProvider.showBottomNav();
                }
                return true;
              },
        child: Consumer<FavoriteProvider>(
          builder: (context, favoriteProvider, child) {
            if (favoriteProvider.isLoading) {
              return const FavoritesScreenShimmer();
            }
        
            if (favoriteProvider.favoriteIds.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/favorites/favorites_new_img.png',
                      // height: 500,
                      width: 300,
                    ),
                    Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start adding your favorite service providers',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.hintText,
                      ),
                    ),
                  ],
                ),
              );
            }
        
            return FutureBuilder<List<ServiceProviderModel>>(
              future: _getFavoriteProviders(
                favoriteProvider.favoriteIds.toList(),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const FavoritesScreenShimmer();
                }
        
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading favorites',
                      style: TextStyle(color: AppColors.hintText),
                    ),
                  );
                }
        
                final providers = snapshot.data ?? [];
        
                if (providers.isEmpty) {
                  return Center(
                    child: Text(
                      'No providers found',
                      style: TextStyle(color: AppColors.hintText),
                    ),
                  );
                }
        
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    return ServiceProviderCard(provider: providers[index]);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<ServiceProviderModel>> _getFavoriteProviders(
      List<String> favoriteIds) async {
    final service = ServiceProviderDetailsService();
    final providers = <ServiceProviderModel>[];

    for (String id in favoriteIds) {
      final provider = await service.getWork(id);
      if (provider != null) {
        providers.add(provider);
      }
    }

    return providers;
  }
}