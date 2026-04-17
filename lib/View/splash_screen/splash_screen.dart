import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_2/View/auth/login_screen/login_main.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/auth_provider/auth_provider.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';
import 'package:project_2/view/add_account_screen/add_account_main.dart';
import 'package:provider/provider.dart';

import '../bottom_nav/bottom_nav_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // void navigateUser(BuildContext context) async {
  //   // final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
  //   // bool isLoggedIn = await authProvider.checkUserLogin();

  //   Future.delayed(const Duration(seconds: 2), () {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder:
  //             (context) =>
  //                 isLoggedIn ?  MainScreenWithNavigation() : const LoginMain(),
  //       ),
  //     );
  //   });
  // }

  void navigateUser(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 2));

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginMain()),
    );
    return;
  }

  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final userExists = await userProvider.checkUserRegistration();

  if (userExists != null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainScreenWithNavigation()),
    );
  } else {
    userProvider.resetProfileState();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AddAccountMain()),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => navigateUser(context));
    return Scaffold(
  // backgroundColor: AppColors.primary,
  body: Container(
    decoration: BoxDecoration(
      gradient: SweepGradient(
        startAngle: 10,
        endAngle: 50,
        // begin: Alignment.topRight,
        // end: Alignment.bottomLeft,
      colors: [
        AppColors.primary, // Blue
        AppColors.secondary,
        AppColors.primary,        
      ])
    ),
    child: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
    
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: Icon(
                Icons.home_repair_service,
                size: 40,
                color: AppColors.secondary,
              ),
            ),
            
            SizedBox(height: 40),
            Text(
              'GoServe',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
                fontFamily: 'DancingScript'
              ),
            ),
            
            SizedBox(height: 15),
    
            Text(
              'Connecting you with trusted professionals',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: AppColors.secondary,
                fontFamily: 'DancingScript'
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
  }
}