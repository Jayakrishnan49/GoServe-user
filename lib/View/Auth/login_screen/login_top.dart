import 'package:flutter/material.dart';
import 'package:project_2/constants/app_color.dart';

class LoginTop extends StatelessWidget {
  const LoginTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 60,),
        Text('Login',
          style: TextStyle(
          color: const Color.fromARGB(255, 14, 93, 139),
          fontSize: 40,
          fontWeight: FontWeight.bold,
          fontFamily: 'DancingScript',
          ),
        ),
        SizedBox(height: 15),
        Text('You have been missed !!',
        textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.grey,
              fontFamily: 'DancingScript',
            ),
        ),
        SizedBox(height: 40,)
      ],
    );
  }
}