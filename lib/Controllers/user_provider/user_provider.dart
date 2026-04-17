import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_2/model/user_model.dart';
import 'package:project_2/services/user_firebase_service.dart';

class UserProvider extends ChangeNotifier {
  final UserFirebaseService _userService = UserFirebaseService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MapController mapController = MapController();
  
  UserModel? _currentUser;
  String? userId;
  String? _gender;
  String? _imagePath;

  LatLng? _selectedLocation;
  
  // Loading states
  bool _isLoadingLocation = false;
  bool _isSavingLocation = false;
  String? _locationError;
  Position? _currentPosition;
  bool _isHomeLoading = true;
  bool _isSavingUser = false;
  String? _locationName;
  bool _isSearching = false; 
  String? _searchError;   


  // Getters
  UserModel? get currentUser => _currentUser;
  String? get imagePath => _imagePath;
  String? get gender => _gender;
  bool get isLoadingLocation => _isLoadingLocation;
  bool get isSavingLocation => _isSavingLocation;
  String? get locationError => _locationError;
  Position? get currentPosition => _currentPosition;
  bool get isHomeLoading => _isHomeLoading;
  bool get isSavingUser => _isSavingUser;
  LatLng? get selectedLocation => _selectedLocation;
  String? get locationName => _locationName;
  bool get isSearching => _isSearching;
  String? get searchError => _searchError;


  // Setters from UI
  void setGender(String? value) {
    _gender = value;
    notifyListeners();
  }

  void setImage(String path) {
    _imagePath = path;
    notifyListeners();
  }

  void clearImage() {
    _imagePath = null;
    notifyListeners();
  }

  void clearLocationError() {
    _locationError = null;
    notifyListeners();
  }

  // READ user

  
  // Future<void> fetchUser(String userId) async {
  //   _currentUser = await _userService.getUser(userId);

  //   // Sync UI state with fetched user data
  //   if (_currentUser != null) {
  //     _gender = _currentUser!.gender;
  //     _imagePath = _currentUser!.profilePhoto;
  //   }
  //   notifyListeners();
  // }

//   Future<void> fetchUser(String userId) async {
//   _isHomeLoading = true;
//   notifyListeners();

//   _currentUser = await _userService.getUser(userId);

//   if (_currentUser != null) {
//     _gender = _currentUser!.gender;
//     _imagePath = _currentUser!.profilePhoto;
//   }
  

//   _isHomeLoading = false;
//   notifyListeners();
// }




Future<void> fetchUser(String userId) async {
  _isHomeLoading = true;
  notifyListeners();

  _currentUser = await _userService.getUser(userId);

  if (_currentUser != null) {
    _gender = _currentUser!.gender;
    _imagePath = _currentUser!.profilePhoto;

    // ✅ Add this block
    if (_currentUser!.latitude != null && _currentUser!.longitude != null) {
      await fetchLocationName(
        _currentUser!.latitude!,
        _currentUser!.longitude!,
      );
    }
  }

  _isHomeLoading = false;
  notifyListeners();
}


  // Future<void> saveUser(UserModel user) async {
  //   String imageUrl;

  //   if (_imagePath != null && _imagePath!.isNotEmpty) {
  //     // Upload user-selected image
  //     final uploadedUrl = await uploadImageToCloudinary(_imagePath!);
  //     imageUrl = uploadedUrl ?? "https://res.cloudinary.com/dq4gjskwm/image/upload/v1759235279/default_profile_x437jc.png";
  //   } else {
  //     // Use default image if user didn't select any
  //     imageUrl = "https://res.cloudinary.com/dq4gjskwm/image/upload/v1759235279/default_profile_x437jc.png";
  //   }

  //   final updatedUser = user.copyWith(
  //     profilePhoto: imageUrl, 
  //     gender: _gender ?? user.gender,
  //   );

  //   await _userService.createOrUpdateUser(updatedUser);
  //   _currentUser = updatedUser;
  //   log(updatedUser.email);
  //   notifyListeners();
  // }


