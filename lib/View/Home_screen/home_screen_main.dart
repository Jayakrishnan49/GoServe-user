
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2/view/edit_profile_screen/edit_profile_main.dart';
import 'package:project_2/widgets/custom_modern_snackbar.dart';
import 'package:project_2/widgets/shimmer/homescreen_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:project_2/View/home_screen/home_screen_components/advertisement_section/add_section.dart';
import 'package:project_2/View/home_screen/home_screen_components/browse_all_category_section/browse_all_category_section.dart';
import 'package:project_2/View/home_screen/home_screen_components/service_provider_list_section/service_provider_list_section.dart';
import 'package:project_2/View/search_screen/search_screen_main.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/Utilities/app_validators.dart';
import 'package:project_2/Widgets/custom_text_form_field.dart';
import 'package:project_2/controllers/bottom_nav_provider/bottom_nav_provider.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';

final _searchController = TextEditingController();
final _formValidators = AppValidators();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

 

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userProvider.currentUser == null) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) userProvider.fetchUser(uid);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.secondary, 

      // ═══════════════════════ APP BAR ═══════════════════════
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(190),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF082F46), Color(0xFF0D5C8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x2D082F46),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top row: avatar + greeting + chat icon ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile avatar
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.buttonColor, Color(0xFFF0A800)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 2,
                          ),
                        ),
                        // child: Center(
                        //   child: Text(
                        //     userProvider.isHomeLoading
                        //         ? '...'
                        //         : (userProvider.currentUser?.name
                        //                     .isNotEmpty ==
                        //                 true
                        //             ? userProvider.currentUser!.name[0]
                        //                 .toUpperCase()
                        //             : 'U'),
                        //     style: const TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.w700,
                        //       fontSize: 17,
                        //     ),
                        //   ),
                        // ),
                        child: ClipOval(
  child: userProvider.currentUser?.profilePhoto != null &&
          userProvider.currentUser!.profilePhoto.isNotEmpty
      ? Image.network(
          userProvider.currentUser!.profilePhoto,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
        )
      : Container(
          color: AppColors.secondary.withOpacity(0.1),
          child: const Icon(
            Icons.person,
            color: AppColors.secondary,
            size: 22,
          ),
        ),
),
                      ),
                      const SizedBox(width: 12),

                      // Greeting text
                      Expanded(
                        child: userProvider.isHomeLoading
                            ? const Text(
                                'Loading...',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 14,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   _greetingText(),
                                  //   style: const TextStyle(
                                  //     color: Colors.white60,
                                  //     fontSize: 12,
                                  //     fontWeight: FontWeight.w400,
                                  //   ),
                                  // ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Hey, ${userProvider.currentUser?.name ?? 'there'} 👋',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                      ),

                      // Chat icon button
                      GestureDetector(
                        onTap: () {
                          ModernSnackBar.show(
                            context: context,
                            title: 'Coming soon...',
                            message: 'Chat feature will be available soon!',
                            type: SnackBarType.info,
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.commentDots,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Location chip ──
                  GestureDetector(
                    onTap: userProvider.locationName == null
                        ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditProfileScreen()),
                            )
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            FontAwesomeIcons.locationDot,
                            color: AppColors.rejected,
                            size: 13,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            userProvider.locationName ?? 'Set your location →',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Search bar ──
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SearchScreen()),
                      ),
                      child: AbsorbPointer(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A000000),
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CustomTextFormField(
                            prefixIcon: Icons.search_rounded,
                            controller: _searchController,
                            hintText: 'Search categories or services...',
                            validator: _formValidators.validateEmail,
                            enabledBorderColor: Colors.transparent,
                            focusedBorderColor: Colors.transparent,
                            borderColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // ═══════════════════════ BODY ═══════════════════════
      body: userProvider.isHomeLoading
          ? const HomeScreenShimmer()
          : NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                final navProvider =
                    Provider.of<NavigationProvider>(context, listen: false);
                if (notification.direction == ScrollDirection.reverse) {
                  navProvider.hideBottomNav();
                } else if (notification.direction == ScrollDirection.forward) {
                  navProvider.showBottomNav();
                }
                return true;
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children:  [
                      AddSection(),
                      BrowseAllCategorySection(),
                      ServiceProviderList(),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}