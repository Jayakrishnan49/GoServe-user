import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_2/services/cloudinary_service.dart';
import 'package:project_2/services/response_time_service.dart';
import 'dart:io';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ResponseTimeService _responseTimeService = ResponseTimeService();
  final CloudinaryService _cloudinaryService = CloudinaryService(); 

  //Submit Booking Request 
  Future<void> submitBookingRequest({
    required String providerId,
    required String providerName,
    required String providerPhoto,
    required String serviceType,
    required DateTime date,
    required String time,
    required String address,
    required String notes,
    required List<File> images,
    String? price,
    required String phoneNumber,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('User not logged in');

      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      final userData = userDoc.data();

      // Fetch service image with detailed debugging
      String serviceImage = '';
      print(' Searching for service: "$serviceType"');
      
      try {
        // Try exact match first
        final serviceQuery = await _firestore
            .collection('services')
            .where('name', isEqualTo: serviceType)
            .limit(1)
            .get();
        
        if (serviceQuery.docs.isNotEmpty) {
          serviceImage = serviceQuery.docs.first.data()['image'] ?? '';
          print(' Found service with exact match!');
          print(' Service image URL: $serviceImage');
        } else {
          // If no exact match, get all services and show what's available
          print(' No exact match found. Checking all services...');
          final allServices = await _firestore.collection('services').get();
          
          print(' Total services in database: ${allServices.docs.length}');
          print(' Available services:');
          
          for (var doc in allServices.docs) {
            final data = doc.data();
            final serviceName = data['name'] ?? 'Unknown';
            print('   - "$serviceName"');
            
            // Try case-insensitive match
            if (serviceName.toString().toLowerCase() == serviceType.toLowerCase()) {
              serviceImage = data['image'] ?? '';
              print(' Found service with case-insensitive match: "$serviceName"');
              print(' Service image URL: $serviceImage');
              break;
            }
          }
          
          if (serviceImage.isEmpty) {
            print(' Could not find service image for: "$serviceType"');
          }
        }
      } catch (e) {
        print(' Error fetching service image: $e');
      }

      final requestId = _firestore
          .collection('service_provider')
          .doc(providerId)
          .collection('booking_requests')
          .doc()
          .id;

      final now = DateTime.now();

      // Upload booking images to Cloudinary
      List<String> imageUrls = [];
      if (images.isNotEmpty) {
        print(' Uploading ${images.length} images to Cloudinary...');
        imageUrls = await _cloudinaryService.uploadMultipleImages(images);
        print(' Uploaded ${imageUrls.length} images successfully');
      }

      String userProfileImage = userData?['profilePhoto'] ?? '';

      // Debug prints
      print(' Creating booking for user: ${userData?['name']}');
      print(' User profile photo URL: $userProfileImage');
      print(' Service Type: $serviceType');
      print(' Service Image: ${serviceImage.isEmpty ? "NOT FOUND" : serviceImage}');

      final bookingData = {
        'id': requestId,
        'userId': currentUser.uid,
        'userName': userData?['name'] ?? 'Unknown',
        'userProfileImage': userProfileImage,
        'userPhone': userData?['phoneNumber'] ?? '',
        'userEmail': currentUser.email ?? '',
        'providerId': providerId,
        'providerName': providerName,
        'providerPhoto': providerPhoto,
        'phoneNumber': phoneNumber,
        'serviceType': serviceType,
        'serviceImage': serviceImage, 
        'date': Timestamp.fromDate(date),
        'time': time,
        'address': address,
        'notes': notes,
        'imageUrls': imageUrls,
        'status': 'pending',
        'createdAt': Timestamp.fromDate(now),
        'price': price != null ? (double.tryParse(price) ?? 0.0) : 0.0,
        'requestSentAt': Timestamp.fromDate(now),
        'responseAt': null,
        'responseTimeMinutes': null,
      };

      // Save to provider's subcollection
      await _firestore
          .collection('service_provider')
          .doc(providerId)
          .collection('booking_requests')
          .doc(requestId)
          .set(bookingData);

      // Save to user's bookings collection
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('my_bookings')
          .doc(requestId)
          .set(bookingData);

      print('Booking request sent successfully at: $now');
    } catch (e) {
      print('Error in submitBookingRequest: $e');
      throw Exception('Failed to submit booking request: $e');
    }
  }

  //  Provider Accepts Booking 
  Future<void> acceptBooking({
    required String bookingId,
    required String providerId,
    required String userId,
  }) async {
    try {
      await _responseTimeService.recordProviderResponse(
        bookingId: bookingId,
        providerId: providerId,
        userId: userId,
        newStatus: 'accepted',
      );

      print('Booking accepted successfully');
    } catch (e) {
      throw Exception('Failed to accept booking: $e');
    }
  }

  //  Provider Rejects Booking 
  Future<void> rejectBooking({
    required String bookingId,
    required String providerId,
    required String userId,
    String? rejectionReason,
  }) async {
    try {
      await _responseTimeService.recordProviderResponse(
        bookingId: bookingId,
        providerId: providerId,
        userId: userId,
        newStatus: 'rejected',
      );

      if (rejectionReason != null && rejectionReason.isNotEmpty) {
        await _firestore
            .collection('service_provider')
            .doc(providerId)
            .collection('booking_requests')
            .doc(bookingId)
            .update({'rejectionReason': rejectionReason});

        await _firestore
            .collection('users')
            .doc(userId)
            .collection('my_bookings')
            .doc(bookingId)
            .update({'rejectionReason': rejectionReason});
      }

      print(' Booking rejected successfully');
    } catch (e) {
      throw Exception('Failed to reject booking: $e');
    }
  }



  // Update Booking Request (user edits a pending booking)
