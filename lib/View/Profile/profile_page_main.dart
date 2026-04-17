
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:project_2/View/profile/about_app_section.dart';
// import 'package:project_2/View/profile/general_section.dart';
// import 'package:project_2/View/profile/logout_button.dart';
// import 'package:project_2/View/profile/profile_header.dart';
// import 'package:project_2/constants/app_color.dart';
// import 'package:project_2/controllers/bottom_nav_provider/bottom_nav_provider.dart';
// import 'package:provider/provider.dart';


// class ProfilePageMain extends StatelessWidget {
//   const ProfilePageMain({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.secondary,
//       body: NotificationListener<UserScrollNotification>(
//         onNotification: (notification) {
//           final navProvider = Provider.of<NavigationProvider>(context, listen: false);
//           if (notification.direction == ScrollDirection.reverse) {
//             navProvider.hideBottomNav();
//           } else if (notification.direction == ScrollDirection.forward) {
//             navProvider.showBottomNav();
//           }
//           return true;
//         },
//         child: Column(
//           children: [
//             const ProfileHeader(),
//             const SizedBox(height: 24),
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       GeneralSection(),
//                       const SizedBox(height: 28),
//                       AboutAppSection(),
//                       const SizedBox(height: 32),
//                       const LogoutButton(),
//                       const SizedBox(height: 32),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// class ChangePasswordPage extends StatelessWidget {
//   const ChangePasswordPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Change Password'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: const Center(
//         child: Text('Change Password Page'),
//       ),
//     );
//   }
// }

// class RateUsPage extends StatelessWidget {
//   const RateUsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Rate Us'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: const Center(
//         child: Text('Rate Us Page'),
//       ),
//     );
//   }
// }

// class PrivacyPolicyPage extends StatelessWidget {
//   const PrivacyPolicyPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Privacy Policy'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: const Center(
//         child: Text('Privacy Policy Page'),
//       ),
//     );
//   }
// }

// class TermsConditionsPage extends StatelessWidget {
//   const TermsConditionsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Terms & Conditions'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: const Center(
//         child: Text('Terms & Conditions Page'),
//       ),
//     );
//   }
// }

// class HelpSupportPage extends StatelessWidget {
//   const HelpSupportPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Help Support'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: const Center(
//         child: Text('Help Support Page'),
//       ),
//     );
//   }
// }

// // class AboutPage extends StatelessWidget {
// //   const AboutPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('About'),
// //         backgroundColor: AppColors.primary,
// //         foregroundColor: Colors.white,
// //       ),
// //       body: const Center(
// //         child: Text('About Page'),
// //       ),
// //     );
// //   }
// // }







