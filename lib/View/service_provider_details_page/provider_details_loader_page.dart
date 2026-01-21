import 'package:flutter/material.dart';
import 'package:project_2/Constants/app_color.dart';
import 'package:project_2/model/service_model.dart';
import 'package:project_2/View/service_provider_details_page/service_provider_details_page.dart';
import 'package:project_2/services/service_provider_details_service.dart';

class ProviderDetailsLoaderPage extends StatelessWidget {
  final String providerId;

  const ProviderDetailsLoaderPage({
    super.key,
    required this.providerId,
  });

  @override
  Widget build(BuildContext context) {
    final service = ServiceProviderDetailsService();

    return FutureBuilder<ServiceProviderModel?>(
      future: service.getWork(providerId),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.secondary,
            body: Center(child: CircularProgressIndicator(color: AppColors.buttonColor,)),
          );
        }

        // Error / not found
        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('Service provider not found')),
          );
        }

        // Success
        return ServiceProviderDetailsPage(
          provider: snapshot.data!,
        );
      },
    );
  }
}
