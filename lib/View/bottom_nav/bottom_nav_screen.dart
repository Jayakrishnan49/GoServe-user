
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project_2/View/favorites_screen/favorites_screen.dart';
import 'package:project_2/view/booking_screen/booking_screen_main.dart';
import 'package:provider/provider.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/View/Home_screen/home_screen_main.dart';
import 'package:project_2/View/profile/profile_page_main.dart';
import '../../controllers/bottom_nav_provider/bottom_nav_provider.dart';

class MainScreenWithNavigation extends StatelessWidget {
  const MainScreenWithNavigation({super.key});

  final List<Widget> _pages = const [
    HomeScreen(),
    BookingScreen(), 
    FavoritesPage(), 
    ProfilePageMain(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          body: 
          Stack(
            children: [
              IndexedStack(
            index: navigationProvider.currentIndex,
            children: _pages,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: 
          AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            offset: navigationProvider.isBottomNavVisible
                ? const Offset(0, 0)
                : const Offset(0, 1),
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: GNav(
                gap: 8,
                activeColor: AppColors.secondary,
                iconSize: 26,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 500),
                tabBackgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                color: AppColors.grey,
                selectedIndex: navigationProvider.currentIndex,
                onTabChange: (index) {
                  navigationProvider.setIndex(index);
                },
                tabs: const [
                  GButton(icon: Icons.home, text: 'Home'),
                  GButton(icon: Icons.bookmark_add, text: 'Booked'),
                  GButton(icon: Icons.favorite, text: 'Saved'),
                  GButton(icon: Icons.person, text: 'My Profile'),
                ],
              ),
            ),
          ),
          )
            ],
          )
          
        );
      },
    );
  }
}



