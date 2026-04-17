

// // import 'package:flutter/material.dart';
// // import 'package:project_2/controllers/user_provider/user_provider.dart';
// // import 'package:provider/provider.dart';
// // import 'package:project_2/constants/app_color.dart';

// // class ProfileHeader extends StatelessWidget {
// //   const ProfileHeader({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final userProvider = Provider.of<UserProvider>(context);
// //     final user = userProvider.currentUser;

// //     final name = user?.name ?? 'Guest';
// //     final email = user?.email ?? 'No email';
// //     final imageUrl = user?.profilePhoto??
// //         "https://res.cloudinary.com/dq4gjskwm/image/upload/v1759235279/default_profile_x437jc.png";

// //     return Container(
// //       width: double.infinity,
// //       decoration: BoxDecoration(
// //         borderRadius: const BorderRadius.only(
// //           bottomLeft: Radius.circular(100),
// //           bottomRight: Radius.circular(100),
// //         ),
// //         gradient: LinearGradient(
// //           begin: Alignment.topCenter,
// //           end: Alignment.bottomCenter,
// //           colors: [
// //             AppColors.primary,
// //             AppColors.primary.withValues(alpha: 0.9),
// //           ],
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: AppColors.primary.withValues(alpha: 0.3),
// //             blurRadius: 20,
// //             offset: const Offset(0, 10),
// //           ),
// //         ],
// //       ),
// //       child: SafeArea(
// //         bottom: false,
// //         child: Padding(
// //           padding: const EdgeInsets.only(bottom: 40),
// //           child: Column(
// //             children: [
// //               const SizedBox(height: 20),
// //               _buildProfileImage(imageUrl),
// //               const SizedBox(height: 20),
// //               Text(
// //                 name,
// //                 style: const TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.white,
// //                   letterSpacing: 0.5,
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               _buildEmail(email),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildProfileImage(String imageUrl) {
// //   return Stack(
// //     children: [
// //       Container(
// //         width: 130,
// //         height: 130,
// //         decoration: BoxDecoration(
// //           shape: BoxShape.circle,
// //           border: Border.all(
// //             color: Colors.white.withOpacity(0.3),
// //             width: 4,
// //           ),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.2),
// //               blurRadius: 15,
// //               offset: const Offset(0, 8),
// //             ),
// //           ],
// //         ),
// //         child: ClipOval(
// //           child: Image.network(
// //             imageUrl,
// //             fit: BoxFit.cover,
// //             loadingBuilder: (context, child, loadingProgress) {
// //               if (loadingProgress == null) return child;
// //               return Container(
// //                 color: Colors.grey.shade300,
// //                 child: const Icon(
// //                   Icons.person,
// //                   size: 50,
// //                   color: Colors.white,
// //                 ),
// //               );
// //             },
// //             errorBuilder: (context, error, stackTrace) {
// //               return Container(
// //                 color: Colors.grey.shade300,
// //                 child: const Icon(
// //                   Icons.person,
// //                   size: 50,
// //                   color: Colors.white,
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //       ),

// //       // Edit button
// //       Positioned(
// //         bottom: 5,
// //         right: 5,
// //         child: Container(
// //           width: 40,
// //           height: 40,
// //           decoration: BoxDecoration(
// //             color: AppColors.secondary,
// //             shape: BoxShape.circle,
// //             border: Border.all(
// //               color: AppColors.primary,
// //               width: 3,
// //             ),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.black.withOpacity(0.15),
// //                 blurRadius: 8,
// //                 offset: const Offset(0, 4),
// //               ),
// //             ],
// //           ),
// //           child: Icon(
// //             Icons.edit_rounded,
// //             size: 20,
// //             color: AppColors.primary,
// //           ),
// //         ),
// //       ),
// //     ],
// //   );
// // }


// //   // Widget _buildProfileImage(String imageUrl) {
// //   //   return Stack(
// //   //     children: [
// //   //       Container(
// //   //         width: 130,
// //   //         height: 130,
// //   //         decoration: BoxDecoration(
// //   //           shape: BoxShape.circle,
// //   //           border: Border.all(
// //   //             color: Colors.white.withValues(alpha: 0.3),
// //   //             width: 4,
// //   //           ),
// //   //           boxShadow: [
// //   //             BoxShadow(
// //   //               color: Colors.black.withValues(alpha: 0.2),
// //   //               blurRadius: 15,
// //   //               offset: const Offset(0, 8),
// //   //             ),
// //   //           ],
// //   //           image: DecorationImage(
// //   //             image: NetworkImage(imageUrl),
// //   //             fit: BoxFit.cover,
// //   //           ),
// //   //         ),
// //   //       ),
// //   //       Positioned(
// //   //         bottom: 5,
// //   //         right: 5,
// //   //         child: Container(
// //   //           width: 40,
// //   //           height: 40,
// //   //           decoration: BoxDecoration(
// //   //             color: AppColors.secondary,
// //   //             shape: BoxShape.circle,
// //   //             border: Border.all(
// //   //               color: AppColors.primary,
// //   //               width: 3,
// //   //             ),
// //   //             boxShadow: [
// //   //               BoxShadow(
// //   //                 color: Colors.black.withValues(alpha: 0.15),
// //   //                 blurRadius: 8,
// //   //                 offset: const Offset(0, 4),
// //   //               ),
// //   //             ],
// //   //           ),
// //   //           child: Icon(
// //   //             Icons.edit_rounded,
// //   //             size: 20,
// //   //             color: AppColors.primary,
// //   //           ),
// //   //         ),
// //   //       ),
// //   //     ],
// //   //   );
// //   // }

// //   Widget _buildEmail(String email) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withValues(alpha: 0.2),
// //         borderRadius: BorderRadius.circular(20),
// //       ),
// //       child: Text(
// //         email,
// //         style: const TextStyle(
// //           fontSize: 12,
// //           color: Colors.white,
// //           fontWeight: FontWeight.w500,
// //         ),
// //       ),
// //     );
// //   }
// // }








// import 'package:flutter/material.dart';
// import 'package:project_2/controllers/user_provider/user_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:project_2/constants/app_color.dart';

// class ProfileHeader extends StatelessWidget {
//   const ProfileHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     final user = userProvider.currentUser;

//     final name = user?.name ?? 'Guest';
//     final email = user?.email ?? 'No email';
//     final phone = user?.phoneNumber ?? '';
//     final imageUrl = user?.profilePhoto ??
//         "https://res.cloudinary.com/dq4gjskwm/image/upload/v1759235279/default_profile_x437jc.png";

//     return Column(
//       children: [
//         // Top app bar
//         // Container(
//         //   color: AppColors.primary,
//         //   child: const Padding(
//         //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         //     child: Center(
//         //       child: Text(
//         //         'Profile',
//         //         style: TextStyle(
//         //           color: Colors.white,
//         //           fontSize: 20,
//         //           fontWeight: FontWeight.w700,
//         //           letterSpacing: 0.3,
//         //         ),
//         //       ),
//         //     ),
//         //   ),
//         // ),

//         // White profile card sitting inside the primary-colored area
//         Container(
//           // color: AppColors.primary,
//           padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.08),
//                   blurRadius: 16,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 // Avatar with primary-colored ring
//                 Container(
//                   padding: const EdgeInsets.all(3),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: AppColors.primary, width: 3),
//                   ),
//                   child: ClipOval(
//                     child: Image.network(
//                       imageUrl,
//                       width: 120,
//                       height: 120,
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return Container(
//                           width: 90,
//                           height: 90,
//                           color: Colors.grey.shade100,
//                           child: const Icon(Icons.person, size: 40, color: Colors.grey),
//                         );
//                       },
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           width: 90,
//                           height: 90,
//                           color: Colors.grey.shade100,
//                           child: const Icon(Icons.person, size: 40, color: Colors.grey),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 14),

//                 // Name
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w800,
//                     color: Color(0xFF1A1A1A),
//                     letterSpacing: 0.2,
//                   ),
//                 ),
//                 const SizedBox(height: 8),

//                 // Phone (only shown if available)
//                 if (phone.isNotEmpty) ...[
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.phone_outlined, size: 15, color: Colors.grey.shade500),
//                       const SizedBox(width: 6),
//                       Text(
//                         phone,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade600,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                 ],

//                 // Email
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.email_outlined, size: 15, color: Colors.grey.shade500),
//                     const SizedBox(width: 6),
//                     Text(
//                       email,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }









