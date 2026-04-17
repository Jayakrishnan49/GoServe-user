// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:project_2/Constants/app_color.dart';
// import 'package:project_2/controllers/user_provider/user_provider.dart';
// import 'package:project_2/Utilities/app_validators.dart';
// import 'package:project_2/View/location_access_screen/location_access_screen.dart';
// import 'package:project_2/Widgets/custom_button.dart';
// import 'package:project_2/Widgets/custom_text_form_field.dart';
// import 'package:project_2/model/user_model.dart';
// import 'package:project_2/view/auth/login_screen/login_main.dart';
// import 'package:project_2/widgets/custom_modern_snackbar.dart';
// import 'package:provider/provider.dart';


// class AddAccountForm extends StatelessWidget {
//    AddAccountForm({super.key});

//     static final TextEditingController nameController = TextEditingController();
//     static final TextEditingController phoneNumberController = TextEditingController();
//     static final TextEditingController emailController = TextEditingController();
//     final AppValidators formValidators = AppValidators();
//     // Removed the incorrect declaration: final String gender;
//     final FirebaseAuth _auth = FirebaseAuth.instance;

//     final formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final gender = context.watch<UserProvider>().gender;

//     return Form(
//       key: formKey,
//       child: Column(
//         children: [
//           const Align(
//             alignment: Alignment.topLeft,
//             child: Text(
//               'Name',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//           ),
//           const SizedBox(height: 10),
//           CustomTextFormField(
//             controller: nameController,
//             prefixIcon: Icons.person,
//             hintText: 'Enter Name',
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Username is required';
//               } else if (value.length < 3) {
//                 return 'Username must be at least 3 characters';
//               } else if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
//                 return 'Only letters, numbers, and underscores allowed';
//               }
//               return null; // valid
//             },
//           ),
//           const SizedBox(height: 30),

//           // Gender
//           const Align(
//             alignment: Alignment.topLeft,
//             child: Text(
//               "Gender",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//           ),
//           // Column(
//           //   children: [
//           //     RadioListTile<String>(
//           //       title: const Text("Male"),
//           //       value: "Male",
//           //       groupValue: userProvider.gender, // current selection
//           //       onChanged: (value) => userProvider.setGender(value),
//           //     ),
//           //     RadioListTile<String>(
//           //       title: const Text("Female"),
//           //       value: "Female",
//           //       groupValue: userProvider.gender, // current selection
//           //       onChanged: (value) => userProvider.setGender(value),
//           //     ),
//           //     RadioListTile<String>(
//           //       title: const Text("Other"),
//           //       value: "Other",
//           //       groupValue: userProvider.gender, // current selection
//           //       onChanged: (value) => userProvider.setGender(value),
//           //     ),
//           //   ],
//           // ),

// Column(
//   children: [
//     RadioListTile<String>(
//       title: const Text("Male"),
//       value: "Male",
//       groupValue: gender,
//       onChanged: (value) =>
//           context.read<UserProvider>().setGender(value),
//     ),
//     RadioListTile<String>(
//       title: const Text("Female"),
//       value: "Female",
//       groupValue: gender,
//       onChanged: (value) =>
//           context.read<UserProvider>().setGender(value),
//     ),
//     RadioListTile<String>(
//       title: const Text("Other"),
//       value: "Other",
//       groupValue: gender,
//       onChanged: (value) =>
//           context.read<UserProvider>().setGender(value),
//     ),
//   ],
// ),

//           const SizedBox(height: 30),

//           const Align(
//             alignment: Alignment.topLeft,
//             child: Text(
//               'Phone Number',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//           ),
//           const SizedBox(height: 10),
//           CustomTextFormField(
//             controller: phoneNumberController,
//             keyboardType: TextInputType.phone,
//             prefixIcon: Icons.phone,
//             hintText: 'Enter Ph number',
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             validator: formValidators.validatePhone,
//           ),
//           const SizedBox(height: 30),
//           const Align(
//             alignment: Alignment.topLeft,
//             child: Text(
//               'E-mail ID',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//           ),
//           const SizedBox(height: 10),
//           CustomTextFormField(
//             controller: emailController,
//             prefixIcon: Icons.email,
//             hintText: 'Enter Email',
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             validator: formValidators.validateEmail,
//           ),

//           const SizedBox(height: 60),
// CustomButton(
//   width: 400,
//   onTap: () async {
//     if (formKey.currentState!.validate()) {
//       final user = _auth.currentUser;
//       if (user == null) {
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   const SnackBar(content: Text("User not logged in")),
//         // );
//         ModernSnackBar.show(
//   context: context,
//   title: "Session expired",
//   message: "Please sign in again.",
//   type: SnackBarType.error,
// );
//         return;
//       }

//       final userProvider = Provider.of<UserProvider>(context, listen: false);

//       if (userProvider.gender == null || userProvider.gender!.isEmpty) {
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   const SnackBar(content: Text("Please select a gender")),
//         // );
//         ModernSnackBar.show(
//   context: context,
//   title: "Missing information",
//   message: "Please select your gender.",
//   type: SnackBarType.warning,
// );
//         return;
//       }

//       final userModel = UserModel(
//         userId: user.uid,
//         profilePhoto: userProvider.imagePath ?? "", // provider will handle upload/default
//         name: nameController.text,
//         gender: userProvider.gender!,
//         phoneNumber: phoneNumberController.text,
//         email: emailController.text,
//       );

