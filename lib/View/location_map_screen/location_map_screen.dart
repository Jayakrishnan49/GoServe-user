

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:project_2/controllers/user_provider/user_provider.dart';
// import 'package:project_2/view/bottom_nav/bottom_nav_screen.dart';
// import 'package:provider/provider.dart';

// class LocationMapScreen extends StatelessWidget {
//   final double lat;
//   final double long;

//   const LocationMapScreen({super.key, required this.lat, required this.long});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Confirm Your Location')),
//       body: FlutterMap(
//         options: MapOptions(
//           initialCenter: LatLng(lat, long),  // ✅ changed from 'center'
//           initialZoom: 15,                   // ✅ changed from 'zoom'
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//           ),
//           MarkerLayer(
//             markers: [
//               Marker(
//                 point: LatLng(lat, long),
//                 width: 40,
//                 height: 40,
//                 child: Icon(Icons.location_on, size: 40),  // ✅ changed from 'builder'
//               ),
//             ],
//           ),
//         ],
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: ElevatedButton(
//             onPressed: () async {
//               // save to firestore via provider
//               final provider = Provider.of<UserProvider>(context, listen: false);
//               await provider.saveLocationToFirestore(lat, long);

//               // navigate to main screen
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => MainScreenWithNavigation()),
//               );
//             },
//             child: Text('Continue'),
//           ),
//         ),
//       ),
//     );
//   }
// }






// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:provider/provider.dart';
// import 'package:project_2/controllers/user_provider/user_provider.dart';
// import 'package:project_2/view/bottom_nav/bottom_nav_screen.dart';

// class LocationMapScreen extends StatelessWidget {
//   final double lat;
//   final double long;

//   const LocationMapScreen({super.key, required this.lat, required this.long});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Confirm Your Location')),
//       body: FlutterMap(
//         options: MapOptions(
//           initialCenter: LatLng(lat, long), // updated param
//           initialZoom: 15,                  // updated param
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             userAgentPackageName: 'com.goserve.user', // required for OSM
//           ),
//           MarkerLayer(
//             markers: [
//               Marker(
//                 point: LatLng(lat, long),
//                 width: 40,
//                 height: 40,
//                 child: const Icon(
//                   Icons.location_on,
//                   size: 40,
//                   color: Colors.red,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: ElevatedButton(
//             onPressed: () async {
//               final provider =
//                   Provider.of<UserProvider>(context, listen: false);

//               await provider.saveLocationToFirestore(lat, long);

//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (_) => const MainScreenWithNavigation()),
//               );
//             },
//             child: const Text('Continue'),
//           ),
//         ),
//       ),
//     );
//   }
// }
