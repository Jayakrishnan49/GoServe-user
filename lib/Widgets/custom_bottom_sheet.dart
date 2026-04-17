// import 'package:flutter/material.dart';
// import 'package:project_2/constants/app_color.dart';
// import 'package:project_2/Widgets/image_picker.dart';

// // import 'image_picker_util.dart'; // Import the utility

// class CustomCameraGalleryBottomSheet extends StatelessWidget {
//   final Function(String) onImagePicked;

//   const CustomCameraGalleryBottomSheet({
//     super.key,
//     required this.onImagePicked,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 180,
//       width: double.infinity,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildIconColumn(
//             context: context,
//             icon: Icons.camera,
//             label: 'Camera',
//             onTap: () async {
//               String? imagePath = await ImagePickerUtil.pickImageFromCamera();
//               if (imagePath != null) {
//                 onImagePicked(imagePath);
//               }
//               Navigator.pop(context);
//             },
//           ),
//           _buildIconColumn(
//             context: context,
//             icon: Icons.image,
//             label: 'Gallery',
//             onTap: () async {
//               String? imagePath = await ImagePickerUtil.pickImageFromGallery();
//               if (imagePath != null) {
//                 onImagePicked(imagePath);
//               }
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildIconColumn({
//     required BuildContext context,
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: AppColors.hintText),
//             borderRadius: BorderRadius.circular(100),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: IconButton(
//               onPressed: onTap,
//               icon: Icon(icon, size: 30),
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//         Text(label, style: const TextStyle(fontSize: 15)),
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/widgets/image_picker.dart';

class CustomCameraGalleryBottomSheet extends StatelessWidget {
  final Function(String) onImagePicked;

  const CustomCameraGalleryBottomSheet({
    super.key,
    required this.onImagePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            'Update Profile Photo',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Choose a source to update your photo',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),

          const SizedBox(height: 24),

          // Options row
          Row(
            children: [
              // Camera
              Expanded(
                child: _SourceTile(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  sub: 'Take a new photo',
                  iconColor: AppColors.primary,
                  iconBg: AppColors.primary.withOpacity(0.1),
                  onTap: () async {
                    String? imagePath =
                        await ImagePickerUtil.pickImageFromCamera();
                    if (imagePath != null) {
                      onImagePicked(imagePath);
                    }
                    Navigator.pop(context);
                  },
                ),
              ),

              const SizedBox(width: 14),

              // Gallery
              Expanded(
                child: _SourceTile(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  sub: 'Pick from library',
                  iconColor: const Color(0xFFA855F7),
                  iconBg: const Color(0xFFF5F0FF),
                  onTap: () async {
                    String? imagePath =
                        await ImagePickerUtil.pickImageFromGallery();
                    if (imagePath != null) {
                      onImagePicked(imagePath);
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cancel button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Source Tile ───────────────────────────────────────────────────────────────

class _SourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color iconColor;
  final Color iconBg;
  final VoidCallback onTap;

  const _SourceTile({
    required this.icon,
    required this.label,
    required this.sub,
    required this.iconColor,
    required this.iconBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              sub,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
