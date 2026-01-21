

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/model/service_model.dart';
import 'package:project_2/services/payment_service.dart';
import 'package:project_2/view/payment_screen/payment_screen.dart';
import 'package:project_2/view/rating_page/rating_page.dart';
import 'package:project_2/view/service_provider_details_page/provider_details_loader_page.dart';
import 'package:project_2/view/service_provider_details_page/service_provider_details_page.dart';
import 'package:project_2/widgets/custom_button.dart';

class BookingDetailScreen extends StatelessWidget {
  final Map<String, dynamic> booking;
  final String status;

  const BookingDetailScreen({
    super.key,
    required this.booking,
    required this.status,
  });

  String _formatDate(dynamic timestamp) {
    DateTime date;
    if (timestamp is Timestamp) {
      date = timestamp.toDate();
    } else if (timestamp is DateTime) {
      date = timestamp;
    } else {
      return 'N/A';
    }
    return '${date.day} ${_getMonthName(date.month)}, ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _formatTime(String? time) {
    if (time == null) return 'N/A';
    return time;
  }

  String _formatDateTime(dynamic timestamp) {
    DateTime date;
    if (timestamp is Timestamp) {
      date = timestamp.toDate();
    } else if (timestamp is DateTime) {
      date = timestamp;
    } else {
      return 'N/A';
    }
    return '${date.day} ${_getMonthName(date.month)}, ${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatTimeOnly(dynamic timestamp) {
    DateTime date;
    if (timestamp is Timestamp) {
      date = timestamp.toDate();
    } else if (timestamp is DateTime) {
      date = timestamp;
    } else {
      return 'N/A';
    }
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $period';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'accepted':
        return const Color(0xFF2196F3);
      case 'pending':
        return const Color(0xFFFF9800);
      case 'rejected':
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }

  bool get _isWorkInProgress {
    return booking['workStartTime'] != null && booking['workEndTime'] == null;
  }

