// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:project_2/widgets/custom_modern_snackbar.dart';
// import 'package:project_2/widgets/loading_overlay.dart';
// import 'package:provider/provider.dart';
// import 'package:project_2/constants/app_color.dart';
// import 'package:project_2/controllers/user_provider/user_provider.dart';
// import 'package:project_2/view/bottom_nav/bottom_nav_screen.dart';
// import 'package:project_2/widgets/custom_button.dart';

// class LocationConfirmDialog extends StatelessWidget {
//   final double lat;
//   final double long;
//   final bool navigateToHomeOnConfirm; 

//   const LocationConfirmDialog({
//     super.key,
//     required this.lat,
//     required this.long,
//     this.navigateToHomeOnConfirm = true,
//   });

// //   void _confirmLocation(BuildContext context, UserProvider provider) async {
// //     // bool success = await provider.saveLocationToFirestore(lat, long);

// //     final selected = provider.selectedLocation ?? LatLng(lat, long);

// // bool success = await provider.saveLocationToFirestore(
// //   selected.latitude,
// //   selected.longitude,
// // );

// //     if (!context.mounted) return;

// //     if (success) {
// //       Navigator.of(context).pop(); // Close dialog
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(
// //           builder: (_) => const MainScreenWithNavigation(),
// //         ),
// //       );
// //     } else {
// //       // CustomSnackBar.show(
// //       //   context: context,
// //       //   title: 'Error',
// //       //   message: 'Failed to save location. Please try again.',
// //       //   icon: Icons.error_rounded,
// //       //   iconColor: Colors.red,
// //       //   accentColor: Colors.red,
// //       // );
// //       ModernSnackBar.show(
// //         context: context,
// //         title: 'Error', 
// //         message: 'Failed to save location. Please try again.',
// //         type: SnackBarType.error,
// //       );
// //     }
// //   }

// void _confirmLocation(BuildContext context, UserProvider provider) async {
//   final selected = provider.selectedLocation ?? LatLng(widget.lat, widget.long);

//   bool success = await provider.saveLocationToFirestore(
//     selected.latitude,
//     selected.longitude,
//   );

//   if (!context.mounted) return;

//   if (success) {
//     if (widget.navigateToHomeOnConfirm) {
//       // ✅ Original flow — location access screen → home
//       Navigator.of(context).pop();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const MainScreenWithNavigation()),
//       );
//     } else {
//       // ✅ Edit profile flow — just close dialog
//       Navigator.of(context).pop();
//       ModernSnackBar.show(
//         context: context,
//         title: 'Success',
//         message: 'Location saved successfully.',
//         type: SnackBarType.success,
//       );
//     }
//   } else {
//     ModernSnackBar.show(
//       context: context,
//       title: 'Error',
//       message: 'Failed to save location. Please try again.',
//       type: SnackBarType.error,
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<UserProvider>(
//       builder: (context, provider, child) {
//         final isSaving = provider.isSavingLocation;
//         final selected = provider.selectedLocation ?? LatLng(lat, long);

//         return Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding: const EdgeInsets.all(20),
//           child: LoadingOverlay(
//             isLoading: provider.isSavingLocation,
//             child: Container(
//               // constraints: BoxConstraints(maxHeight: 500),
//               decoration: BoxDecoration(
//                 color: AppColors.secondary,
//                 borderRadius: BorderRadius.circular(24),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Header
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: AppColors.primary.withOpacity(0.1),
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(24),
//                           topRight: Radius.circular(24),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: AppColors.primary,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Icon(
//                               Icons.location_on_rounded,
//                               color: AppColors.secondary,
//                               size: 24,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Confirm Your Location',
//                                   style: TextStyle(
//                                     color: AppColors.textColor,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'Is this your current location?',
//                                   style: TextStyle(
//                                     color: AppColors.hintText,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
                
//                     // Map View
//                     Container(
//                       height: 400,
//                       margin: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: AppColors.primary.withOpacity(0.2),
//                           width: 2,
//                         ),
//                       ),
//                       clipBehavior: Clip.antiAlias,
//                       child: Stack(
//                         children: [
//                           FlutterMap(
//                             options: MapOptions(
//                               initialCenter: LatLng(lat, long),
//                               initialZoom: 15,
//                               onTap: (tapPosition, point) {
//                                 provider.setSelectedLocation(point);
//                               },
//                               interactionOptions: const InteractionOptions(
//                                 flags: InteractiveFlag.pinchZoom |
//                                     InteractiveFlag.drag,
//                               ),
//                             ),
//                             children: [
//                               TileLayer(
//                                 urlTemplate:
//                                     'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                                 userAgentPackageName: 'com.goserve.user',
//                               ),
//                               MarkerLayer(
//                                 markers: [
//                                   Marker(
//                                     point: selected,
//                                     width: 50,
//                                     height: 50,
//                                     child: Stack(
//                                       alignment: Alignment.center,
//                                       children: [
//                                         Container(
//                                           width: 100,
//                                           height: 100,
//                                           decoration: BoxDecoration(
//                                             color:
//                                                 AppColors.rejected.withOpacity(0.2),
//                                             shape: BoxShape.circle,
//                                           ),
//                                         ),
//                                         Icon(
//                                           Icons.location_on,
//                                           size: 40,
//                                           color: AppColors.rejected,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           // Coordinates overlay
//                           Positioned(
//                             top: 8,
//                             right: 8,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.black87,
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   const Icon(
//                                     Icons.my_location,
//                                     size: 14,
//                                     color: Colors.white,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     // '${lat.toStringAsFixed(4)}, ${long.toStringAsFixed(4)}',
//                                     '${selected.latitude.toStringAsFixed(4)}, ${selected.longitude.toStringAsFixed(4)}',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
                
//                     // Accuracy Info
//                     // Padding(
//                     //   padding: const EdgeInsets.symmetric(horizontal: 16),
//                     //   child: Container(
//                     //     padding: const EdgeInsets.all(12),
//                     //     decoration: BoxDecoration(
//                     //       color: AppColors.primary.withOpacity(0.1),
//                     //       borderRadius: BorderRadius.circular(12),
//                     //     ),
//                     //     child: Row(
//                     //       children: [
//                     //         // Icon(
//                             //   Icons.info_outline_rounded,
//                             //   color: AppColors.primary,
//                             //   size: 20,
//                             // ),
//                             // const SizedBox(width: 8),
//                             // Expanded(
//                             //   child: Text(
//                             //     'We\'ll use this location to show nearby professionals',
//                             //     style: TextStyle(
//                             //       color: AppColors.textColor,
//                             //       fontSize: 12,
//                             //     ),
//                             //   ),
//                             // ),
//                     //       ],
//                     //     ),
//                     //   ),
//                     // ),
                
//                     // Buttons
//                     const SizedBox(width: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(FontAwesomeIcons.handPointUp),
//                         Text(' Tap on the map to adjust your location'),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(25),
//                       child: CustomButton(
//                         text: isSaving ? 'Confirming...' : 'Confirm Location',
//                         height: 50,
//                         textColor: AppColors.secondary,
//                         color: AppColors.buttonColor,
//                         borderRadius: 12,
//                         icon: isSaving
//                             ? null
//                             : Icon(
//                                 Icons.check_circle_rounded,
//                                 color: AppColors.secondary,
//                                 size: 20,
//                               ),
//                         onTap: isSaving
//                             ? null
//                             : () => _confirmLocation(context, provider),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_2/widgets/custom_modern_snackbar.dart';
import 'package:project_2/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';
import 'package:project_2/view/bottom_nav/bottom_nav_screen.dart';
import 'package:project_2/widgets/custom_button.dart';

class LocationConfirmDialog extends StatelessWidget {
  final double lat;
  final double long;
  final bool navigateToHomeOnConfirm;
  final TextEditingController _searchController = TextEditingController();

  LocationConfirmDialog({
    super.key,
    required this.lat,
    required this.long,
    this.navigateToHomeOnConfirm = true,
  });

  void _confirmLocation(BuildContext context, UserProvider provider) async {
    final selected = provider.selectedLocation ?? LatLng(lat, long);

    bool success = await provider.saveLocationToFirestore(
      selected.latitude,
      selected.longitude,
    );

    if (!context.mounted) return;

    if (success) {
      if (navigateToHomeOnConfirm) {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreenWithNavigation()),
        );
      } else {
        // Navigator.of(context).pop();
        Navigator.of(context, rootNavigator: false).pop();
        ModernSnackBar.show(
          context: context,
          title: 'Success',
          message: 'Location saved successfully.',
          type: SnackBarType.success,
        );
      }
    } else {
      ModernSnackBar.show(
        context: context,
        title: 'Error',
        message: 'Failed to save location. Please try again.',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        final isSaving = provider.isSavingLocation;
        final selected = provider.selectedLocation ?? LatLng(lat, long);

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: LoadingOverlay(
            isLoading: isSaving,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // ── Header ──────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.location_on_rounded,
                              color: AppColors.secondary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Confirm Your Location',
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Search or tap the map to set your location',
                                  style: TextStyle(
                                    color: AppColors.hintText,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Search Bar ──────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onSubmitted: (_) =>
                                      provider.searchPlace(_searchController.text),
                                  decoration: InputDecoration(
                                    hintText: 'Search a place...',
                                    hintStyle: TextStyle(color: AppColors.hintText),
                                    prefixIcon: Icon(Icons.search, color: AppColors.primary),
                                    suffixIcon: provider.isSearching
                                        ? const Padding(
                                            padding: EdgeInsets.all(12),
                                            child: SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            ),
                                          )
                                        : null,
                                    filled: true,
                                    fillColor: AppColors.primary.withOpacity(0.07),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () =>
                                    provider.searchPlace(_searchController.text),
                                child: Container(
                                  padding: const EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: AppColors.secondary,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Search error
                          if (provider.searchError != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              provider.searchError!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // ── Map ─────────────────────────────────────────
                    Container(
                      height: 350,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: provider.mapController, // ✅
                            options: MapOptions(
                              initialCenter: LatLng(lat, long),
                              initialZoom: 15,
                              onTap: (tapPosition, point) {
                                provider.setSelectedLocation(point);
                              },
                              interactionOptions: const InteractionOptions(
                                flags: InteractiveFlag.pinchZoom |
                                    InteractiveFlag.drag,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.goserve.user',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: selected,
                                    width: 50,
                                    height: 50,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: AppColors.rejected.withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Icon(
                                          Icons.location_on,
                                          size: 40,
                                          color: AppColors.rejected,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Coordinates overlay
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.my_location, size: 14, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${selected.latitude.toStringAsFixed(4)}, '
                                    '${selected.longitude.toStringAsFixed(4)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Hint ────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.handPointUp, size: 14, color: AppColors.hintText),
                        const SizedBox(width: 6),
                        Text(
                          'Tap on the map to adjust your location',
                          style: TextStyle(color: AppColors.hintText, fontSize: 13),
                        ),
                      ],
                    ),

                    // ── Confirm Button ───────────────────────────────
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: CustomButton(
                        text: isSaving ? 'Saving...' : 'Confirm Location',
                        height: 50,
                        textColor: AppColors.secondary,
                        color: AppColors.buttonColor,
                        borderRadius: 12,
                        icon: isSaving
                            ? null
                            : Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.secondary,
                                size: 20,
                              ),
                        onTap: isSaving
                            ? null
                            : () => _confirmLocation(context, provider),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}