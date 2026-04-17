import 'package:flutter/material.dart';
import 'package:project_2/View/auth/signup_screen/signup_bottom.dart';
import 'package:project_2/View/auth/signup_screen/signup_registration.dart';
import 'package:project_2/View/auth/signup_screen/signup_top.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/auth_provider/auth_provider.dart';
import 'package:project_2/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

class SignupMain extends StatelessWidget {
  const SignupMain({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider=Provider.of<UserAuthProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: LoadingOverlay(
        isLoading: authProvider.isLoading,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.6,
                child: Image.asset('assets/auth_section/login_bg_img.png',
                fit: BoxFit.cover,
                alignment: AlignmentGeometry.bottomCenter,
        
              ),
              )
            ),
           SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                     SignupTop(),
                     SizedBox(height: 50,),
                     SignupRegistration(),
                    //  SizedBox(height: 60,),
                     SignupBottom (),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // if(authProvider.isLoading)
          //   Container(
          //     color: Colors.black54,
          //     child: Center(
          //       child: CircularProgressIndicator(
          //         color: AppColors.secondary,
          //       ),
          //     ),
          //   )
          ]
        ),
      ),
    );
  }
}