  Future<void> saveUser(UserModel user) async {
  _isSavingUser = true;
  notifyListeners();

  try {
    String imageUrl;

    if (_imagePath != null && _imagePath!.isNotEmpty) {
      final uploadedUrl = await uploadImageToCloudinary(_imagePath!);
      imageUrl = uploadedUrl ??
          "https://res.cloudinary.com/dq4gjskwm/image/upload/v1759235279/default_profile_x437jc.png";
    } else {
      imageUrl =
          "https://res.cloudinary.com/dq4gjskwm/image/upload/v1759235279/default_profile_x437jc.png";
    }

    final updatedUser = user.copyWith(
      profilePhoto: imageUrl,
      gender: _gender ?? user.gender,
    );

    await _userService.createOrUpdateUser(updatedUser);

    _currentUser = updatedUser;
  } finally {
    _isSavingUser = false;
    notifyListeners();
  }
}



  // UPDATE user (includes _imagePath and _gender from UI)
  // Future<void> updateUser(Map<String, dynamic> updates) async {
  //   if (_currentUser == null) return;

  //   updates['profilePhoto'] = _imagePath ?? updates['profilePhoto'];
  //   updates['gender'] = _gender ?? updates['gender'];

  //   await _userService.updateUser(_currentUser!.userId, updates);

  //   _currentUser = _currentUser!.copyWith(
  //     profilePhoto: updates['profilePhoto'],
  //     name: updates['name'] ?? _currentUser!.name,
  //     gender: updates['gender'],
  //     phoneNumber: updates['phoneNumber'] ?? _currentUser!.phoneNumber,
  //     email: updates['email'] ?? _currentUser!.email,
  //   );
  //   notifyListeners();
  // }
  Future<void> updateUser(Map<String, dynamic> updates) async {
  if (_currentUser == null) return;

  _isSavingUser = true;
  notifyListeners();

  try {
    // Upload to Cloudinary if a new local image was picked
    String? photoUrl = updates['profilePhoto'];
    if (_imagePath != null &&
        _imagePath!.isNotEmpty &&
        !_imagePath!.startsWith('http')) {
      final uploaded = await uploadImageToCloudinary(_imagePath!);
      if (uploaded != null) photoUrl = uploaded;
    }

    updates['profilePhoto'] = photoUrl ?? _currentUser!.profilePhoto;
    updates['gender'] = _gender ?? updates['gender'];

    await _userService.updateUser(_currentUser!.userId, updates);

    _currentUser = _currentUser!.copyWith(
      profilePhoto: updates['profilePhoto'],
      name: updates['name'] ?? _currentUser!.name,
      gender: updates['gender'],
      phoneNumber: updates['phoneNumber'] ?? _currentUser!.phoneNumber,
      email: updates['email'] ?? _currentUser!.email,
    );
  } finally {
    _isSavingUser = false;
    notifyListeners();
  }
}

  // DELETE user
  Future<void> deleteUser() async {
    if (_currentUser == null) return;
    await _userService.deleteUser(_currentUser!.userId);
    _currentUser = null;
    _gender = null;
    _imagePath = null;
    notifyListeners();
  }

