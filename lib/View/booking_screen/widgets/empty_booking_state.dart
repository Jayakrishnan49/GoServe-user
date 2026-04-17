import 'package:flutter/material.dart';
import 'package:project_2/constants/app_color.dart';

class EmptyBookingState extends StatelessWidget {
  final String status;

  const EmptyBookingState({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    String message;
    IconData icon;

    switch (status) {
      case 'pending':
        message = 'No pending bookings';
        icon = Icons.schedule;
        break;
      case 'accepted':
        message = 'No accepted bookings';
        icon = Icons.check_circle_outline;
        break;
      case 'completed':
        message = 'No completed bookings';
        icon = Icons.done_all;
        break;
      default:
        message = 'No bookings';
        icon = Icons.event_busy;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.orange.withValues(alpha:0.5 ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textColor.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}