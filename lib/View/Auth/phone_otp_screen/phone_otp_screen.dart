
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/auth_provider/auth_provider.dart';
import 'package:project_2/view/auth/phone_otp_screen/otp_varification_screen.dart';
import 'package:project_2/widgets/custom_button.dart';
import 'package:project_2/widgets/custom_modern_snackbar.dart';
import 'package:project_2/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

class PhoneOtpScreen extends StatelessWidget {
  const PhoneOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Consumer<UserAuthProvider>(
        builder: (context, authProvider, _) {
          return LoadingOverlay(
            isLoading: authProvider.isLoading,
            child: Stack(
              children: [
                // Background
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.6,
                    child: Image.asset(
                      'assets/auth_section/login_bg_img.png',
                      fit: BoxFit.cover,
                      alignment: AlignmentGeometry.bottomCenter,
                    ),
                  ),
                ),

                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Header
                          Text(
                            'Phone Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 14, 93, 139),
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DancingScript',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'We\'ll send you a verification code',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.grey,
                              fontFamily: 'DancingScript',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 48),

                          // Phone input
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Phone Number',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                    hintText: 'Enter 10-digit number',
                                    hintStyle: TextStyle(
                                        color: AppColors.hintText,
                                        fontSize: 14),
                                    prefixIcon: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 14),
                                      margin:
                                          const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary
                                            .withOpacity(0.08),
                                        borderRadius:
                                            const BorderRadius.only(
                                          topLeft: Radius.circular(14),
                                          bottomLeft: Radius.circular(14),
                                        ),
                                      ),
                                      child: Text(
                                        '+91',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    prefixIconConstraints:
                                        const BoxConstraints(minWidth: 0),
                                    filled: true,
                                    fillColor:
                                        Colors.white.withOpacity(0.85),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                          color: AppColors.primary,
                                          width: 1.5),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                          color: Colors.red),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 16),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Phone number is required';
                                    }
                                    if (value.length != 10) {
                                      return 'Enter a valid 10-digit number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 36),

                                // Send OTP button
                                CustomButton(
                                  width: double.infinity,
                                  text: 'Send OTP',
                                  onTap: () async {
                                    if (formKey.currentState!.validate()) {
                                      final phone =
                                          '+91${phoneController.text.trim()}';
                                      await authProvider.verifyPhone(
                                        phoneNumber: phone,
                                        onVerificationCompleted:
                                            (credential) async {
                                          await authProvider.auth
                                              .signInWithCredential(
                                                  credential);
                                        },
                                        onVerificationFailed: (e) {
                                          if (context.mounted) {
                                            ModernSnackBar.show(
                                              context: context,
                                              title: 'Verification Failed',
                                              message: e.message ??
                                                  'Something went wrong',
                                              type: SnackBarType.error,
                                            );
                                          }
                                        },
                                        onCodeSent:
                                            (verificationId, resendToken) {
                                          if (context.mounted) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    OtpVerificationScreen(
                                                  phoneNumber: phone,
                                                  verificationId:
                                                      verificationId,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        onCodeAutoRetrievalTimeout:
                                            (verificationId) {},
                                      );
                                    }
                                  },
                                  borderRadius: 15,
                                ),

                                const SizedBox(height: 16),

                                // Back text button
                                Center(
                                  child: TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context),
                                    child: Text(
                                      'Go Back',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}