// import 'package:flutter/material.dart';
// import 'package:project_2/constants/app_color.dart';
// import 'package:project_2/controllers/user_provider/user_provider.dart';
// import 'package:project_2/view/add_account_screen/widgets/profile_picture_picker.dart';
// import 'package:provider/provider.dart';

// class AddAccountTop extends StatelessWidget {
//   const AddAccountTop({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           'Complete Your Profile',
//           style: TextStyle(
//             fontSize: 30,
//             fontFamily: 'DancingScript',
//             color: AppColors.primary
//           ),
//         ),
//         const SizedBox(height: 15),
//         Text(
//           'Add your details',
//           style: TextStyle(
//             fontSize: 16,
//             fontFamily: 'DancingScript',
//             color: AppColors.hintText
//           ),
//         ),
//         const SizedBox(height: 30),
//         Consumer<UserProvider>(
//           builder: (context, userProvider, child) {
//             return ProfilePicturePicker(
//               image: userProvider.imagePath, 
//               onImagePicked: (imagePath) {
//                 userProvider.setImage(imagePath);
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';
import 'package:project_2/view/add_account_screen/widgets/profile_picture_picker.dart';
import 'package:provider/provider.dart';

class AddAccountTop extends StatelessWidget {
  const AddAccountTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Step indicator ──
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        //   decoration: BoxDecoration(
        //     color: AppColors.primary.withOpacity(0.10),
        //     borderRadius: BorderRadius.circular(30),
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Container(
        //         width: 8,
        //         height: 8,
        //         decoration: BoxDecoration(
        //           color: AppColors.primary,
        //           shape: BoxShape.circle,
        //         ),
        //       ),
        //       const SizedBox(width: 8),
        //       Text(
        //         'Step 2 of 2',
        //         style: TextStyle(
        //           fontSize: 12,
        //           fontWeight: FontWeight.w600,
        //           color: AppColors.primary,
        //           letterSpacing: 0.5,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(height: 20),

        // ── Title ──
        Text(
          'Complete Your Profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35,
            fontFamily: 'DancingScript',
            fontWeight: FontWeight.w700,
            color: const Color.fromARGB(255, 14, 93, 139),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),

        // ── Subtitle ──
        Text(
          'Tell us a little about yourself',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'DancingScript',
            color: AppColors.hintText,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 30),

        // ── Avatar with ring ──
        Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Outer decorative ring
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.6),
                        AppColors.primary.withOpacity(0.1),
                        AppColors.primary.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
                // White gap ring
                Container(
                  width: 145,
                  height: 145,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF7F3EF),
                  ),
                ),
                // Actual picker
                SizedBox(
                  width: 140,
                  height: 140,
                  child: ProfilePicturePicker(
                    image: userProvider.imagePath,
                    onImagePicked: (imagePath) {
                      userProvider.setImage(imagePath);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}