  Future<String?> checkUserRegistration() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot userQuery = await _firestore
          .collection('users')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        this.userId = userQuery.docs.first.id;
        return this.userId;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error checking hotel registration: $e');
      return null;
    }
  }

  Future<String?> uploadImageToCloudinary(String imagePath) async {
    final cloudinary = CloudinaryPublic(
      'dq4gjskwm', 
      'user_profile_image',
      cache: false,
    );

    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imagePath,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      debugPrint("Cloudinary upload error: $e");
      return null;
    }
  }

  // Location methods
  Future<bool> requestLocationPermission() async {
    _isLoadingLocation = true;
    _locationError = null;
    notifyListeners();

    try {
      // 1. Check if location services enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationError = 'location_service_disabled';
        _isLoadingLocation = false;
        notifyListeners();
        return false;
      }

      // 2. Permission check + request
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _locationError = 'permission_denied';
        _isLoadingLocation = false;
        notifyListeners();
        return false;
      }

      if (permission == LocationPermission.deniedForever) {
        _locationError = 'permission_denied_forever';
        _isLoadingLocation = false;
        notifyListeners();
        return false;
      }

      // 3. Get location
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = pos;
      _isLoadingLocation = false;
      notifyListeners();
      return true;
    } catch (e) {
      _locationError = 'error_getting_location';
      _isLoadingLocation = false;
      notifyListeners();
      debugPrint('Error getting location: $e');
      return false;
    }
  }

  // Future<bool> saveLocationToFirestore(double lat, double lng) async {
  //   if (_currentUser == null) return false;
    
  //   _isSavingLocation = true;
  //   notifyListeners();

  //   try {
  //     final updates = {
  //       'latitude': lat,
  //       'longitude': lng,
  //       'locationUpdatedAt': DateTime.now().toIso8601String(),
  //     };
  //     await _userService.updateUser(_currentUser!.userId, updates);

  //     // update local model copy
  //     _currentUser = _currentUser!.copyWith(
  //       latitude: lat,
  //       longitude: lng,
  //       locationUpdatedAt: DateTime.now(),
  //     );
      
  //     _isSavingLocation = false;
  //     notifyListeners();
  //     return true;
  //   } catch (e) {
  //     _isSavingLocation = false;
  //     notifyListeners();
  //     debugPrint('Error saving location: $e');
  //     return false;
  //   }
  // }



  Future<bool> saveLocationToFirestore(double lat, double lng) async {
    if (_currentUser == null) return false;
    
    _isSavingLocation = true;
    notifyListeners();

    try {
      final updates = {
        'latitude': lat,
        'longitude': lng,
        'locationUpdatedAt': DateTime.now().toIso8601String(),
      };
      await _userService.updateUser(_currentUser!.userId, updates);

      _currentUser = _currentUser!.copyWith(
        latitude: lat,
        longitude: lng,
        locationUpdatedAt: DateTime.now(),
      );
      
      // ✅ Add this line
      await fetchLocationName(lat, lng);
      
      _isSavingLocation = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSavingLocation = false;
      notifyListeners();
      debugPrint('Error saving location: $e');
      return false;
    }
  }


//   Future<void> fetchLocationName(double lat, double lng) async {
//   try {
//     List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
//     if (placemarks.isNotEmpty) {
//       final place = placemarks.first;
//       _locationName = '${place.subLocality}, ${place.locality}';
//       // example output → "Mukkam, Kozhikode"
//       notifyListeners();
//     }
//   } catch (e) {
//     _locationName = null;
//     debugPrint('Reverse geocoding error: $e');
//   }
// }


Future<void> fetchLocationName(double lat, double lng) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      
      // ✅ Only include non-empty parts
      final parts = [
        place.subLocality,
        place.locality,
      ].where((part) => part != null && part.isNotEmpty).toList();
      
      _locationName = parts.join(', ');
      notifyListeners();
    }
  } catch (e) {
    _locationName = null;
    debugPrint('Reverse geocoding error: $e');
  }
}


  // ✅ Search place by name and move map camera
  Future<void> searchPlace(String query) async {
    if (query.isEmpty) return;

    _isSearching = true;
    _searchError = null;
    notifyListeners();

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        _selectedLocation = LatLng(loc.latitude, loc.longitude);
        mapController.move(_selectedLocation!, 15); 
        await fetchLocationName(loc.latitude, loc.longitude);
      } else {
        _searchError = 'Place not found. Try a different name.';
      }
    } catch (e) {
      _searchError = 'Could not find that place.';
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void setSelectedLocation(LatLng location) {
  _selectedLocation = location;
  notifyListeners();
  }


  void resetLocationState() {
  _currentPosition = null;
  _selectedLocation = null;
  _locationError = null;
  _isLoadingLocation = false;
  _isSavingLocation = false;
  _isSearching = false; 
  _searchError = null; 
  notifyListeners();
}

void resetProfileState() {
  _currentUser = null;   // 🔥 THIS WAS MISSING
  userId = null;
  _gender = null;
  _imagePath = null;
  notifyListeners();
}

}