// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:project_2/View/auth/login_screen/login_main.dart';
// import 'package:project_2/constants/app_color.dart';
// import 'package:project_2/controllers/user_provider/user_provider.dart';
// import 'package:project_2/view/add_account_screen/add_account_main.dart';
// import 'package:provider/provider.dart';

// import '../bottom_nav/bottom_nav_screen.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   // void navigateUser(BuildContext context) async {
//   //   // final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
//   //   // bool isLoggedIn = await authProvider.checkUserLogin();

//   //   Future.delayed(const Duration(seconds: 2), () {
//   //     Navigator.pushReplacement(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder:
//   //             (context) =>
//   //                 isLoggedIn ?  MainScreenWithNavigation() : const LoginMain(),
//   //       ),
//   //     );
//   //   });
//   // }

//   void navigateUser(BuildContext context) async {
//   await Future.delayed(const Duration(seconds: 2));
//   FlutterNativeSplash.remove(); 
//   final user = FirebaseAuth.instance.currentUser;

//   if (user == null) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const LoginMain()),
//     );
//     return;
//   }

//   final userProvider = Provider.of<UserProvider>(context, listen: false);
//   final userExists = await userProvider.checkUserRegistration();

//   if (userExists != null) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => MainScreenWithNavigation()),
//     );
//   } else {
//     userProvider.resetProfileState();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const AddAccountMain()),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     Future.microtask(() => navigateUser(context));
//     return Scaffold(
//   // backgroundColor: AppColors.primary,
//   body: Container(
//     decoration: BoxDecoration(
//       gradient: SweepGradient(
//         startAngle: 10,
//         endAngle: 50,
//         // begin: Alignment.topRight,
//         // end: Alignment.bottomLeft,
//       colors: [
//         AppColors.primary, // Blue
//         AppColors.secondary,
//         AppColors.primary,        
//       ])
//     ),
//     child: SafeArea(
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
    
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppColors.primary,
//               ),
//               child: Icon(
//                 Icons.home_repair_service,
//                 size: 40,
//                 color: AppColors.secondary,
//               ),
//             ),
            
//             SizedBox(height: 40),
//             Text(
//               'GoServe',
//               style: TextStyle(
//                 fontSize: 50,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.secondary,
//                 fontFamily: 'DancingScript'
//               ),
//             ),
            
//             SizedBox(height: 15),
    
//             Text(
//               'Connecting you with trusted professionals',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 20,
//                 color: AppColors.secondary,
//                 fontFamily: 'DancingScript'
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   ),
// );
//   }
// }













// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:project_2/View/auth/login_screen/login_main.dart';
// import 'package:project_2/constants/app_color.dart';
// import 'package:project_2/controllers/user_provider/user_provider.dart';
// import 'package:project_2/view/add_account_screen/add_account_main.dart';
// import 'package:provider/provider.dart';
// import '../bottom_nav/bottom_nav_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnim;
//   late Animation<double> _scaleAnim;
//   late Animation<double> _slideAnim;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );

//     _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),
//     );

//     _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)),
//     );

//     _slideAnim = Tween<double>(begin: 30.0, end: 0.0).animate(
//       CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
//     );

//     _controller.forward();

//     Future.microtask(() => navigateUser(context));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void navigateUser(BuildContext context) async {
//     await Future.delayed(const Duration(milliseconds: 2500));

//     FlutterNativeSplash.remove();

//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (_) => const LoginMain()));
//       return;
//     }

//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final userExists = await userProvider.checkUserRegistration();

//     if (userExists != null) {
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (_) => MainScreenWithNavigation()));
//     } else {
//       userProvider.resetProfileState();
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (_) => const AddAccountMain()));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primary, // dark navy #082F46
//       body: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, child) {
//           return Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               color: AppColors.primary,
//             ),
//             child: Stack(
//               children: [

