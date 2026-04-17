import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/Widgets/custom_bottom_sheet.dart';

class ProfilePicturePicker extends StatelessWidget {
  final String? image;
  final Function(String imagePath) onImagePicked;

  const ProfilePicturePicker({
    super.key,
    required this.onImagePicked,
    this.image,
  });

  // @override
  // Widget build(BuildContext context) {
  //   return Stack(
  //     children: [
     
  //       Container(
  //         padding: EdgeInsets.all(3), // thickness of the border
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           border: Border.all(
  //             color: AppColors.primary, // border color
  //             width: 3, // border width
  //           ),
  //         ),
  //         child: CircleAvatar(
  //           radius: 65,
  //           backgroundImage: image != null ? FileImage(File(image!)) : null,
  //           child: image == null ? Icon(FontAwesomeIcons.user, size: 50) : null,
  //         ),
  //       ),

  //       Positioned(
  //         bottom: 5,
  //         right: 1,
  //         child: InkWell(
  //           child: Container(
  //             width: 50,
  //             height: 50,
  //             decoration: BoxDecoration(
  //               color: AppColors.buttonColor,
  //               borderRadius: BorderRadius.circular(100),
  //             ),
  //             child: Icon(
  //               Icons.camera_alt_outlined,
  //               size: 30,
  //               color: AppColors.secondary,
  //             ),
  //           ),
  //           onTap: () {
  //             showModalBottomSheet(
  //               context: context,
  //               builder: (context) {
  //                 return CustomCameraGalleryBottomSheet(
  //                   onImagePicked: (imagePath) {
  //                     onImagePicked(imagePath);
  //                   },
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }



@override
Widget build(BuildContext context) {
  return SizedBox(
    width: 104,
    height: 104,
    child: Stack(
      clipBehavior: Clip.none, // allows camera icon to overflow outside
      children: [
        // Avatar — fill the full SizedBox
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 3,
              ),
            ),
            child: 
            // CircleAvatar(
            //   backgroundImage: image != null ? FileImage(File(image!)) : null,
            //   child: image == null
            //       ? Icon(FontAwesomeIcons.user, size: 36)
            //       : null,
            // ),
            CircleAvatar(
  backgroundImage: image != null
      ? (image!.startsWith('http')
          ? NetworkImage(image!) as ImageProvider
          : FileImage(File(image!)))
      : null,
  child: image == null
      ? Icon(FontAwesomeIcons.user, size: 36)
      : null,
),
          ),
        ),

        // Camera button
        Positioned(
          bottom: -4,
          right: -4,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return CustomCameraGalleryBottomSheet(
                    onImagePicked: (imagePath) {
                      onImagePicked(imagePath);
                    },
                  );
                },
              );
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.buttonColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                size: 30,
                color: AppColors.secondary,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

}