  bool get _isWorkCompleted {
    return booking['workEndTime'] != null;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrls = booking['imageUrls'] as List<dynamic>? ?? [];
    final notes = booking['notes'] as String? ?? '';
    final responseTimeMinutes = booking['responseTimeMinutes'] as int?;
    final address = booking['address'] as String? ?? '';
    final requestSentAt = booking['requestSentAt'];
    final responseAt = booking['responseAt'];
    final rejectionReason = booking['rejectionReason'] as String?;
    final workStartTime = booking['workStartTime'];
    final workEndTime = booking['workEndTime'];
    final totalWorkHours = booking['totalWorkHours'];
    final extraCharges = booking['extraCharges'];
    final totalAmount = ((booking['price'] ?? 0) + (booking['extraCharges'] ?? 0)).toDouble();

    // final ServiceProviderModel provider=ServiceProviderModel();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Booking Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card with Booking ID and Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking ID',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#${booking['id'] ?? '123'}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              status.toLowerCase() == 'completed'
                                  ? Icons.check_circle
                                  : status.toLowerCase() == 'pending'
                                      ? Icons.access_time
                                      : status.toLowerCase() == 'accepted'
                                          ? Icons.thumb_up
                                          : Icons.cancel,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              status.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Work Status Banner (show for accepted bookings with work started)
            if (status.toLowerCase() == 'accepted' && _isWorkInProgress) ...[
              const SizedBox(height: 12),
              _buildWorkInProgressBanner(),
            ],

            // Rejection Reason Section (only show if status is rejected)
            if (status.toLowerCase() == 'rejected' && rejectionReason != null && rejectionReason.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3F3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.rejected.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.rejected.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.rejected,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Rejection Reason',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.rejected,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      rejectionReason,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Service Information Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          booking['serviceImage'] ?? '',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 32,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 32,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking['serviceType'] ?? 'Service',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildIconInfoRow(
                              Icons.calendar_today,
                              _formatDate(booking['date']),
                            ),
                            const SizedBox(height: 8),
                            _buildIconInfoRow(
                              Icons.access_time,
                              _formatTime(booking['time']),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade200, height: 1),
                  const SizedBox(height: 16),
                  _buildIconInfoRow(
                    Icons.location_on,
                    address.isNotEmpty ? address : 'No address provided',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Work Timeline Section (show if work has started or completed)
            if (workStartTime != null) ...[
              _buildWorkTimelineSection(workStartTime, workEndTime, totalWorkHours, extraCharges),
              const SizedBox(height: 12),
            ],

            // Images Section (if available)
            if (imageUrls.isNotEmpty) ...[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Attached Images',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _showImageDialog(context, imageUrls[index].toString());
                            },
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imageUrls[index].toString(),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                        size: 32,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                        size: 32,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Notes Section (if available)
            if (notes.isNotEmpty) ...[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Additional Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      notes,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 12),

            // About Service Provider Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service Provider',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProviderDetailsLoaderPage(providerId: booking['providerId'])));
                        },
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: Image.network(
                              booking['providerPhoto'] ?? '',
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Icon(Icons.person, color: Colors.white);
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person, color: Colors.white);
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking['providerName'] ?? 'Provider',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking['serviceType'] ?? 'Service Expert',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            // Text(
                            //   booking['userPhone'],
                            //   style: TextStyle(
                            //     fontSize:13
                            //   ),
                            //   ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ...List.generate(
                                  5,
                                  (index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  booking['providerRating']?.toString() ?? '4.5',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          borderColor: AppColors.buttonColor,
                          text: 'Call',
                          onTap: () {
                            // Handle call

                          },
                          height: 50,
                          borderRadius: 10,
                          icon: const Icon(Icons.phone, size: 18),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if(status.toLowerCase()=='completed'&&booking['paymentStatus']=='paid'&&booking['hasRated']!=true)
                      Expanded(
                        child: CustomButton(
                          text: 'Rate',
                          onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(builder:(context) =>RatingPage(providerId: booking['providerId'] ,bookingId: booking['id'] ,),));
                          showDialog(
                            context: context,
                            builder: (_) => RatingDialog(
                              providerId: booking['providerId'],
                              bookingId: booking['id'],
                            ),
                          );

                          },
                          color: Colors.white,
                          textColor: AppColors.primary,
                          borderColor: AppColors.buttonColor,
                          height: 50,
                          borderRadius: 10,
                          icon: const Icon(Icons.star, size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),



            // ✅ Payment Confirmation Section (Only show if payment is completed)
if (status.toLowerCase() == 'completed' && booking['paymentStatus'] == 'paid') ...[
  const SizedBox(height: 12),
  Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFF4CAF50).withOpacity(0.1),
          const Color(0xFF4CAF50).withOpacity(0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFF4CAF50).withOpacity(0.3),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF4CAF50).withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Success Icon
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Successful',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Your payment has been processed',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        Divider(color: Colors.grey.shade300, height: 1),
        
        const SizedBox(height: 20),
        
        // Payment Details
        _buildPaymentInfoRow(
          label: 'Payment ID',
          value: booking['paymentId'] ?? 'N/A',
          icon: Icons.receipt_long,
        ),
        
        const SizedBox(height: 12),
        
        _buildPaymentInfoRow(
          label: 'Amount Paid',
          value: '₹${((booking['price'] ?? 0) + (booking['extraCharges'] ?? 0)).toStringAsFixed(2)}',
          icon: Icons.currency_rupee,
          valueColor: const Color(0xFF4CAF50),
          isBold: true,
        ),
        
        const SizedBox(height: 12),
        
        _buildPaymentInfoRow(
          label: 'Payment Method',
          value: booking['paymentMethod'] ?? 'Online',
          icon: Icons.payment,
        ),
        
        if (booking['paymentDate'] != null) ...[
          const SizedBox(height: 12),
          _buildPaymentInfoRow(
            label: 'Payment Date',
            value: _formatDateTime(booking['paymentDate']),
            icon: Icons.calendar_today,
          ),
        ],
        
        const SizedBox(height: 20),
        
        // Download Receipt Button (Optional)
        OutlinedButton.icon(
          onPressed: () {
            // Handle download receipt
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Receipt download feature coming soon'),
                backgroundColor: Color(0xFF4CAF50),
              ),
            );
          },
          icon: const Icon(Icons.download, size: 18),
          label: const Text('Download Receipt'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF4CAF50),
            side: const BorderSide(color: Color(0xFF4CAF50)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    ),
  ),
],




            const SizedBox(height: 24),
          ],
        ),
      ),
      // ✅ NEW: Bottom Navigation Bar for Payment
    bottomNavigationBar: status.toLowerCase() == 'completed'&&booking['paymentStatus']==null
        ? _buildPaymentBottomBar(context, totalAmount)
        : null,
    );
  }


