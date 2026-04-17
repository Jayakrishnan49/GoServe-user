import 'package:flutter/material.dart';
import 'package:project_2/View/booking_request_form_page/widgets/address_field.dart';
import 'package:project_2/View/booking_request_form_page/widgets/date_time_selectors.dart';
import 'package:project_2/View/booking_request_form_page/widgets/image_picker_section.dart';
import 'package:project_2/View/booking_request_form_page/widgets/notes_field.dart';
import 'package:project_2/View/booking_request_form_page/widgets/price_summary_card.dart';
import 'package:project_2/View/booking_request_form_page/widgets/provider_summary_card.dart';
import 'package:project_2/View/booking_request_form_page/widgets/service_type_field.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/booking_provider/booking_request_provider.dart';
import 'package:project_2/controllers/bottom_nav_provider/bottom_nav_provider.dart';
import 'package:project_2/model/service_model.dart';
import 'package:project_2/widgets/custom_button.dart';
import 'package:project_2/widgets/custom_modern_snackbar.dart';
import 'package:project_2/widgets/custom_show_dialog.dart';
import 'package:project_2/widgets/custom_snack_bar.dart';
import 'package:provider/provider.dart';

class BookingRequestFormPage extends StatelessWidget {
  final ServiceProviderModel provider;

  final Map<String,dynamic>?existingBooking;
  final String? bookingId;

  const BookingRequestFormPage({super.key, required this.provider, this.existingBooking,this.bookingId});

  bool get _isEditMode => existingBooking != null && bookingId != null;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingRequestProvider()
        ..initializeServiceType(provider.selectService)
        ..prefillIfEditing(existingBooking),
      child: Consumer<BookingRequestProvider>(
        builder: (context, bookingProvider, child) {
          return Scaffold(
            backgroundColor: AppColors.secondary,
            appBar: _buildAppBar(),
            body: Form(
              key: bookingProvider.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProviderSummaryCard(provider: provider),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection(
                            'Service Details',
                            ServiceTypeField(bookingProvider: bookingProvider),
                          ),
                          const SizedBox(height: 16),
                          _buildSection(
                            'Schedule',
                            DateTimeSelectors(
                              provider: provider,
                              bookingProvider: bookingProvider,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildSection(
                            'Service Location',
                            AddressField(bookingProvider: bookingProvider),
                          ),
                          const SizedBox(height: 24),
                          _buildSection(
                            'Additional Information',
                            NotesField(bookingProvider: bookingProvider),
                          ),
                          // if (!_isEditMode)
                          const SizedBox(height: 24),
                          // if (!_isEditMode)
                           _buildSection(
                              'Attach Photos (Optional)',
                              ImagePickerSection(bookingProvider: bookingProvider),
                            ),
                          const SizedBox(height: 32),
                          PriceSummaryCard(provider: provider),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: _buildBottomBar(context, bookingProvider),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        _isEditMode?'Edit Booking': 'Booking Details',
        style: TextStyle(color: AppColors.secondary),
      ),
      iconTheme: const IconThemeData(color: AppColors.secondary),
      backgroundColor: AppColors.primary,
      elevation: 0,
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildBottomBar(
      BuildContext context, BookingRequestProvider bookingProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        boxShadow: [
          BoxShadow(
            color: AppColors.textColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: CustomButton(
          text: _isEditMode ? 'Save Changes' : 'Send Booking Request',
          borderRadius: 15,
          onTap: () => _isEditMode?
          _updateBooking(context,bookingProvider):
          _submitBookingRequest(context, bookingProvider),
          width: double.infinity,
          height: 54,
        ),
      ),
    );
  }

Future<void> _submitBookingRequest(
    BuildContext context, BookingRequestProvider bookingProvider) async {
  if (!bookingProvider.validateForm()) {
    return;
  }

  if (bookingProvider.selectedDate == null ||
      bookingProvider.selectedTime == null) {
    // CustomSnackBar.show(
    //   context: context,
    //   title: "Schedule Missing",
    //   message: "Please select when you need the service.",
    //   icon: Icons.event_busy,
    //   iconColor: AppColors.primary,
    //   backgroundColor: Colors.orange.shade900
    // );
    ModernSnackBar.show(
      context: context,
      title:"Schedule Missing",
      message: "Please select when you need the service.",
      type:SnackBarType.warning,
      );
    return;
  }
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    },
  );
  
  try {
    // Actually submit the booking to Firestore
    await bookingProvider.submitBooking(provider);
    
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomShowDialog(
            title: 'Booking Request Sent!',
            buttonLeft: null,
            buttonRight: 'Go to Bookings',
            subTitle: 'Your booking request has been sent successfully. The provider will respond soon.',
            animationPath: 'assets/animations/success_booking_request.json',
            onTap: () {
              // Switch to Booking tab
              context.read<NavigationProvider>().setIndex(1);
              context.read<NavigationProvider>().showBottomNav(); 
              // Pop everything until you reach the first screen
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          );
        },
      );
    }
  } catch (e) {
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  
    if (context.mounted) {
      ModernSnackBar.show(
        context: context,
        title: "Error",
        message: "Failed to send booking request. Please try again.",
        type: SnackBarType.error,
      );
    }
  }
}

Future<void> _updateBooking(
    BuildContext context, BookingRequestProvider bookingProvider) async {
  if (!bookingProvider.validateForm()) return;

  if (bookingProvider.selectedDate == null ||
      bookingProvider.selectedTime == null) {
    // CustomSnackBar.show(
    //   context: context,
    //   title: "Schedule Missing",
    //   message: "Please select a date and time.",
    //   icon: Icons.event_busy,
    //   iconColor: AppColors.primary,
    //   backgroundColor: Colors.orange.shade900,
    // );
    ModernSnackBar.show(
      context: context,
      title:"Schedule Missing",
      message: "Please select a date and time.",
      type:SnackBarType.warning,
      );
    return;
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    ),
  );

  try {
    await bookingProvider.updateBooking(
      bookingId: bookingId!,
      providerId: existingBooking!['providerId'],
      userId: existingBooking!['userId'],
    );

    if (context.mounted) Navigator.of(context).pop();

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CustomShowDialog(
          title: 'Booking Updated!',
          buttonLeft: null,
          buttonRight: 'Go to Bookings',
          subTitle: 'Your booking has been updated successfully.',
          animationPath: 'assets/animations/success_booking_request.json',
          onTap: () {
            context.read<NavigationProvider>().setIndex(1);
            context.read<NavigationProvider>().showBottomNav();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      );
    }
  } catch (e) {
    if (context.mounted) Navigator.of(context).pop();

    if (context.mounted) {
      ModernSnackBar.show(
        context: context,
        title: "Error",
        message: "Failed to update booking. Please try again.",
        type: SnackBarType.error,
      );
    }
  }
}
}