Future<void> updateBooking({
  required String bookingId,
  required String providerId,
  required String userId,
  required DateTime date,
  required String time,
  required String address,
  required String notes,
  required List<String> imageUrls,
}) async {
  try {
    final updateData = {
      'date': Timestamp.fromDate(date),
      'time': time,
      'address': address,
      'notes': notes,
      'imageUrls': imageUrls,
      'updatedAt': Timestamp.now(),
    };

    // Update in provider's subcollection
    await _firestore
        .collection('service_provider')
        .doc(providerId)
        .collection('booking_requests')
        .doc(bookingId)
        .update(updateData);

    // Update in user's bookings collection
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('my_bookings')
        .doc(bookingId)
        .update(updateData);

    print('Booking updated successfully');
  } catch (e) {
    print('Error in updateBooking: $e');
    throw Exception('Failed to update booking: $e');
  }
}





// Cancel Booking (user cancels a pending booking)
Future<void> cancelBooking({
  required String bookingId,
  required String providerId,
  required String userId,
}) async {
  try {
    // Delete from provider's subcollection
    await _firestore
        .collection('service_provider')
        .doc(providerId)
        .collection('booking_requests')
        .doc(bookingId)
        .delete();

    // Delete from user's bookings collection
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('my_bookings')
        .doc(bookingId)
        .delete();

    print('Booking cancelled successfully');
  } catch (e) {
    print('Error in cancelBooking: $e');
    throw Exception('Failed to cancel booking: $e');
  }
}





  //  Mark Booking as Completed 
  Future<void> completeBooking({
    required String bookingId,
    required String providerId,
    required String userId,
  }) async {
    try {
      final updateData = {
        'status': 'completed',
        'completedAt': Timestamp.now(),
      };

      await _firestore
          .collection('service_provider')
          .doc(providerId)
          .collection('booking_requests')
          .doc(bookingId)
          .update(updateData);

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('my_bookings')
          .doc(bookingId)
          .update(updateData);

      print('Booking marked as completed');
    } catch (e) {
      throw Exception('Failed to complete booking: $e');
    }
  }

  //  Get Provider's Response Stats 
  Future<Map<String, dynamic>> getProviderStats(String providerId) async {
    return await _responseTimeService.getProviderResponseStats(providerId);
  }
}
