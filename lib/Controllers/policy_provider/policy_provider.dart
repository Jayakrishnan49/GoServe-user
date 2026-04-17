// // providers/policy_provider.dart
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PolicyProvider extends ChangeNotifier {
//   WebViewController? controller;
//   bool isLoading = true;

//   void initController(String url) {
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(NavigationDelegate(
//         onPageStarted: (_) {
//           isLoading = true;
//           notifyListeners();
//         },
//         onPageFinished: (_) {
//           isLoading = false;
//           notifyListeners();
//         },
//       ))
//       ..loadRequest(Uri.parse(url));
//       notifyListeners(); 
//   }
// }




// // providers/policy_provider.dart
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PolicyProvider extends ChangeNotifier {
//   WebViewController? controller;
//   bool isLoading = true;

//   void initController(String url) {
//     // ✅ reset before creating new controller
//     controller = null;
//     isLoading = true;
//     notifyListeners();

//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(NavigationDelegate(
//         onPageStarted: (_) {
//           isLoading = true;
//           notifyListeners();
//         },
//         onPageFinished: (_) {
//           isLoading = false;
//           notifyListeners();
//         },
//       ))
//       ..loadRequest(Uri.parse(url));
    
//     notifyListeners();
//   }

//   // ✅ add this
//   void reset() {
//     controller = null;
//     isLoading = true;
//   }
// }







// providers/policy_provider.dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PolicyProvider extends ChangeNotifier {
  WebViewController? controller;
  bool isLoading = true;

  void initController(String url) {
    // ✅ create controller first, then notify
    isLoading = true;

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) {
          isLoading = true;
          notifyListeners();
        },
        onPageFinished: (_) {
          isLoading = false;
          notifyListeners();
        },
      ))
      ..loadRequest(Uri.parse(url));

    notifyListeners(); // ✅ notify only after controller is assigned
  }

  void reset() {
    controller = null;
    isLoading = true;
    // ✅ no notifyListeners() here — screen is already popped
  }
}