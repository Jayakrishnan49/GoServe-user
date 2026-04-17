import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/bottom_nav_provider/bottom_nav_provider.dart';
import 'package:project_2/view/booking_screen/booking_list_view.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
                  'My Booking',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
          backgroundColor: AppColors.primary,
          elevation: 0,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            indicatorColor: AppColors.secondary,
            indicatorWeight: 3,
            labelColor: AppColors.secondary,
            unselectedLabelColor: AppColors.secondary.withOpacity(0.6),
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: 'Pending',icon: Icon(Icons.hourglass_bottom),),
              Tab(text: 'Accepted',icon: Icon(Icons.check_circle_outline),),
              Tab(text: 'Completed',icon: Icon(Icons.done_all),),
              Tab(text: 'Rejected',icon: Icon(Icons.cancel),)
            ],
          ),
        ),
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
                final navProvider =
                    Provider.of<NavigationProvider>(context, listen: false);

                if (notification.direction == ScrollDirection.reverse) {
                  navProvider.hideBottomNav();
                } else if (notification.direction ==
                    ScrollDirection.forward) {
                  navProvider.showBottomNav();
                }
                return true;
              },
          child: const TabBarView(
            children: [
              BookingListView(status: 'pending'),
              BookingListView(status: 'accepted'),
              BookingListView(status: 'completed'),
              BookingListView(status: 'rejected'),
            ],
          ),
        ),
      ),
    );
  }
}