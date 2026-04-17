// import 'package:flutter/material.dart';
// import 'package:project_2/constants/app_color.dart';
// import 'package:project_2/controllers/booking_provider/booking_request_provider.dart';
// import 'dart:io';

// class ImagePickerSection extends StatelessWidget {
//   final BookingRequestProvider bookingProvider;

//   const ImagePickerSection({super.key, required this.bookingProvider});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Upload photos of the work area or reference images',
//           style: TextStyle(
//             fontSize: 13,
//             color: AppColors.hintText,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 12,
//           runSpacing: 12,
//           children: [
//             ...bookingProvider.selectedImages
//                 .map((image) => _ImageThumbnail(
//                       image: image,
//                       onRemove: () => bookingProvider.removeImage(image),
//                     )),
//             if (bookingProvider.selectedImages.length < 5)
//               _AddImageButton(
//                 onTap: () async {
//                   try {
//                     await bookingProvider.pickImages();
//                   } catch (e) {
//                     if (context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('Error picking images: ${e.toString()}'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                     }
//                   }
//                 },
//               ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class _ImageThumbnail extends StatelessWidget {
//   final File image;
//   final VoidCallback onRemove;

//   const _ImageThumbnail({required this.image, required this.onRemove});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: 100,
//           height: 100,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             image: DecorationImage(
//               image: FileImage(image),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         Positioned(
//           top: 4,
//           right: 4,
//           child: GestureDetector(
//             onTap: onRemove,
//             child: Container(
//               padding: const EdgeInsets.all(4),
//               decoration: const BoxDecoration(
//                 color: Colors.red,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.close,
//                 size: 16,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _AddImageButton extends StatelessWidget {
//   final VoidCallback onTap;

//   const _AddImageButton({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: 100,
//         height: 100,
//         decoration: BoxDecoration(
//           color: AppColors.primary.withValues(alpha: 0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: AppColors.primary.withValues(alpha: 0.3),
//             width: 2,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.add_photo_alternate, color: AppColors.primary, size: 32),
//             const SizedBox(height: 4),
//             Text(
//               'Add Photo',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: AppColors.primary,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }










import 'package:flutter/material.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/booking_provider/booking_request_provider.dart';
import 'dart:io';

class ImagePickerSection extends StatelessWidget {
  final BookingRequestProvider bookingProvider;

  const ImagePickerSection({super.key, required this.bookingProvider});

  // ← total of both existing + new
  int get _totalImages =>
      bookingProvider.existingImageUrls.length +
      bookingProvider.selectedImages.length;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload photos of the work area or reference images',
          style: TextStyle(fontSize: 13, color: AppColors.hintText),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            // ← existing network images
            ...bookingProvider.existingImageUrls.map(
              (url) => _NetworkImageThumbnail(
                url: url,
                onRemove: () => bookingProvider.removeExistingImage(url),
              ),
            ),

            // ← newly picked local images
            ...bookingProvider.selectedImages.map(
              (image) => _ImageThumbnail(
                image: image,
                onRemove: () => bookingProvider.removeImage(image),
              ),
            ),

            // ← add button (max 5 total)
            if (_totalImages < 5)
              _AddImageButton(
                onTap: () async {
                  try {
                    await bookingProvider.pickImages();
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error picking images: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
          ],
        ),
      ],
    );
  }
}

// ← NEW: for existing Cloudinary URLs
class _NetworkImageThumbnail extends StatelessWidget {
  final String url;
  final VoidCallback onRemove;

  const _NetworkImageThumbnail({required this.url, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

// unchanged
class _ImageThumbnail extends StatelessWidget {
  final File image;
  final VoidCallback onRemove;

  const _ImageThumbnail({required this.image, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

// unchanged
class _AddImageButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddImageButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, color: AppColors.primary, size: 32),
            const SizedBox(height: 4),
            Text(
              'Add Photo',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}