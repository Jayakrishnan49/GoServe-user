// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:project_2/constants/app_color.dart';
// import 'package:project_2/controllers/auth_provider/auth_provider.dart';
// import 'package:project_2/controllers/user_provider/user_provider.dart';
// import 'package:project_2/view/add_account_screen/add_account_main.dart';
// import 'package:project_2/view/bottom_nav/bottom_nav_screen.dart';
// import 'package:project_2/widgets/custom_modern_snackbar.dart';
// import 'package:project_2/widgets/loading_overlay.dart';
// import 'package:provider/provider.dart';

// class OtpVerificationScreen extends StatelessWidget {
//   final String phoneNumber;
//   final String verificationId;

//   const OtpVerificationScreen({
//     super.key,
//     required this.phoneNumber,
//     required this.verificationId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // 6 controllers for 6 OTP boxes
//     final controllers =
//         List.generate(6, (_) => TextEditingController());
//     final focusNodes = List.generate(6, (_) => FocusNode());
//     final resendSeconds = ValueNotifier<int>(30);
//     final isResending = ValueNotifier<bool>(false);
//     final currentVerificationId = ValueNotifier<String>(verificationId);

//     // Start countdown
//     Timer? timer;
//     void startTimer() {
//       resendSeconds.value = 30;
//       timer?.cancel();
//       timer = Timer.periodic(const Duration(seconds: 1), (t) {
//         if (resendSeconds.value > 0) {
//           resendSeconds.value--;
//         } else {
//           t.cancel();
//         }
//       });
//     }

//     startTimer();

//     return Scaffold(
//       backgroundColor: AppColors.secondary,
//       body: Consumer<UserAuthProvider>(
//         builder: (context, authProvider, _) {
//           return LoadingOverlay(
//             isLoading: authProvider.isLoading,
//             child: Stack(
//               children: [
//                 // Background
//                 Positioned.fill(
//                   child: Opacity(
//                     opacity: 0.6,
//                     child: Image.asset(
//                       'assets/auth_section/login_bg_img.png',
//                       fit: BoxFit.cover,
//                       alignment: AlignmentGeometry.bottomCenter,
//                     ),
//                   ),
//                 ),

//                 SafeArea(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Back button
//                         IconButton(
//                           onPressed: () => Navigator.pop(context),
//                           icon: const Icon(
//                               Icons.arrow_back_ios_new_rounded),
//                           color: AppColors.textColor,
//                           padding: EdgeInsets.zero,
//                         ),
//                         const SizedBox(height: 32),

//                         // Header
//                         Text(
//                           'Verify OTP',
//                           style: TextStyle(
//                             color: const Color.fromARGB(255, 14, 93, 139),
//                             fontSize: 38,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'DancingScript',
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Code sent to $phoneNumber',
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: AppColors.grey,
//                             fontFamily: 'DancingScript',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 48),

//                         // OTP boxes
//                         Row(
//                           mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                           children: List.generate(6, (index) {
//                             return SizedBox(
//                               width: 48,
//                               height: 56,
//                               child: TextFormField(
//                                 controller: controllers[index],
//                                 focusNode: focusNodes[index],
//                                 keyboardType: TextInputType.number,
//                                 textAlign: TextAlign.center,
//                                 maxLength: 1,
//                                 inputFormatters: [
//                                   FilteringTextInputFormatter.digitsOnly,
//                                 ],
//                                 style: TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.primary,
//                                 ),
//                                 decoration: InputDecoration(
//                                   counterText: '',
//                                   filled: true,
//                                   fillColor:
//                                       Colors.white.withOpacity(0.85),
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(12),
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                         color: Colors.grey.shade300),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                         color: AppColors.primary,
//                                         width: 2),
//                                   ),
//                                 ),
//                                 onChanged: (value) {
//                                   if (value.isNotEmpty &&
//                                       index < 5) {
//                                     focusNodes[index + 1]
//                                         .requestFocus();
//                                   }
//                                   if (value.isEmpty && index > 0) {
//                                     focusNodes[index - 1]
//                                         .requestFocus();
//                                   }
//                                 },
//                               ),
//                             );
//                           }),
//                         ),
//                         const SizedBox(height: 36),

//                         // Verify button
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               final otp = controllers
//                                   .map((c) => c.text)
//                                   .join();
//                               if (otp.length < 6) {
//                                 ModernSnackBar.show(
//                                   context: context,
//                                   title: 'Invalid OTP',
//                                   message:
//                                       'Please enter the complete 6-digit code',
//                                   type: SnackBarType.warning,
//                                 );
//                                 return;
//                               }

//                               try {
//                                 final user =
//                                     await authProvider.verifyOtp(
//                                   currentVerificationId.value,
//                                   otp,
//                                 );

