import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_2/View/auth/login_screen/login_main.dart';
import 'package:project_2/constants/app_color.dart';

class SignupBottom extends StatelessWidget {
  const SignupBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          RichText(
            text: TextSpan(
              text: 'Already have an account?',
              style: TextStyle(
                color: AppColors.textColor,
                fontWeight: FontWeight.bold
              ),
              children:[
                TextSpan(
                  text: ' Log In',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 14, 93, 139),
                    decoration: TextDecoration.underline,
                    fontStyle: FontStyle.italic
                  ),
                  recognizer: TapGestureRecognizer()
                  ..onTap=(){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) => LoginMain(),));
                  }
                ),
              ]
            )
            )
      ],
    );
  }
}