// import 'package:flutter/material.dart';

// class ForgotPassword extends StatelessWidget {
//   const ForgotPassword({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }



import 'package:flutter/material.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/auth_provider/auth_provider.dart';
import 'package:project_2/Utilities/app_validators.dart';
import 'package:project_2/Widgets/custom_button.dart';
import 'package:project_2/Widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);
    TextEditingController emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final AppValidators myAppValidators = AppValidators();
    return Scaffold(
      backgroundColor: AppColors.secondary,
      // appBar: AppBar(
      //   title: const Text('Forgot Password'),
      //   elevation: 0,
      //   backgroundColor: AppColors.primary,
      //   foregroundColor: AppColors.secondary,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: Form(
        key: formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 28,
              end: 28,
              top: 100,
              bottom: 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // const SizedBox(height: 100),
              
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Icon(
                        Icons.lock_reset,
                        size: 80,
                        shadows: [
                          Shadow(color: AppColors.grey,blurRadius: 30)
                        ],
                        color: AppColors.successAlert,
                      ),
                    )
                  ),
                  const SizedBox(height: 30),
              
                  const Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,fontFamily: 'DancingScript',),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
              
                  Text(
                    'Enter the email associated with your account and we\'ll send an email with instructions to reset your password.',
                    style: TextStyle(fontSize: 16, color:AppColors.grey,fontFamily: 'DancingScript',),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
              
                  CustomTextFormField(
                    controller: emailController,
                    prefixIcon: Icons.email,
                    labelText: 'Email',
                    hintText: 'Enter Email',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: myAppValidators.validateEmail,
                  ),
                  const SizedBox(height: 60),
                  // Submit button
                  CustomButton(
                    width: 400,
                    borderRadius: 15,
                    // onTap: () async {
                    //   if (formKey.currentState!.validate()) {
                    //     await authProvider.resetPassword(emailController.text);
                    //     Navigator.pop(context);
                    //   }
                    // },

                    onTap: () async {
  if (formKey.currentState!.validate()) {
    try {
      await authProvider.resetPassword(emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset link sent to your email.")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
},

                    // backgroundcolor: AppColors.primary,
                    // textcolor: AppColors.buttonColor,
                    text: 'Submit',
                  ),
                  const SizedBox(height: 25),
                  // Return to login
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:  Text(
                      'Back to Login',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}