// import 'package:flutter/material.dart';
// import 'package:project_2/controllers/user_provider/user_provider.dart';
// import 'package:project_2/view/add_account_screen/widgets/profile_picture_picker.dart';
// import 'package:provider/provider.dart';

// class EditProfileTop extends StatelessWidget {
//   const EditProfileTop({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Text(
//         //   'Complete Your Profile',
//         //   style: TextStyle(
//         //     fontSize: 30,
//         //     fontFamily: 'DancingScript',
//         //     color: AppColors.primary
//         //   ),
//         // ),
//         // const SizedBox(height: 15),
//         // Text(
//         //   'Add your details',
//         //   style: TextStyle(
//         //     fontSize: 16,
//         //     fontFamily: 'DancingScript',
//         //     color: AppColors.hintText
//         //   ),
//         // ),
//         const SizedBox(height: 10),
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