//       try {
//         await userProvider.saveUser(userModel);
//         if (context.mounted) {
//           // ScaffoldMessenger.of(context).showSnackBar(
//           //   const SnackBar(content: Text('Account created')),
//           // );
//           ModernSnackBar.show(
//   context: context,
//   title: "Success",
//   message: "Profile created successfully.",
//   type: SnackBarType.success,
// );
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => LocationAccessScreen()),
//           );
//         }
//       } catch (e) {
//         if (context.mounted) {
//           // ScaffoldMessenger.of(context).showSnackBar(
//           //   SnackBar(content: Text('Error: $e')),
//           // );
//           ModernSnackBar.show(
//   context: context,
//   title: "Error",
//   message: "Something went wrong. Please try again.",
//   type: SnackBarType.error,
// );
//         }
//       }
//     }
//   },
//   text: 'Save',
//   borderRadius: 15,
// ),
// TextButton(
//   onPressed: () async {
//     await FirebaseAuth.instance.signOut();

//     if (context.mounted) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginMain()),
//         (route) => false,
//       );
//     }
//   },
//   child: const Text(
//     "Back to sign in",
//     style: TextStyle(
//       fontSize: 16,
//       fontWeight: FontWeight.w500,
//       color: AppColors.primary
//     ),
//   ),
// )


//         ],
//       ),
//     );
//   }
// }






import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_2/Constants/app_color.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';
import 'package:project_2/Utilities/app_validators.dart';
import 'package:project_2/View/location_access_screen/location_access_screen.dart';
import 'package:project_2/Widgets/custom_button.dart';
import 'package:project_2/Widgets/custom_text_form_field.dart';
import 'package:project_2/model/user_model.dart';
import 'package:project_2/view/add_account_screen/widgets/field_label.dart';
import 'package:project_2/view/add_account_screen/widgets/gender_selector.dart';
import 'package:project_2/view/add_account_screen/widgets/section_card.dart';
import 'package:project_2/view/auth/login_screen/login_main.dart';
import 'package:project_2/widgets/custom_modern_snackbar.dart';
import 'package:provider/provider.dart';

class AddAccountForm extends StatelessWidget {
  AddAccountForm({super.key});

  static final TextEditingController nameController = TextEditingController();
  static final TextEditingController phoneNumberController = TextEditingController();
  static final TextEditingController emailController = TextEditingController();
  final AppValidators formValidators = AppValidators();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final gender = context.watch<UserProvider>().gender;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ══════════════════════════════════════
          //  CARD — Personal Info
          // ══════════════════════════════════════
          SectionCard(
            label: 'Personal Info',
            icon: Icons.person_outline_rounded,
            children: [
              FieldLabel('Full Name'),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: nameController,
                prefixIcon: Icons.badge_outlined,
                hintText: 'Enter your name',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Username is required';
                  if (value.length < 3) return 'At least 3 characters required';
                  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value))
                    return 'Only letters, numbers, and underscores';
                  return null;
                },
              ),
              const SizedBox(height: 22),
              FieldLabel('Gender'),
              const SizedBox(height: 4),
              GenderSelector(gender: gender),
            ],
          ),

          const SizedBox(height: 20),

          // ══════════════════════════════════════
          //  CARD — Contact Info
          // ══════════════════════════════════════
          SectionCard(
            label: 'Contact Info',
            icon: Icons.contact_mail_outlined,
            children: [
              FieldLabel('Phone Number'),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
                hintText: 'Enter phone number',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: formValidators.validatePhone,
              ),
              const SizedBox(height: 22),
              FieldLabel('Email Address'),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: emailController,
                prefixIcon: Icons.alternate_email_rounded,
                hintText: 'Enter email address',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: formValidators.validateEmail,
              ),
            ],
          ),

          const SizedBox(height: 36),

          // ══════════════════════════════════════
          //  Save Button
          // ══════════════════════════════════════
          CustomButton(
            width: double.infinity,
            onTap: () async {
              if (formKey.currentState!.validate()) {
                final user = _auth.currentUser;
                if (user == null) {
                  ModernSnackBar.show(
                    context: context,
                    title: "Session expired",
                    message: "Please sign in again.",
                    type: SnackBarType.error,
                  );
                  return;
                }

                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);

                if (userProvider.gender == null || userProvider.gender!.isEmpty) {
                  ModernSnackBar.show(
                    context: context,
                    title: "Missing information",
                    message: "Please select your gender.",
                    type: SnackBarType.warning,
                  );
                  return;
                }

                final userModel = UserModel(
                  userId: user.uid,
                  profilePhoto: userProvider.imagePath ?? "",
                  name: nameController.text,
                  gender: userProvider.gender!,
                  phoneNumber: phoneNumberController.text,
                  email: emailController.text,
                );

                try {
                  await userProvider.saveUser(userModel);
                  if (context.mounted) {
                    ModernSnackBar.show(
                      context: context,
                      title: "Success",
                      message: "Profile created successfully.",
                      type: SnackBarType.success,
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => LocationAccessScreen()),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ModernSnackBar.show(
                      context: context,
                      title: "Error",
                      message: "Something went wrong. Please try again.",
                      type: SnackBarType.error,
                    );
                  }
                }
              }
            },
            text: 'Save & Continue',
            borderRadius: 16,
          ),

          const SizedBox(height: 14),

          // ══════════════════════════════════════
          //  Back to sign in
          // ══════════════════════════════════════
          Center(
            child: TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginMain()),
                    (route) => false,
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.arrow_back_ios_new_rounded, size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Back to Sign In',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      color: AppColors.primary
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
//  Reusable widgets (private to this file)
// ─────────────────────────────────────────────────