import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    final name = user?.name ?? 'Guest';
    final email = user?.email ?? 'No email';
    final phone = user?.phoneNumber ?? '';
    final imageUrl = user?.profilePhoto ?? '';

    return Container(
      color: AppColors.primary,
      child: Stack(
        children: [
          // Decorative orbs
          Positioned(
            top: -60, right: -40,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF5856D6).withOpacity(0.18),
              ),
            ),
          ),
          Positioned(
            top: 20, left: -60,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF34C759).withOpacity(0.10),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 60, 22, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text('MY PROFILE',
                    //     style: TextStyle(
                    //       fontSize: 11, fontWeight: FontWeight.w600,
                    //       letterSpacing: 0.9, color: Color(0x66FFFFFF),
                    //     )),
                    // const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 76, height: 76,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFF5856D6), Color(0xFFAF52DE)],
                                ),
                              ),
                              child: imageUrl.isEmpty
                                  ? const Icon(Icons.person, color: Colors.white, size: 36)
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Image.network(imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.person, color: Colors.white, size: 36)),
                                    ),
                            ),
                            Positioned(
                              bottom: -3, right: -3,
                              child: Container(
                                width: 16, height: 16,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF34C759),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF1C1C1E), width: 2.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: const TextStyle(
                                      fontSize: 21, fontWeight: FontWeight.w700,
                                      color: Colors.white, letterSpacing: -0.4,
                                    )),
                                const SizedBox(height: 5),
                                Row(children: [
                                  Icon(FontAwesomeIcons.at, size: 12, color: Colors.white.withOpacity(0.4)),
                                  const SizedBox(width: 5),
                                  Text(email, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.45))),
                                ]),
                                if (phone.isNotEmpty) ...[
                                  const SizedBox(height: 3),
                                  Row(children: [
                                    Icon(Icons.phone_outlined, size: 12, color: Colors.white.withOpacity(0.4)),
                                    const SizedBox(width: 5),
                                    Text(phone, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.45))),
                                  ]),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    // Stats row
                    Row(
                      children: [
                        _StatChip(value: '48', label: 'Orders'),
                        const SizedBox(width: 10),
                        _StatChip(value: '12', label: 'Wishlist'),
                        const SizedBox(width: 10),
                        _StatChip(value: '4.9', label: 'Rating'),
                      ],
                    ),
                  ],
                ),
              ),
              // Curved cutout into light background
              Container(
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700,
                  color: Colors.white, letterSpacing: -0.5,
                )),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                  fontSize: 11, color: Colors.white.withOpacity(0.4),
                )),
          ],
        ),
      ),
    );
  }
}