import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:project_2/View/category_details_screen/category_details_screen_main.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/browse_all_category_provider/browse_all_category_provider.dart';

class CategorySuggestions extends StatelessWidget {
  final BrowseAllCategoryProvider categoryProvider;

  const CategorySuggestions({
    super.key,
    required this.categoryProvider,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryProvider.categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Popular Categories',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        AnimationLimiter(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categoryProvider.categories.length,
            itemBuilder: (context, index) {
              final category = categoryProvider.categories[index];
              final image = categoryProvider.categoryImages[category];

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 750),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
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
                        style: TextStyle(
                          color: AppColors.textColor,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.textColor.withOpacity(0.5),
                      ),
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
              );
            },
          ),
        ),
      ],
    );
  }
}