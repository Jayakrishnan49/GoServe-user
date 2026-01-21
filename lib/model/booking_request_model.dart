

// import 'package:cloud_firestore/cloud_firestore.dart';

// class BookingRequest {
//   final String id;
//   final String userId;
//   final String userName;
//   final String userPhone;
//   final String userEmail;
//   final String providerId;
//   final String providerName;
//   final String serviceType;
//   final String serviceImage;
//   final DateTime date;
//   final String time;
//   final String address;
//   final String notes;
//   final List<String> imageUrls;
//   final String status; // pending, accepted, rejected, completed
//   final DateTime createdAt;
//   final double price;
//   final DateTime requestSentAt;      // When request was sent
//   final DateTime? responseAt;        // When provider responded
//   final int? responseTimeMinutes;    // Response time in minutes

//   BookingRequest({
//     required this.id,
//     required this.userId,
//     required this.userName,
//     required this.userPhone,
//     required this.userEmail,
//     required this.providerId,
//     required this.providerName,
//     required this.serviceType,
//     required this.serviceImage,
//     required this.date,
//     required this.time,
//     required this.address,
//     required this.notes,
//     required this.imageUrls,
//     required this.status,
//     required this.createdAt,
//     required this.price,
//     required this.requestSentAt,
//     this.responseAt,
//     this.responseTimeMinutes,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'userId': userId,
//       'userName': userName,
//       'userPhone': userPhone,
//       'userEmail': userEmail,
//       'providerId': providerId,
//       'providerName': providerName,
//       'serviceType': serviceType,
//       'serviceImage': serviceImage,
//       'date': Timestamp.fromDate(date),
//       'time': time,
//       'address': address,
//       'notes': notes,
//       'imageUrls': imageUrls,
//       'status': status,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'price': price,
//       'requestSentAt': Timestamp.fromDate(requestSentAt),
//       'responseAt': responseAt != null ? Timestamp.fromDate(responseAt!) : null,
//       'responseTimeMinutes': responseTimeMinutes,
//     };
//   }

//   factory BookingRequest.fromMap(Map<String, dynamic> map) {
//     return BookingRequest(
//       id: map['id'] ?? '',
//       userId: map['userId'] ?? '',
//       userName: map['userName'] ?? '',
//       userPhone: map['userPhone'] ?? '',
//       userEmail: map['userEmail'] ?? '',
//       providerId: map['providerId'] ?? '',
//       providerName: map['providerName'] ?? '',
//       serviceType: map['serviceType'] ?? '',
//       serviceImage: map['serviceImage'] ?? '',
//       date: (map['date'] as Timestamp).toDate(),
//       time: map['time'] ?? '',
//       address: map['address'] ?? '',
//       notes: map['notes'] ?? '',
//       imageUrls: List<String>.from(map['imageUrls'] ?? []),
//       status: map['status'] ?? 'pending',
//       createdAt: (map['createdAt'] as Timestamp).toDate(),
//       price: (map['price'] ?? 0).toDouble(),
//       requestSentAt: (map['requestSentAt'] as Timestamp).toDate(),
//       responseAt: map['responseAt'] != null 
//           ? (map['responseAt'] as Timestamp).toDate() 
//           : null,
//       responseTimeMinutes: map['responseTimeMinutes'],
//     );
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';

class BookingRequest {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final String userEmail;
  final String providerId;
  final String providerName;
  final String providerPhoto;
  final String serviceType;
  final String serviceImage;
  final DateTime date;
  final String time;
  final String address;
  final String notes;
  final List<String> imageUrls;
  final String status; // pending, accepted, rejected, completed
  final DateTime createdAt;
  final double price;
  final DateTime requestSentAt;
  final DateTime? responseAt;
  final int? responseTimeMinutes;
  
  // New fields for work tracking
  final DateTime? workStartTime;
  final DateTime? workEndTime;
  final double? totalWorkHours;
  final double? extraCharges;
  final DateTime? completedAt;
  final bool hasRated;

  BookingRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    required this.providerId,
    required this.providerName,
    required this.providerPhoto,
    required this.serviceType,
    required this.serviceImage,
    required this.date,
    required this.time,
    required this.address,
    required this.notes,
    required this.imageUrls,
    required this.status,
    required this.createdAt,
    required this.price,
    required this.requestSentAt,
    this.responseAt,
    this.responseTimeMinutes,
    this.workStartTime,
    this.workEndTime,
    this.totalWorkHours,
    this.extraCharges,
    this.completedAt,
    this.hasRated = false,
  });

  // Check if work is in progress
  bool get isWorkInProgress => workStartTime != null && workEndTime == null;
  
  // Check if work is completed
  bool get isWorkCompleted => workEndTime != null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'userEmail': userEmail,
      'providerId': providerId,
      'providerName': providerName,
      'providerPhoto': providerPhoto,
      'serviceType': serviceType,
      'serviceImage': serviceImage,
      'date': Timestamp.fromDate(date),
      'time': time,
      'address': address,
      'notes': notes,
      'imageUrls': imageUrls,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'price': price,
      'requestSentAt': Timestamp.fromDate(requestSentAt),
      'responseAt': responseAt != null ? Timestamp.fromDate(responseAt!) : null,
      'responseTimeMinutes': responseTimeMinutes,
      'workStartTime': workStartTime != null ? Timestamp.fromDate(workStartTime!) : null,
      'workEndTime': workEndTime != null ? Timestamp.fromDate(workEndTime!) : null,
      'totalWorkHours': totalWorkHours,
      'extraCharges': extraCharges,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'hasRated': hasRated,
    };
  }

  factory BookingRequest.fromMap(Map<String, dynamic> map) {
    return BookingRequest(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhone: map['userPhone'] ?? '',
      userEmail: map['userEmail'] ?? '',
      providerId: map['providerId'] ?? '',
      providerName: map['providerName'] ?? '',
      providerPhoto: map['providerPhoto'] ?? '',
      serviceType: map['serviceType'] ?? '',
      serviceImage: map['serviceImage'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      time: map['time'] ?? '',
      address: map['address'] ?? '',
      notes: map['notes'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      price: (map['price'] ?? 0).toDouble(),
      requestSentAt: (map['requestSentAt'] as Timestamp).toDate(),
      responseAt: map['responseAt'] != null 
          ? (map['responseAt'] as Timestamp).toDate() 
          : null,
      responseTimeMinutes: map['responseTimeMinutes'],
      workStartTime: map['workStartTime'] != null
          ? (map['workStartTime'] as Timestamp).toDate()
          : null,
      workEndTime: map['workEndTime'] != null
          ? (map['workEndTime'] as Timestamp).toDate()
          : null,
      totalWorkHours: map['totalWorkHours']?.toDouble(),
      extraCharges: map['extraCharges']?.toDouble(),
      completedAt: map['completedAt'] != null
          ? (map['completedAt'] as Timestamp).toDate()
          : null,
      hasRated: map['hasRated'] ?? false,

    );
  }
}