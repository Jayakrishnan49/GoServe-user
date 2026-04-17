import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:project_2/View/category_details_screen/category_details_screen_main.dart';
import 'package:project_2/View/home_screen/home_screen_components/service_provider_list_section/service_provider_card.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/browse_all_category_provider/browse_all_category_provider.dart';
import 'package:project_2/controllers/search_filter_provider/search_provider.dart';
import 'package:provider/provider.dart';

class SearchResults extends StatelessWidget {
  final List<String> filteredCategories;
  final List<dynamic> filteredProviders;
  final BrowseAllCategoryProvider categoryProvider;

  const SearchResults({
    super.key,
    required this.filteredCategories,
    required this.filteredProviders,
    required this.categoryProvider,
  });

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    final hasFiltersApplied = searchProvider.appliedFilters.isNotEmpty;

    // When filters are applied, only show providers
    if (hasFiltersApplied) {
      return _buildProvidersOnly(context);
    }

    // When searching without filters, show both categories and providers
    return _buildCategoriesAndProviders(context);
  }

  Widget _buildProvidersOnly(BuildContext context) {
    if (filteredProviders.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.person_off, size: 64, color: Colors.grey[300]),
              Image.asset('assets/icons/worker_not_available.png',width: 300,),
              const SizedBox(height: 16),
              Text(
                'No service providers found',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your filters',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColor.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Service Providers (${filteredProviders.length})',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 12),
        _buildProvidersList(),
      ],
    );
  }

  Widget _buildCategoriesAndProviders(BuildContext context) {
    final hasResults = filteredCategories.isNotEmpty || filteredProviders.isNotEmpty;

    if (!hasResults) {
      return SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
              Image.asset('assets/search/no_search_result.png',width: 300,
              // height: 500,
                fit: BoxFit.fill,
              ),
              // const SizedBox(height: 16),
              Text(
                'No results found',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (filteredCategories.isNotEmpty) ...[
          Text(
            'Categories (${filteredCategories.length})',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildCategoriesList(context),
          const SizedBox(height: 24),
        ],
        if (filteredProviders.isNotEmpty) ...[
          Text(
            'Service Providers (${filteredProviders.length})',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildProvidersList(),
        ],
      ],
    );
  }

  Widget _buildCategoriesList(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredCategories.length,
        itemBuilder: (context, index) {
          final category = filteredCategories[index];
          final image = categoryProvider.categoryImages[category];

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      backgroundImage: (image != null && image.isNotEmpty)
                          ? NetworkImage(image)
                          : null,
                      child: (image == null || image.isEmpty)
                          ? Text(
                              category[0],
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.primary,
                              ),
                            )
                          : null,
                    ),
                    title: Text(
                      category,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryDetailsScreenMain(
                            category: category,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProvidersList() {
    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredProviders.length,
        itemBuilder: (context, index) {
          final provider = filteredProviders[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ServiceProviderCard(provider: provider),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}