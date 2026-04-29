
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2/View/booking_request_form_page/booking_request_form_page_main.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/model/service_model.dart';
import 'package:project_2/view/booking_detail_screen/booking_detail_screen.dart';
import 'package:project_2/view/booking_screen/widgets/booking_info_row.dart';
import 'package:project_2/widgets/custom_button.dart';

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final String status;

  const BookingCard({
    super.key,
    required this.booking,
    required this.status,
  });

  Color _getStatusColor() {
    switch (status) {
      case 'pending':
        return const Color(0xFFFF9800);
      case 'accepted':
        return const Color(0xFF2196F3);
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'rejected':
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case 'pending':
        return Icons.schedule_rounded;
      case 'accepted':
        return Icons.check_circle_rounded;
      case 'completed':
        return Icons.done_all_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.event;
    }
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  // Check if work is in progress
  bool get _isWorkInProgress {
    return booking['workStartTime'] != null && booking['workEndTime'] == null;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => BookingDetailScreen(
              //       booking: booking,
              //       status: status,
              //     ),
              //   ),
              // );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Image & Name Header
                _buildServiceHeader(statusColor,context),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Work in Progress Banner (only show for accepted status)
                      if (status == 'accepted' && _isWorkInProgress)
                        _buildWorkInProgressBanner(),
                      
                      if (status == 'accepted' && _isWorkInProgress)
                        const SizedBox(height: 16),

                      // Provider Info
                      _buildProviderInfo(),
                      
                      const SizedBox(height: 20),
                      
                      // Details Container
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            // Date and Time
                            BookingInfoRow(
                              icon: Icons.calendar_today_rounded,
                              label: 'Date & Time',
                              value: '${_formatDate(booking['date'])} • ${booking['time'] ?? ''}',
                            ),
                            
                            const SizedBox(height: 14),
                            
                            // Location
                            BookingInfoRow(
                              icon: Icons.location_on_rounded,
                              label: 'Location',
                              value: booking['address'] ?? '',
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Price and View Details Button
                      _buildFooter(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Work in Progress Banner
  Widget _buildWorkInProgressBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4CAF50).withOpacity(0.1),
            const Color(0xFF2196F3).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.construction_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Work in Progress',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'The service provider is currently working on your request',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          // Animated indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceHeader(Color statusColor,BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.network(
            booking['serviceImage'] ?? '',
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.image, size: 40, color: Colors.white),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.broken_image, size: 40, color: Colors.white),
                ),
              );
            },
          ),
        ),
        
        // Gradient Overlay
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.8),
              ],
              stops: const [0.3, 1.0],
            ),
          ),
        ),


              // Edit Button (top-right) - only for pending
      if (status == 'pending')
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Navigate to edit screen
                
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BookingRequestFormPage(
        provider: ServiceProviderModel(
          providerId: booking['providerId'] ?? '',
          name: booking['providerName'] ?? '',
          profilePhoto: booking['providerPhoto'] ?? '',
          selectService: booking['serviceType'] ?? '',
          phoneNumber: booking['phoneNumber'] ?? '',
          firstHourPrice: booking['price']?.toString() ?? '0',
          yearsOfexperience: '', gender: '', location: '', email: '', idCardPhoto: '', experienceCertificate: '', status: '',
          // add any other required fields with defaults
        ),
        existingBooking: booking,       // ← pass full booking map
        bookingId: booking['id'],       // ← pass the booking id
      ),
    ),
  );

              },
              icon: const Icon(
                FontAwesomeIcons.edit,
                color: Colors.white,
                size: 20,
              ),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
        ),

        
        // Content
        Positioned(
          bottom: 16,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Name
              Text(
                booking['serviceType'] ?? 'Service',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(),
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProviderInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: ClipOval(
                child: Image.network(
                  booking['providerPhoto'] ?? '',
                  width: 52,
                  height: 52,
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
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Provider',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  booking['providerName'] ?? 'Provider',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.verified_rounded,
            color: AppColors.primary,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: status=='completed'?MainAxisAlignment.spaceBetween:MainAxisAlignment.end,
      children: [
        if(status=='completed')
        booking['paymentStatus']=='paid'?Text('Paid',style: TextStyle(color: AppColors.verified),):Text('Payment Pending',style: TextStyle(color: AppColors.rejected),),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       'Total Price',
        //       style: TextStyle(
        //         fontSize: 13,
        //         color: Colors.grey.shade600,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //     const SizedBox(height: 4),
        //     Text(
        //       '₹${booking['price'] ?? '0'}',
        //       style: const TextStyle(
        //         fontSize: 28,
        //         fontWeight: FontWeight.bold,
        //         color: AppColors.primary,
        //         letterSpacing: -0.5,
        //       ),
        //     ),
        //   ],
        // ),
        CustomButton(
          text: 'Details',
          height: 48,
          width: 140,
          borderRadius: 18,
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingDetailScreen(
                  booking: booking,
                  status: status,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}