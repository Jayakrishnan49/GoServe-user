// // screens/policy_screen.dart
// import 'package:flutter/material.dart';
// import 'package:project_2/controllers/policy_provider/policy_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PolicyScreen extends StatelessWidget {
//   final String title;
//   final String url;

//   const PolicyScreen({super.key, required this.title, required this.url});

//   @override
//   Widget build(BuildContext context) {
//     // Init controller when screen builds
//     Future.microtask(() =>
//         context.read<PolicyProvider>().initController(url));

//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: Consumer<PolicyProvider>(
//         builder: (context, provider, _) {
//           return Stack(
//             children: [
//               WebViewWidget(controller: provider.controller),
//               if (provider.isLoading)
//                 const Center(child: CircularProgressIndicator()),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }






// // screens/policy_screen.dart
// import 'package:flutter/material.dart';
// import 'package:project_2/controllers/policy_provider/policy_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PolicyScreen extends StatelessWidget {
//   final String title;
//   final String url;

//   const PolicyScreen({super.key, required this.title, required this.url});

//   @override
//   Widget build(BuildContext context) {
//     Future.microtask(() =>
//         context.read<PolicyProvider>().initController(url));

//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: Consumer<PolicyProvider>(
//         builder: (context, provider, _) {
//           // ✅ show loader until controller is ready
//           if (provider.controller == null) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return Stack(
//             children: [
//               WebViewWidget(controller: provider.controller!),
//               if (provider.isLoading)
//                 const Center(child: CircularProgressIndicator()),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:project_2/Constants/app_color.dart';
import 'package:project_2/controllers/policy_provider/policy_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PolicyScreen extends StatelessWidget {
  final String title;
  final String url;

  const PolicyScreen({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() =>
        context.read<PolicyProvider>().initController(url));

    return PopScope(
      // ✅ reset provider when user presses back
      onPopInvoked: (_) => context.read<PolicyProvider>().reset(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.secondary),
          backgroundColor: AppColors.primary,
          title: 
          Text(
            title,
            style: TextStyle(
                color: AppColors.secondary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
            ),
          )
        ),
        body: Consumer<PolicyProvider>(
          builder: (context, provider, _) {
            if (provider.controller == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                WebViewWidget(controller: provider.controller!),
                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }
}