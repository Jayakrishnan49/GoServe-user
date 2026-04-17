// import 'package:flutter/material.dart';
// import 'package:project_2/constants/app_color.dart';
// import 'package:project_2/View/edit_profile_screen/edit_profile_form.dart';
// import 'package:project_2/View/edit_profile_screen/edit_profile_top.dart';

// class EditProfileMain extends StatelessWidget {
//   const EditProfileMain({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         title: Text('Edit Profile',style: TextStyle(color: AppColors.secondary),),
//       ),
//       backgroundColor: AppColors.secondary,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: SingleChildScrollView(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   EditProfileTop(),
//                   SizedBox(height: 60,),
//                   EditProfileForm(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }









import 'package:flutter/material.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';
import 'package:project_2/utilities/app_validators.dart';
import 'package:project_2/widgets/custom_button.dart';
import 'package:project_2/widgets/custom_text_form_field.dart';
import 'package:project_2/view/add_account_screen/widgets/field_label.dart';
import 'package:project_2/view/add_account_screen/widgets/gender_selector.dart';
import 'package:project_2/view/add_account_screen/widgets/profile_picture_picker.dart';
import 'package:project_2/view/add_account_screen/widgets/section_card.dart';
import 'package:project_2/widgets/custom_modern_snackbar.dart';
import 'package:project_2/widgets/loading_overlay.dart';
import 'package:project_2/widgets/location_confirm_dialog.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final AppValidators _validators = AppValidators();

  void _init(UserProvider userProvider) {
    final user = userProvider.currentUser;
    if (_nameController.text.isEmpty) {
      _nameController.text = user?.name ?? '';
    }
    if (_phoneController.text.isEmpty) {
      _phoneController.text = user?.phoneNumber ?? '';
    }
    if (_emailController.text.isEmpty) {
      _emailController.text = user?.email ?? '';
    }
  }

  Future<void> _save(BuildContext context, UserProvider userProvider) async {
    if (!_formKey.currentState!.validate()) return;

    if (userProvider.gender == null || userProvider.gender!.isEmpty) {
      ModernSnackBar.show(
        context: context,
        title: 'Missing information',
        message: 'Please select your gender.',
        type: SnackBarType.warning,
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final user = userProvider.currentUser;
    if (user == null) return;

    try {
      await userProvider.updateUser({
        'name': _nameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'gender': userProvider.gender ?? user.gender,
        'profilePhoto': userProvider.imagePath ?? user.profilePhoto,
      });

      if (context.mounted) {
        ModernSnackBar.show(
          context: context,
          title: 'Success',
          message: 'Profile updated successfully.',
          type: SnackBarType.success,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ModernSnackBar.show(
          context: context,
          title: 'Error',
          message: 'Something went wrong. Please try again.',
          type: SnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    _init(userProvider);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        // centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.secondary),
        // leading: IconButton(
        //   onPressed: () => Navigator.pop(context),
        //   icon: const Icon(
        //     Icons.arrow_back_ios_rounded,
        //     color: Colors.white,
        //     size: 20,
        //   ),
        // ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      body: LoadingOverlay(
        isLoading: userProvider.isSavingUser,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Avatar ──────────────────────────────────────────
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.6),
                              AppColors.primary.withOpacity(0.1),
                              AppColors.primary.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 145,
                        height: 145,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF7F3EF),
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: ProfilePicturePicker(
                          image: userProvider.imagePath ??
                              userProvider.currentUser?.profilePhoto,
                          onImagePicked: (path) =>
                              userProvider.setImage(path),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Name below avatar
                Center(
                  child: Text(
                    userProvider.currentUser?.name ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Personal Info Card ───────────────────────────────
                SectionCard(
                  label: 'Personal Info',
                  icon: Icons.person_outline_rounded,
                  children: [
                    FieldLabel('Full Name'),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _nameController,
                      prefixIcon: Icons.badge_outlined,
                      hintText: 'Enter your name',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        if (value.length < 3) {
                          return 'At least 3 characters required';
                        }
                        if (!RegExp(r'^[a-zA-Z0-9_ ]+$').hasMatch(value)) {
                          return 'Only letters, numbers, and underscores';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 22),
                    FieldLabel('Gender'),
                    const SizedBox(height: 4),
                    GenderSelector(gender: userProvider.gender),
                    const SizedBox(height: 22),

                    // Inside your Column/ListView in the edit profile screen
                  _buildLocationSection(context),
                    const SizedBox(height: 16),

                  ],
                ),

                const SizedBox(height: 20),

                // ── Contact Info Card ────────────────────────────────
                SectionCard(
                  label: 'Contact Info',
                  icon: Icons.contact_mail_outlined,
                  children: [
                    FieldLabel('Phone Number'),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                      hintText: 'Enter phone number',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validators.validatePhone,
                    ),
                    const SizedBox(height: 22),
                    FieldLabel('Email Address'),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _emailController,
                      prefixIcon: Icons.alternate_email_rounded,
                      hintText: 'Enter email address',
                      readOnly: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validators.validateEmail,
                    ),
                  ],
                ),

                const SizedBox(height: 36),

                // ── Save Button ──────────────────────────────────────
                CustomButton(
                  width: double.infinity,
                  onTap: () => _save(context, userProvider),
                  text: 'Save Changes',
                  borderRadius: 16,
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // Location Section Widget — add this inside your edit profile form

Widget _buildLocationSection(BuildContext context) {
  final userProvider = context.watch<UserProvider>();
  final user = userProvider.currentUser;

  final bool hasLocation =
      user?.latitude != null && user?.longitude != null;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Location',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1C1C2E)),
      ),
      const SizedBox(height: 8),

      GestureDetector(
        // onTap: () {
        //   // 👇 Replace with your actual map picker route
        //   Navigator.pushNamed(context, '/map-picker');
        // },
        onTap: () {
  final userProvider = context.read<UserProvider>();
  final position = userProvider.currentPosition;

  if (position != null) {
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => LocationConfirmDialog(
        lat: position.latitude,
        long: position.longitude,
        navigateToHomeOnConfirm: false,
      ),
    );
  } else {
    // No GPS position yet — request it first, then open dialog
    userProvider.requestLocationPermission().then((granted) {
      if (granted && context.mounted) {
        final pos = userProvider.currentPosition!;
        showDialog(
          context: context,
          useRootNavigator: false, 
          builder: (_) => LocationConfirmDialog(
            lat: pos.latitude,
            long: pos.longitude,
            navigateToHomeOnConfirm: false,
          ),
        );
      }
    });
  }
},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: hasLocation ? Colors.grey.shade300 : Colors.orange.shade300,
            ),
            borderRadius: BorderRadius.circular(12),
            color: hasLocation ? Colors.white : Colors.orange.shade50,
          ),
          child: Row(
            children: [
              Icon(
                hasLocation ? Icons.location_on : Icons.location_off,
                color: hasLocation ? Colors.redAccent : Colors.orange,
              ),
              const SizedBox(width: 12),

              Expanded(
                child: hasLocation
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProvider.locationName ?? 'Location saved',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'add/change location',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'No location added',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Tap to add your location on the map',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade400,
                            ),
                          ),
                        ],
                      ),
              ),

              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
}
