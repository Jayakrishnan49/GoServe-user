// import 'package:flutter/material.dart';
// import 'package:project_2/controllers/user_provider/user_provider.dart';
// import 'package:project_2/Utilities/app_validators.dart';
// import 'package:project_2/Widgets/custom_button.dart';
// import 'package:project_2/Widgets/custom_text_form_field.dart';
// import 'package:provider/provider.dart';


// class EditProfileForm extends StatelessWidget {
//   const EditProfileForm({super.key});

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController nameController = TextEditingController();
//     TextEditingController phoneNumberController = TextEditingController();
//     TextEditingController emailController = TextEditingController();
//     AppValidators formValidators = AppValidators();
//     // Removed the incorrect declaration: final String gender;

//     final formKey = GlobalKey<FormState>();
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
//           Consumer<UserProvider>(
//             builder: (context, userProvider, _) {
//               return Column(
//                 children: [
//                   RadioListTile<String>(
//                     title: const Text("Male"),
//                     value: "Male",
//                     groupValue: userProvider.gender, // current selection
//                     onChanged: (value) => userProvider.setGender(value),
//                   ),
//                   RadioListTile<String>(
//                     title: const Text("Female"),
//                     value: "Female",
//                     groupValue: userProvider.gender, // current selection
//                     onChanged: (value) => userProvider.setGender(value),
//                   ),
//                   RadioListTile<String>(
//                     title: const Text("Other"),
//                     value: "Other",
//                     groupValue: userProvider.gender, // current selection
//                     onChanged: (value) => userProvider.setGender(value),
//                   ),
//                 ],
//               );
//             }
//           ),

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
//             keyboardType: TextInputType.number,
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
//           CustomButton(
//             width: 400,
//             onTap: () async {
//               // if (formKey.currentState!.validate()) {
//               //   final user = _auth.currentUser;
//               //   if (user == null) {
//               //     ScaffoldMessenger.of(context).showSnackBar(
//               //       const SnackBar(content: Text("User not logged in")),
//               //     );
//               //     return;
//               //   }

//               //   // Get the current gender from UserProvider
//               //   final userProvider = Provider.of<UserProvider>(context, listen: false);
                
//               //   // Validate that gender is selected
//               //   if (userProvider.gender == null || userProvider.gender!.isEmpty) {
//               //     ScaffoldMessenger.of(context).showSnackBar(
//               //       const SnackBar(content: Text("Please select a gender")),
//               //     );
//               //     return;
//               //   }

//               //   final userModel = UserModel(
//               //     userId: user.uid,
//               //     profilePhoto: userProvider.imagePath ?? "", // Use selected image or empty string
//               //     name: nameController.text,
//               //     gender: userProvider.gender!, // Fixed: use actual gender from provider
//               //     phoneNumber: phoneNumberController.text,
//               //     email: emailController.text,
//               //   );
                
//               //   log(userModel.userId);
                
//               //   try {
//               //     await userProvider.saveUser(userModel);
                  
//               //     if (context.mounted) {
//               //       ScaffoldMessenger.of(context).showSnackBar(
//               //         const SnackBar(content: Text('Account created')),
//               //       );
//               //       Navigator.of(context).push(
//               //         MaterialPageRoute(builder: (context) =>  MainScreenWithNavigation()),
//               //       );
//               //     }
//               //   } catch (e) {
//               //     if (context.mounted) {
//               //       ScaffoldMessenger.of(context).showSnackBar(
//               //         SnackBar(content: Text('Error: $e')),
//               //       );
//               //     }
//               //   }
//               // }
//             },
//             text: 'Save Changes',
//             borderRadius: 15,
//           ),
//         ],
//       ),
//     );
//   }
// }