import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_2/View/profile/profile_header.dart';
import 'package:project_2/controllers/bottom_nav_provider/bottom_nav_provider.dart';
import 'package:project_2/view/about_screen/about_screen.dart';
import 'package:project_2/view/edit_profile_screen/edit_profile_main.dart';
import 'package:project_2/view/help_and_support_screen/help_and_support_screen.dart';
import 'package:project_2/view/policy_screen/policy_screen.dart';
import 'package:project_2/widgets/custom_show_dialog.dart';
import 'package:project_2/View/auth/login_screen/login_main.dart';
import 'package:project_2/controllers/auth_provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfilePageMain extends StatelessWidget {
  const ProfilePageMain({super.key});

  void _handleLogout(BuildContext context) {
    final userProvider = Provider.of<UserAuthProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (_) => CustomShowDialog(
        title: 'Oh No, You Are Leaving...',
        subTitle: 'Are you sure want to logout',
        buttonLeft: 'No',
        buttonRight: 'Yes',
        onTap: () async {
          userProvider.logout(context);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginMain()),
            (_) => false,
          );
        },
        imagePath: 'assets/icons/logout.png',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          final nav = Provider.of<NavigationProvider>(context, listen: false);
          if (notification.direction == ScrollDirection.reverse) nav.hideBottomNav();
          else if (notification.direction == ScrollDirection.forward) nav.showBottomNav();
          return true;
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Row(
                  children: [
                    _QuickCard(
                      icon: Icons.person_outline_rounded,
                      label: 'Edit Profile',
                      sub: 'Update info',
                      iconColor: const Color(0xFF3A82F7),
                      bgColor: const Color(0xFFEEF4FF),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileScreen()));
                      },
                    ),
                    const SizedBox(width: 12),
                    _QuickCard(
                      icon: Icons.help_outline_rounded,
                      label: 'Help & Support',
                      sub: 'Get help',
                      iconColor: const Color(0xFF30D158),
                      bgColor: const Color(0xFFF0FFF4),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HelpAndSupportScreen()));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('SETTINGS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E8E93),
                      letterSpacing: 0.6,
                    )),
              ),
              const SizedBox(height: 10),
              _MenuCard(
                items: [
                  _MenuItem(
                    icon: Icons.shield_outlined,
                    iconColor: const Color(0xFF3A82F7),
                    iconBg: const Color(0xFFEEF4FF),
                    label: 'Privacy Policy',
                    sub: 'How we collect & use your data',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PolicyScreen(title: 'Privacy Policy', url: 'https://www.freeprivacypolicy.com/live/091c8f5c-782e-4170-b9ac-679f4b015d5f')));
                    },
                  ),
                  _MenuItem(
                    icon: Icons.description_outlined,
                    iconColor: const Color(0xFFA855F7),
                    iconBg: const Color(0xFFF5F0FF),
                    label: 'Terms & Conditions',
                    sub: 'Rules & guidelines for using the app', 
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PolicyScreen(title: 'Terms & Conditions', url: 'https://www.freeprivacypolicy.com/live/1b77f864-0229-420b-950e-435ec1476635')));
                    },
                  ),
                  _MenuItem(
                    icon: Icons.info_outline_rounded,
                    iconColor: const Color(0xFFFF9F0A),
                    iconBg: const Color(0xFFFFF7EC),
                    label: 'About',
                    sub: 'Version 1.0.0 · Build info & credits',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutScreen()));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _MenuCard(
                items: [
                  _MenuItem(
                    icon: Icons.logout_rounded,
                    iconColor: const Color(0xFFFF3B30),
                    iconBg: const Color(0xFFFFF0F0),
                    label: 'Log Out',
                    sub: 'You can always log back in anytime', 
                    labelColor: const Color(0xFFFF3B30),
                    chevronColor: const Color(0xFFFF3B30),
                    onTap: () => _handleLogout(context),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick Card ────────────────────────────────────────────────────────────────

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback onTap;

  const _QuickCard({
    required this.icon,
    required this.label,
    required this.sub,
    required this.iconColor,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(height: 10),
              Text(label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1C1E),
                  )),
              const SizedBox(height: 2),
              Text(sub,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8E8E93),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Menu Card ─────────────────────────────────────────────────────────────────

class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          color: Colors.white,
          child: Column(
            children: List.generate(items.length, (i) {
              return Column(
                children: [
                  items[i],
                  if (i < items.length - 1)
                    const Divider(
                        height: 1,
                        thickness: 0.5,
                        indent: 64,
                        color: Color(0xFFF2F2F7)),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ── Menu Item ─────────────────────────────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String sub;
  final Color labelColor;
  final Color chevronColor;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.sub,
    this.labelColor = const Color(0xFF1C1C1E),
    this.chevronColor = const Color(0xFFC7C7CC),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: iconColor, size: 17),
            ),
            const SizedBox(width: 14),
            // Expanded(
            //   child: Text(label,
            //       style: TextStyle(
            //         fontSize: 14,
            //         fontWeight: FontWeight.w500,
            //         color: labelColor,
            //       )),
            // ),
            Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: labelColor,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        sub,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF8E8E93),
        ),
      ),
    ],
  ),
),
            Icon(Icons.chevron_right_rounded, color: chevronColor, size: 20),
          ],
        ),
      ),
    );
  }
}