// ✅ Helper: Payment Info Row
Widget _buildPaymentInfoRow({
  required String label,
  required String value,
  required IconData icon,
  Color? valueColor,
  bool isBold = false,
}) {
  return Row(
    children: [
      Icon(
        icon,
        size: 18,
        color: Colors.grey.shade600,
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Flexible(
        child: Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    ],
  );
}

Widget _buildPaymentBottomBar(BuildContext context, double totalAmount) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, -3),
        ),
      ],
    ),
    child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          
          const SizedBox(height: 12),
          
          // Amount and Pay Button Row
          Row(
            children: [
              // Amount Display
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    // View Details Button
                    
          TextButton(
            onPressed:() => _showPaymentDetailsSheet(context), 
            child: Row(
              children: [
                Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.info,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_up,
                  color: AppColors.info,
                  size: 28,
                )
              ],
            )
          ),
                  ],
                ),
              ),
              
              // const SizedBox(width: 16),
              
              // Pay Now Button
              CustomButton(
                text: 'Pay Now',
                width: 150,
                height: 50,
                borderRadius: 12,
                icon: const Icon(Icons.payment, size: 20),
                onTap: () {
                  final paymentService=PaymentService(
                    context: context, 
                    bookingId: booking['id'], 
                    userId: booking['userId'],
                    providerId:booking['providerId'],
                    amount: totalAmount
                    );
                    paymentService.openCheckout();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => PaymentScreen(
                  //       bookingId: booking['id'] ?? '',
                  //       userId: booking['userId'],
                  //       amount: totalAmount,
                  //     ),
                  //   ),
                  // );
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}






// ✅ Show Payment Details Bottom Sheet
void _showPaymentDetailsSheet(BuildContext context) {
  final totalAmount = ((booking['price'] ?? 0) + (booking['extraCharges'] ?? 0)).toDouble();
  final baseCharge = (booking['price'] ?? 0).toDouble();
  final extraCharges = (booking['extraCharges'] ?? 0).toDouble();
  final workHours = (booking['totalWorkHours'] ?? 0).toDouble();
  
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.receipt_long,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Payment Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Price Breakdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Base Charge
                _buildSheetPriceRow(
                  label: 'Base Charge (First Hour)',
                  amount: '₹${baseCharge.toStringAsFixed(2)}',
                  icon: Icons.access_time,
                ),
                
                // Work Duration
                if (booking['workStartTime'] != null) ...[
                  const SizedBox(height: 16),
                  _buildSheetInfoRow(
                    icon: Icons.timer_outlined,
                    label: 'Work Duration',
                    value: booking['workEndTime'] != null
                        ? '${workHours.toStringAsFixed(2)} hours'
                        : 'In Progress',
                    valueColor: booking['workEndTime'] != null 
                        ? Colors.black87 
                        : Colors.orange,
                  ),
                ],
                
                // Extra Charges
                if (extraCharges > 0) ...[
                  const SizedBox(height: 16),
                  _buildSheetPriceRow(
                    label: 'Extra Charges (₹200/hr)',
                    amount: '₹${extraCharges.toStringAsFixed(2)}',
                    icon: Icons.add_circle_outline,
                    amountColor: Colors.orange.shade700,
                  ),
                ],
                
                const SizedBox(height: 20),
                
                // Divider
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  height: 1,
                ),
                
                const SizedBox(height: 20),
                
                // Total Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '₹${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Info Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.green.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.green.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Payment is secure and processed through Razorpay',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade900,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Close Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomButton(
              text: 'Got it',
              width: double.infinity,
              height: 50,
              borderRadius: 12,
              onTap: () => Navigator.pop(context),
            ),
          ),
          
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    ),
  );
}

// ✅ Helper: Price Row for Bottom Sheet
Widget _buildSheetPriceRow({
  required String label,
  required String amount,
  required IconData icon,
  Color? amountColor,
}) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Colors.grey.shade700,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
      Text(
        amount,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: amountColor ?? Colors.black87,
        ),
      ),
    ],
  );
}

// ✅ Helper: Info Row for Bottom Sheet
Widget _buildSheetInfoRow({
  required IconData icon,
  required String label,
  required String value,
  Color? valueColor,
}) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Colors.grey.shade700,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: valueColor ?? Colors.black87,
        ),
      ),
    ],
  );
}



  // Work In Progress Banner for detail screen
  Widget _buildWorkInProgressBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4CAF50).withOpacity(0.15),
            const Color(0xFF2196F3).withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.construction_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🚀 Work in Progress',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'The service provider is actively working on your service request',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Work Timeline Section
  Widget _buildWorkTimelineSection(
    dynamic workStartTime,
    dynamic workEndTime,
    dynamic totalWorkHours,
    dynamic extraCharges,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.access_time_filled,
                  color: Color(0xFF4CAF50),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Work Timeline',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Work Start Time
          _buildTimelineItem(
            icon: Icons.play_circle_filled,
            label: 'Work Started',
            time: _formatTimeOnly(workStartTime),
            date: _formatDate(workStartTime),
            color: const Color(0xFF4CAF50),
            isCompleted: true,
          ),
          
          if (workEndTime != null) ...[
            const SizedBox(height: 16),
            // Work End Time
            _buildTimelineItem(
              icon: Icons.check_circle,
              label: 'Work Completed',
              time: _formatTimeOnly(workEndTime),
              date: _formatDate(workEndTime),
              color: const Color(0xFF2196F3),
              isCompleted: true,
            ),
            
            const SizedBox(height: 20),
            
          ]
          
        ],
      ),
    );
  }

  // Timeline Item Widget
  Widget _buildTimelineItem({
    required IconData icon,
    required String label,
    required String time,
    required String date,
    required Color color,
    required bool isCompleted,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$date at $time',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconInfoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

 
  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.broken_image_rounded,
                        color: Colors.grey,
                        size: 60,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}