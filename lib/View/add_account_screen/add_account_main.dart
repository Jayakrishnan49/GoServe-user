// import 'package:flutter/material.dart';
// import 'package:project_2/constants/app_color.dart';
// import 'package:project_2/controllers/user_provider/user_provider.dart';
// import 'package:project_2/view/add_account_screen/add_account_form.dart';
// import 'package:project_2/view/add_account_screen/add_account_top.dart';
// import 'package:project_2/widgets/loading_overlay.dart';
// import 'package:provider/provider.dart';

// class AddAccountMain extends StatelessWidget {
//   const AddAccountMain({super.key});
//   // static bool _isResetDone = false;
//   @override
//   Widget build(BuildContext context) {
//     //   WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   context.read<UserProvider>().resetProfileState();
//     // });
// //     if (!_isResetDone) {
// //   WidgetsBinding.instance.addPostFrameCallback((_) {
// //     context.read<UserProvider>().resetProfileState();
// //   });
// //   _isResetDone = true;
// // }
    
//     // final userProvider = Provider.of<UserProvider>(context);
//     final userProvider = context.watch<UserProvider>();
//     return Scaffold(
//       backgroundColor: AppColors.secondary,
//       body: LoadingOverlay(
//         isLoading: userProvider.isSavingUser,
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(30),
//             child: SingleChildScrollView(
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     AddAccountTop(),
//                     SizedBox(height: 60,),
//                     AddAccountForm()
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }







// import 'package:flutter/material.dart';
// import 'package:project_2/constants/app_color.dart';
// import 'package:project_2/controllers/user_provider/user_provider.dart';
// import 'package:project_2/view/add_account_screen/add_account_form.dart';
// import 'package:project_2/view/add_account_screen/add_account_top.dart';
// import 'package:project_2/widgets/loading_overlay.dart';
// import 'package:provider/provider.dart';

// class AddAccountMain extends StatelessWidget {
//   const AddAccountMain({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = context.watch<UserProvider>();

//     return Scaffold(
//       backgroundColor: AppColors.secondary,
//       // 1. Keep LoadingOverlay as the root of body to cover everything
//       body: LoadingOverlay(
//         isLoading: userProvider.isSavingUser,
//         // 2. Use a Stack as the immediate child of the overlay
//         child: Stack(
//           children: [
//             // 3. BACKGROUND LAYER: The Image
//             Positioned.fill(
//               child: Opacity(
//                 opacity: 0.2,
//                 child: Image.asset(
//                   'assets/complete_profile/complete_your_profile.png',
//                   // Fit.cover ensures it fills the screen without stretching
//                   fit: BoxFit.cover, 
//                 ),
//               ),
//             ),

//             // 4. CONTENT LAYER: The Scrollable Form
//             SafeArea(
//               child: SingleChildScrollView(
//                 // Move padding inside the scroll view so content has breathing room
//                 padding: const EdgeInsets.all(30),
//                 child: Column(
//                   children: [
//                     const AddAccountTop(),
//                     const SizedBox(height: 60),
//                     AddAccountForm(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }










import 'package:flutter/material.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';
import 'package:project_2/view/add_account_screen/add_account_form.dart';
import 'package:project_2/view/add_account_screen/add_account_top.dart';
import 'package:project_2/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

class AddAccountMain extends StatelessWidget {
  const AddAccountMain({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: LoadingOverlay(
        isLoading: userProvider.isSavingUser,
        child: Stack(
          children: [
            // ── Decorative blob top-right ──  
            // Positioned(
            //   top: -80,
            //   right: -80,
            //   child: Container(
            //     width: 260,
            //     height: 260,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       gradient: RadialGradient(
            //         colors: [
            //           AppColors.primary.withOpacity(0.18),
            //           AppColors.primary.withOpacity(0.0),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            // ── Decorative blob bottom-left ──
            // Positioned(
            //   bottom: -60,
            //   left: -60,
            //   child: Container(
            //     width: 200,
            //     height: 200,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       gradient: RadialGradient(
            //         colors: [
            //           AppColors.primary.withOpacity(0.12),
            //           AppColors.primary.withOpacity(0.0),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            // ── Background image (subtle) ──
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/complete_profile/complete_your_profile.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // ── Main content ──
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                child: Column(
                  children: [
                    const AddAccountTop(),
                    const SizedBox(height: 36),
                    AddAccountForm(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}