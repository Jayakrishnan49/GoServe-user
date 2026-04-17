// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:project_2/constants/app_color.dart';
// import 'package:project_2/View/bottom_nav/bottom_nav_screen.dart';
// import 'package:project_2/Widgets/custom_button.dart';
// import 'package:project_2/view/location_map_screen/location_map_screen.dart';

// class LocationAccessScreen extends StatelessWidget {
//   const LocationAccessScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.secondary,
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/location_access/location_access.png'),
//             Text(
//               'Allow location access ?',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'We need your location access to easily find professionals around you',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.hintText,
//                 // fontSize: 20
//               ),
//             ),
//             SizedBox(height: 50),
//             CustomButton(
//               text: 'Allow location access',
//               width: 400,
//               borderRadius: 15,
//               onTap: () async {
//   // 1. check if location services enabled
//   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     // show dialog asking user to enable location services
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Location Service Disabled"),
//         content: Text("Please enable Location Service in settings."),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("OK"),
//           )
//         ],
//       ),
//     );
//     return;
//   }

//   // 2. permission check + request
//   LocationPermission permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//   }

//   if (permission == LocationPermission.denied) {
//     // show message: permission denied
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Location permission denied')),
//     );
//     return;
//   }

//   if (permission == LocationPermission.deniedForever) {
//     // open app settings (uses permission_handler)
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Permission Permanently Denied"),
//         content: Text(
//             "Please enable location permission from app settings."),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("OK"),
//           )
//         ],
//       ),
//     );
//     return;
//   }

//   // 3. get location
//   Position pos = await Geolocator.getCurrentPosition(
//     desiredAccuracy: LocationAccuracy.high,
//   );

//   // 4. show map preview screen with position
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => LocationMapScreen(lat: pos.latitude, long: pos.longitude),
//     ),
//   );
// }

//             ),
//             SizedBox(height: 20),
//             InkWell(
//               onTap: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => MainScreenWithNavigation(),
//                   ),
//                 );
//               },
//               child: Text(
//                 'Skip this step',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   decoration: TextDecoration.underline,
//                   // fontWeight: FontWeight.bold,
//                   color: AppColors.primary,
//                   // fontSize: 20
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_2/widgets/custom_modern_snackbar.dart';
import 'package:project_2/widgets/location_confirm_dialog.dart';
import 'package:provider/provider.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';
import 'package:project_2/widgets/custom_button.dart';

class LocationAccessScreen extends StatelessWidget {
  const LocationAccessScreen({super.key});

  void _handleLocationAccess(BuildContext context, UserProvider provider) async {
    // Clear any previous errors
    provider.clearLocationError();

    // Request location permission and get location
    bool success = await provider.requestLocationPermission();

    if (!context.mounted) return;

    // Handle errors
    if (!success) {
      String title;
      String message;
      IconData icon;
      Color iconColor;

      switch (provider.locationError) {
        case 'location_service_disabled':
          title = 'Location Service Disabled';
          message = 'Please enable location services in your device settings';
          icon = Icons.location_off_rounded;
          iconColor = Colors.red;
          break;
        case 'permission_denied':
          title = 'Permission Denied';
          message = 'Location permission is required to find professionals near you';
          icon = Icons.block_rounded;
          iconColor = Colors.orange;
          break;
        case 'permission_denied_forever':
          title = 'Permission Permanently Denied';
          message = 'Please enable location permission from app settings';
          icon = Icons.settings_rounded;
          iconColor = Colors.red;
          break;
        case 'error_getting_location':
          title = 'Error';
          message = 'Failed to get location. Please try again.';
          icon = Icons.error_rounded;
          iconColor = Colors.red;
          break;
        default:
          title = 'Error';
          message = 'Something went wrong. Please try again.';
          icon = Icons.error_rounded;
          iconColor = Colors.red;
      }

      // CustomSnackBar.show(
      //   context: context,
      //   title: title,
      //   message: message,
      //   icon: icon,
      //   iconColor: iconColor,
      //   accentColor: iconColor,
      //   duration: provider.locationError == 'permission_denied_forever'
      //       ? const Duration(seconds: 7)
      //       : const Duration(seconds: 5),
      // );
      ModernSnackBar.show(
  context: context,
  title: title,
  message: message,
  type: provider.locationError == 'permission_denied'
      ? SnackBarType.warning
      : SnackBarType.error,
);
      if (provider.locationError == 'location_service_disabled') {
  await Geolocator.openLocationSettings();
} else if (provider.locationError == 'permission_denied_forever') {
  await Geolocator.openAppSettings();
}
      return;
    }

    // Show confirmation dialog with map
    if (provider.currentPosition != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => LocationConfirmDialog(
          lat: provider.currentPosition!.latitude,
          long: provider.currentPosition!.longitude,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        final isLoading = provider.isLoadingLocation;

        return Scaffold(
          backgroundColor: AppColors.secondary,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/location_access/location_access.png'),
                        const Text(
                          'Allow location access ?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'We need your location access to easily find professionals around you',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.hintText,
                          ),
                        ),
                        const SizedBox(height: 50),
                        CustomButton(
                          text: isLoading
                              ? 'Getting Location...'
                              : 'Allow Location Access',
                          width: 400,
                          borderRadius: 15,
                          onTap: isLoading
                              ? null
                              : () => _handleLocationAccess(context, provider),
                        ),
                        // const SizedBox(height: 20),
                        // InkWell(
                        //   onTap: isLoading
                        //       ? null
                        //       : () {
                        //           provider.resetLocationState();
                        //           Navigator.pushReplacement(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) =>
                        //                   const MainScreenWithNavigation(),
                        //             ),
                        //           );
                        //         },
                        //   child: Text(
                        //     'Skip this step',
                        //     textAlign: TextAlign.center,
                        //     style: TextStyle(
                        //       decoration: TextDecoration.underline,
                        //       color: isLoading
                        //           ? AppColors.hintText
                        //           : AppColors.primary,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black26,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Getting your location...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}