//                                 if (user == null || !context.mounted) {
//                                   return;
//                                 }

//                                 final userProvider =
//                                     context.read<UserProvider>();
//                                 userProvider.resetProfileState();
//                                 final userExists = await userProvider
//                                     .checkUserRegistration();

//                                 if (!context.mounted) return;

//                                 if (userExists != null) {
//                                   await userProvider
//                                       .fetchUser(userExists);
//                                   ModernSnackBar.show(
//                                     context: context,
//                                     title: 'Welcome back!',
//                                     message: 'Signed in successfully.',
//                                     type: SnackBarType.success,
//                                   );
//                                   await Future.delayed(
//                                       const Duration(milliseconds: 800));
//                                   Navigator.pushAndRemoveUntil(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (_) =>
//                                             MainScreenWithNavigation()),
//                                     (route) => false,
//                                   );
//                                 } else {
//                                   userProvider.resetProfileState();
//                                   ModernSnackBar.show(
//                                     context: context,
//                                     title: 'Almost there!',
//                                     message:
//                                         'Please complete your profile to continue.',
//                                     type: SnackBarType.info,
//                                   );
//                                   await Future.delayed(
//                                       const Duration(milliseconds: 800));
//                                   Navigator.pushAndRemoveUntil(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (_) =>
//                                             const AddAccountMain()),
//                                     (route) => false,
//                                   );
//                                 }
//                               } catch (e) {
//                                 if (context.mounted) {
//                                   ModernSnackBar.show(
//                                     context: context,
//                                     title: 'Verification Failed',
//                                     message:
//                                         'Invalid OTP. Please try again.',
//                                     type: SnackBarType.error,
//                                   );
//                                 }
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.primary,
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 16),
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(14)),
//                             ),
//                             child: const Text(
//                               'Verify OTP',
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 24),

//                         // Resend OTP
//                         Center(
//                           child: ValueListenableBuilder<int>(
//                             valueListenable: resendSeconds,
//                             builder: (context, seconds, _) {
//                               if (seconds > 0) {
//                                 return Text(
//                                   'Resend OTP in ${seconds}s',
//                                   style: TextStyle(
//                                       color: AppColors.grey,
//                                       fontSize: 14),
//                                 );
//                               }
//                               return ValueListenableBuilder<bool>(
//                                 valueListenable: isResending,
//                                 builder: (context, resending, _) {
//                                   return TextButton(
//                                     onPressed: resending
//                                         ? null
//                                         : () async {
//                                             isResending.value = true;
//                                             await authProvider
//                                                 .verifyPhone(
//                                               phoneNumber: phoneNumber,
//                                               onVerificationCompleted:
//                                                   (_) {},
//                                               onVerificationFailed:
//                                                   (e) {
//                                                 if (context.mounted) {
//                                                   ModernSnackBar.show(
//                                                     context: context,
//                                                     title:
//                                                         'Failed to resend',
//                                                     message: e.message ??
//                                                         'Try again',
//                                                     type: SnackBarType
//                                                         .error,
//                                                   );
//                                                 }
//                                               },
//                                               onCodeSent: (newId, _) {
//                                                 currentVerificationId
//                                                     .value = newId;
//                                                 isResending.value =
//                                                     false;
//                                                 startTimer();
//                                                 if (context.mounted) {
//                                                   ModernSnackBar.show(
//                                                     context: context,
//                                                     title: 'OTP Sent',
//                                                     message:
//                                                         'A new code has been sent.',
//                                                     type: SnackBarType
//                                                         .success,
//                                                   );
//                                                 }
//                                               },
//                                               onCodeAutoRetrievalTimeout:
//                                                   (_) {},
//                                             );
//                                           },
//                                     child: Text(
//                                       'Resend OTP',
//                                       style: TextStyle(
//                                         color: AppColors.primary,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }












import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/auth_provider/auth_provider.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';
import 'package:project_2/view/add_account_screen/add_account_main.dart';
import 'package:project_2/view/bottom_nav/bottom_nav_screen.dart';
import 'package:project_2/widgets/custom_button.dart';
import 'package:project_2/widgets/custom_modern_snackbar.dart';
import 'package:project_2/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  Widget build(BuildContext context) {
    final controllers = List.generate(6, (_) => TextEditingController());
    final focusNodes = List.generate(6, (_) => FocusNode());
    final resendSeconds = ValueNotifier<int>(30);
    final isResending = ValueNotifier<bool>(false);
    final currentVerificationId = ValueNotifier<String>(verificationId);

    Timer? timer;
    void startTimer() {
      resendSeconds.value = 30;
      timer?.cancel();
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (resendSeconds.value > 0) {
          resendSeconds.value--;
        } else {
          t.cancel();
        }
      });
    }

    startTimer();

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
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 24, vertical: 32),
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Header
                          Text(
                            'Verify OTP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 14, 93, 139),
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DancingScript',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Code sent to $phoneNumber',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.grey,
                              fontFamily: 'DancingScript',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 48),

                          // OTP boxes
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (index) {
                              return SizedBox(
                                width: 48,
                                height: 56,
                                child: TextFormField(
                                  controller: controllers[index],
                                  focusNode: focusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    filled: true,
                                    fillColor:
                                        Colors.white.withOpacity(0.85),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: AppColors.primary,
                                          width: 2),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && index < 5) {
                                      focusNodes[index + 1].requestFocus();
                                    }
                                    if (value.isEmpty && index > 0) {
                                      focusNodes[index - 1].requestFocus();
                                    }
                                  },
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 36),

                          // Verify button
                          CustomButton(
                            borderRadius: 15,
                            width: double.infinity,
                            text: 'Verify OTP',
                            onTap: () async {
                              final otp = controllers
                                  .map((c) => c.text)
                                  .join();
                              if (otp.length < 6) {
                                ModernSnackBar.show(
                                  context: context,
                                  title: 'Invalid OTP',
                                  message:
                                      'Please enter the complete 6-digit code',
                                  type: SnackBarType.warning,
                                );
                                return;
                              }

                              try {
                                final user = await authProvider.verifyOtp(
                                  currentVerificationId.value,
                                  otp,
                                );

                                if (user == null || !context.mounted) {
                                  return;
                                }

                                final userProvider =
                                    context.read<UserProvider>();
                                userProvider.resetProfileState();
                                final userExists = await userProvider
                                    .checkUserRegistration();

                                if (!context.mounted) return;

                                if (userExists != null) {
                                  await userProvider.fetchUser(userExists);
                                  ModernSnackBar.show(
                                    context: context,
                                    title: 'Welcome back!',
                                    message: 'Signed in successfully.',
                                    type: SnackBarType.success,
                                  );
                                  await Future.delayed(
                                      const Duration(milliseconds: 800));
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            MainScreenWithNavigation()),
                                    (route) => false,
                                  );
                                } else {
                                  userProvider.resetProfileState();
                                  ModernSnackBar.show(
                                    context: context,
                                    title: 'Almost there!',
                                    message:
                                        'Please complete your profile to continue.',
                                    type: SnackBarType.info,
                                  );
                                  await Future.delayed(
                                      const Duration(milliseconds: 800));
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const AddAccountMain()),
                                    (route) => false,
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ModernSnackBar.show(
                                    context: context,
                                    title: 'Verification Failed',
                                    message:
                                        'Invalid OTP. Please try again.',
                                    type: SnackBarType.error,
                                  );
                                }
                              }
                            },
                          ),

                          const SizedBox(height: 16),

                          // Resend OTP
                          ValueListenableBuilder<int>(
                            valueListenable: resendSeconds,
                            builder: (context, seconds, _) {
                              if (seconds > 0) {
                                return Text(
                                  'Resend OTP in ${seconds}s',
                                  style: TextStyle(
                                      color: AppColors.grey, fontSize: 14,fontStyle: FontStyle.italic),
                                );
                              }
                              return ValueListenableBuilder<bool>(
                                valueListenable: isResending,
                                builder: (context, resending, _) {
                                  return TextButton(
                                    onPressed: resending
                                        ? null
                                        : () async {
                                            isResending.value = true;
                                            await authProvider.verifyPhone(
                                              phoneNumber: phoneNumber,
                                              onVerificationCompleted:
                                                  (_) {},
                                              onVerificationFailed: (e) {
                                                if (context.mounted) {
                                                  ModernSnackBar.show(
                                                    context: context,
                                                    title:
                                                        'Failed to resend',
                                                    message: e.message ??
                                                        'Try again',
                                                    type:
                                                        SnackBarType.error,
                                                  );
                                                }
                                              },
                                              onCodeSent: (newId, _) {
                                                currentVerificationId
                                                    .value = newId;
                                                isResending.value = false;
                                                startTimer();
                                                if (context.mounted) {
                                                  ModernSnackBar.show(
                                                    context: context,
                                                    title: 'OTP Sent',
                                                    message:
                                                        'A new code has been sent.',
                                                    type: SnackBarType
                                                        .success,
                                                  );
                                                }
                                              },
                                              onCodeAutoRetrievalTimeout:
                                                  (_) {},
                                            );
                                          },
                                    child: Text(
                                      'Resend OTP',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 8),

                          // Back text button
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Go Back',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
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