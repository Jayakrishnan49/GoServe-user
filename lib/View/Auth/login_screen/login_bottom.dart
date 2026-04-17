import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_2/view/auth/signup_screen/signup_main.dart';
import 'package:project_2/view/bottom_nav/bottom_nav_screen.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:provider/provider.dart';
import '../../../controllers/auth_provider/auth_provider.dart';
import '../auth_nav/auth_nav.dart';

class LoginBottom extends StatelessWidget {
  const LoginBottom({super.key});

  @override
  Widget build(BuildContext context) {
    // final authProvider = context.watch<AuthProvider>();

    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: "Don't have an account?",
            style: TextStyle(
              color: AppColors.textColor,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: ' Sign Up',
                style: TextStyle(
                  color: const Color.fromARGB(255, 14, 93, 139),
                  decoration: TextDecoration.underline,
                  fontStyle: FontStyle.italic,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignupMain()),
                    );
                  },
              ),
            ],
          ),
        ),
        const SizedBox(height: 80),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Divider(color: AppColors.grey)),
            Text(
              '   Or continue with   ',
              style: TextStyle(color: AppColors.hintText),
            ),
            Expanded(child: Divider(color: AppColors.grey)),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          // color: AppColors.secondary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            
                   InkWell(
                      onTap: () async {
                        try {
                          final userCredential =
                              await context.read<UserAuthProvider>().signInWithGoogle();
                          log(userCredential.user.toString());

                          if (userCredential.user != null && context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const MainScreenWithNavigation()),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                      child: Image.asset(
                        'assets/icons/google_image.png',
                        width: 40,
                        height: 40,
                      ),
                    ),

              const SizedBox(width: 40),

              /// Phone login button (not implemented yet)
              InkWell(
                onTap: () {
                  //// navigate to phone login
                },
                child: Image.asset(
                  'assets/icons/call_image_blue.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}









