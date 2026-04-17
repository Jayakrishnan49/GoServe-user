import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2/constants/app_color.dart';

class SignupTop extends StatelessWidget {
  const SignupTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,),
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primary,
          // child: Icon(Icons.person,color: AppColors.secondary,size: 50,),
          child: Icon(FontAwesomeIcons.user,color: AppColors.secondary,size: 40,),
        ),
        SizedBox(height: 20,),
        Text(
          'Hello User !',
          style: TextStyle(
            color: const Color.fromARGB(255, 14, 93, 139),
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'DancingScript',
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          width: 230,
          child: Text(
            'Sign Up For Better Experience',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.hintText,
              fontFamily: 'DancingScript',
            ),
          ),
        ),
      ],
    );
  }
}