//                 // subtle top-right glow
//                 Positioned(
//                   top: -80,
//                   right: -80,
//                   child: Opacity(
//                     opacity: 0.08 * _fadeAnim.value,
//                     child: Container(
//                       width: 300,
//                       height: 300,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),

//                 // subtle bottom-left glow
//                 Positioned(
//                   bottom: -100,
//                   left: -60,
//                   child: Opacity(
//                     opacity: 0.05 * _fadeAnim.value,
//                     child: Container(
//                       width: 280,
//                       height: 280,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Main content
//                 Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [

//                       // Logo with scale + fade animation
//                       Transform.scale(
//                         scale: _scaleAnim.value,
//                         child: Opacity(
//                           opacity: _fadeAnim.value,
//                           child: Image.asset(
//                             'assets/logo/goserve_official_logo.png',
//                             width: 130,
//                             height: 130,
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 24),

//                       // App name with slide + fade animation
//                       Opacity(
//                         opacity: _fadeAnim.value,
//                         child: Transform.translate(
//                           offset: Offset(0, _slideAnim.value),
//                           child: Text(
//                             'GoServe',
//                             style: TextStyle(
//                               fontSize: 42,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               fontFamily: 'DancingScript',
//                               letterSpacing: 1.5,
//                             ),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 10),

//                       // Tagline with slide + fade animation
//                       Opacity(
//                         opacity: _fadeAnim.value,
//                         child: Transform.translate(
//                           offset: Offset(0, _slideAnim.value),
//                           child: Text(
//                             'Connecting you with trusted professionals',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.white.withOpacity(0.6),
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Bottom loader indicator
//                 Positioned(
//                   bottom: 60,
//                   left: 0,
//                   right: 0,
//                   child: Opacity(
//                     opacity: _fadeAnim.value,
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2.5,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Colors.white.withOpacity(0.5),
//                             ),
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







import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:project_2/View/auth/login_screen/login_main.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';
import 'package:project_2/view/add_account_screen/add_account_main.dart';
import 'package:provider/provider.dart';
import '../bottom_nav/bottom_nav_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void navigateUser(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    FlutterNativeSplash.remove();

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const LoginMain()));
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userExists = await userProvider.checkUserRegistration();

    if (userExists != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => MainScreenWithNavigation()));
    } else {
      userProvider.resetProfileState();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const AddAccountMain()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Future.microtask(() => navigateUser(context));
    WidgetsBinding.instance.addPostFrameCallback((_) => navigateUser(context));

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [

          // subtle top-right glow
          // Positioned(
          //   top: -80,
          //   right: -80,
          //   child: Container(
          //     width: 300,
          //     height: 300,
          //     decoration: const BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Colors.white10,
          //     ),
          //   ),
          // ),

          // subtle bottom-left glow
          // Positioned(
          //   bottom: -100,
          //   left: -60,
          //   child: Container(
          //     width: 280,
          //     height: 280,
          //     decoration: const BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Colors.white10,
          //     ),
          //   ),
          // ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Logo
                Image.asset(
                  'assets/logo/goserve_official_logo.png',
                  width: 150,
                  height: 150,
                ),

                const SizedBox(height: 10),

                // App name
                const Text(
                  'GoServe',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    // fontFamily: 'DancingScript',
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 10),

                // Tagline
                // Text(
                //   'Connecting you with trusted professionals',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: Colors.white.withOpacity(0.6),
                //     letterSpacing: 0.5,
                //   ),
                // ),
              ],
            ),
          ),

          // Bottom loader
          // Positioned(
          //   bottom: 60,
          //   left: 0,
          //   right: 0,
          //   child: Center(
          //     child: SizedBox(
          //       width: 24,
          //       height: 24,
          //       child: CircularProgressIndicator(
          //         strokeWidth: 2.5,
          //         valueColor: AlwaysStoppedAnimation<Color>(
          //           Colors.white.withOpacity(0.5),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}