
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:project_2/services/booking_service.dart';
import 'package:project_2/model/service_model.dart';
import 'package:project_2/services/cloudinary_service.dart';

class BookingRequestProvider extends ChangeNotifier {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _serviceType = '';
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  // Add this field after _selectedImages
  final List<String> _existingImageUrls = [];
  
  final BookingService _bookingService = BookingService();

  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  String get serviceType => _serviceType;
  String get selectedServiceType => _serviceType;
  List<File> get selectedImages => _selectedImages;
  List<String> get existingImageUrls => _existingImageUrls;

  void initializeServiceType(String service) {
    _serviceType = service;
    notifyListeners();
  }

  void removeExistingImage(String url) {
    _existingImageUrls.remove(url);
    notifyListeners();
  }


    // ─── NEW: Pre-fill fields when editing ───────────────────────────────────
  void prefillIfEditing(Map<String, dynamic>? existingBooking) {
    final urls = existingBooking?['imageUrls'];
    if (existingBooking == null) return;

    // Address & notes
    addressController.text = existingBooking['address'] ?? '';
    notesController.text = existingBooking['notes'] ?? '';

    // Date — stored as Firestore Timestamp
    if (existingBooking['date'] != null) {
      _selectedDate = (existingBooking['date'] as Timestamp).toDate();
    }

    // Time — stored as "9:30 AM" string
    if (existingBooking['time'] != null) {
      _selectedTime = _parseTimeString(existingBooking['time']);
    }

    if (urls != null) {
      _existingImageUrls.addAll(List<String>.from(urls));
    }

    notifyListeners();
  }

  // Parses "9:30 AM" → TimeOfDay
  TimeOfDay _parseTimeString(String timeStr) {
    final parts = timeStr.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    final bool isPm = parts[1].toUpperCase() == 'PM';
    if (isPm && hour != 12) hour += 12;
    if (!isPm && hour == 12) hour = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }
  // ─────────────────────────────────────────────────────────────────────────



  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  void addImage(File image) {
    if (_selectedImages.length < 5) {
      _selectedImages.add(image);
      notifyListeners();
    }
  }

  void removeImage(File image) {
    _selectedImages.remove(image);
    notifyListeners();
  }

  // Future<void> pickImages() async {
  //   try {
  //     final List<XFile> images = await _picker.pickMultiImage();
  //     if (images.isNotEmpty) {
  //       for (var image in images) {
  //         if (_selectedImages.length < 5) {
  //           _selectedImages.add(File(image.path));
  //         }
  //       }
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }


  Future<void> pickImages() async {
  try {
    final int remaining = 5 - _existingImageUrls.length - _selectedImages.length; // ← fix
    if (remaining <= 0) return;

    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var image in images) {
        if (_selectedImages.length + _existingImageUrls.length < 5) { // ← fix
          _selectedImages.add(File(image.path));
        }
      }
      notifyListeners();
    }
  } catch (e) {
    rethrow;
  }
}

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // Helper method to format TimeOfDay to string
  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  // Submit booking method - Updated to work without price
  Future<void> submitBooking(ServiceProviderModel provider) async {
    try {
      await _bookingService.submitBookingRequest(
        providerId: provider.providerId,
        providerName: provider.name,
        providerPhoto: provider.profilePhoto,
        serviceType: _serviceType,
        date: _selectedDate!,
        time: _formatTimeOfDay(_selectedTime!),
        address: addressController.text.trim(),
        phoneNumber: provider.phoneNumber,
        notes: notesController.text.trim(),
        images: _selectedImages,
        price: provider.firstHourPrice, 
      );
    } catch (e) {
      rethrow;
    }
  }


//   Future<void> updateBooking({
//   required String bookingId,
//   required String providerId,
//   required String userId,
  
// }) async {
//   try {
//     await _bookingService.updateBooking(
//       bookingId: bookingId,
//       providerId: providerId,
//       userId: userId,
//       date: _selectedDate!,
//       time: _formatTimeOfDay(_selectedTime!),
//       address: addressController.text.trim(),
//       notes: notesController.text.trim(),
//       imageUrls: _existingImageUrls,
//     );
//   } catch (e) {
//     rethrow;
//   }
// }


Future<void> updateBooking({
  required String bookingId,
  required String providerId,
  required String userId,
}) async {
  try {
    // ← upload newly picked local images to Cloudinary
    List<String> newImageUrls = [];
    if (_selectedImages.isNotEmpty) {
      newImageUrls = await CloudinaryService().uploadMultipleImages(_selectedImages);
    }

    // ← merge: kept existing URLs + newly uploaded URLs
    final allImageUrls = [..._existingImageUrls, ...newImageUrls];

    await _bookingService.updateBooking(
      bookingId: bookingId,
      providerId: providerId,
      userId: userId,
      date: _selectedDate!,
      time: _formatTimeOfDay(_selectedTime!),
      address: addressController.text.trim(),
      notes: notesController.text.trim(),
      imageUrls: allImageUrls,   // ← pass merged list
    );
  } catch (e) {
    rethrow;
  }
}



  void reset() {
    _selectedDate = null;
    _selectedTime = null;
    _selectedImages.clear();
    _existingImageUrls.clear();
    addressController.clear();
    notesController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }
}