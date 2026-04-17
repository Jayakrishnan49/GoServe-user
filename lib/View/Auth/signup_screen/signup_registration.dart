// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_2/view/auth/login_screen/login_main.dart';
import 'package:project_2/controllers/auth_provider/auth_provider.dart';
import 'package:project_2/Utilities/app_validators.dart';
import 'package:project_2/Widgets/custom_button.dart';
import 'package:project_2/Widgets/custom_text_form_field.dart';
import 'package:project_2/widgets/custom_modern_snackbar.dart';
import 'package:provider/provider.dart';

class SignupRegistration extends StatelessWidget {
  const SignupRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    final formKey=GlobalKey<FormState>();
    AppValidators formValidators=AppValidators();
    final userProvider = Provider.of<UserAuthProvider>(context, listen: false);

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
        
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'E-Mail ID',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              controller: emailController,
              prefixIcon: Icons.email,
              hintText: 'Enter Email',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: formValidators.validateEmail,
            ),
            SizedBox(height: 30,),
        
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Enter Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              controller: passwordController,
              hintText: 'Enter Password',
              prefixIcon: Icons.lock,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: formValidators.validatePassword,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
            ),
             SizedBox(height: 30,),
        
        
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Confirm Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              controller: confirmPasswordController,
              hintText: 'Enter Password',
              prefixIcon: Icons.lock,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // validator: formValidators.validateConfirmPassword,
              validator: (value) => formValidators.validateConfirmPassword(
                value,
                passwordController.text
              ),
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
            ),
            SizedBox(height: 60,),
             CustomButton(
              width: 400,
              onTap: ()async {
                  if (formKey.currentState!.validate()) {
                      try  {
                    await  userProvider.signUpAccount(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          
                        );
                        ModernSnackBar.show(
                          context: context,
                          title: 'Success',
                          message: 'Account created successfully.',
                          type: SnackBarType.success,
                        );
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Account created')),
                        // );
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) => LoginMain(),));
                        // Navigator.pop(context);
                      } 
                      catch (e) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('Error: ${e.toString()}')),
                        // );
                        ModernSnackBar.show(
                          context: context,
                          title: 'Signup Failed',
                          message: 'Unable to create account. Please try again.',
                          type: SnackBarType.error,
                        );
                      }
                  }
              },
            text: 'Sign Up',
            borderRadius: 15,
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}