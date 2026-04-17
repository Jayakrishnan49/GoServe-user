import 'package:flutter/material.dart';
import 'package:project_2/controllers/auth_provider/auth_provider.dart';
import 'package:project_2/view/auth/login_screen/login_bottom.dart';
import 'package:project_2/view/auth/login_screen/login_registration.dart';
import 'package:project_2/view/auth/login_screen/login_top.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

class LoginMain extends StatelessWidget {
  const LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: LoadingOverlay(
        isLoading: authProvider.isLoading,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/auth_section/login_bg_img.png',
                  fit: BoxFit.cover,
                  alignment: AlignmentGeometry.bottomCenter,
                  ),
                
                )
              ),
            // Main content
            SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      children: const [
                        LoginTop(),
                        LoginRegistration(),
                        SizedBox(height: 20),
                        LoginBottom(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        
            // Loader overlay
            // if (authProvider.isLoading)
            //   Container(
            //     color: Colors.black54,
            //     child: Center(
            //       child: CircularProgressIndicator(
            //         color: AppColors.secondary,
            //       ),
            //     ),
            //   ),
          ]
        ),
      ),
    );
  }
}
