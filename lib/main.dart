// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:project_2/controllers/auth_provider/auth_provider.dart';
// import 'package:project_2/controllers/browse_all_category_provider/browse_all_category_provider.dart';
// import 'package:project_2/controllers/custom_textform_field_provider/custom_text_form_field_provider.dart';
// import 'package:project_2/controllers/search_filter_provider/filter_provider.dart';
// import 'package:project_2/controllers/search_filter_provider/search_provider.dart';
// import 'package:project_2/controllers/service_provider_details_provider/service_provider_details_provider.dart';
// import 'package:project_2/controllers/service_provider_details_provider/service_provider_favorite_provider.dart';
// import 'package:project_2/controllers/user_provider/user_provider.dart';
// import 'package:project_2/View/splash_screen/splash_screen.dart';
// import 'package:provider/provider.dart';

// import 'controllers/bottom_nav_provider/bottom_nav_provider.dart' show NavigationProvider;

// void main() async{
//      WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//   // options: DefaultFirebaseOptions.currentPlatform,
// );
//   runApp(const MyApp());
 
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_)=>CustomTextFormFieldProvider()),
//         ChangeNotifierProvider(create: (_)=>UserAuthProvider()),
//         ChangeNotifierProvider(create: (_)=>UserProvider()),
//         ChangeNotifierProvider(create: (_) => NavigationProvider()),
//         ChangeNotifierProvider(create: (_) => BrowseAllCategoryProvider(),),
//         ChangeNotifierProvider(create: (_) => SearchProvider()),
//         ChangeNotifierProvider(create: (_) => FilterProvider()),
//         ChangeNotifierProvider(create: (_)=>FavoriteProvider()..loadFavorites()),
//         ChangeNotifierProvider(create: (_) => ServiceProviderDetailsProvider()..fetchAllProviders(),       
//         // ChangeNotifierProvider(create: (_) => FavoriteProvider()),

// )
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Flutter Demo',
//         home: SplashScreen()
//         // home: LocationAccessScreen(),
//         // home: CreateUserPage(),
//       ),
//     );
//   }
// }



import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:project_2/controllers/auth_provider/auth_provider.dart';
import 'package:project_2/controllers/booking_provider/booking_request_provider.dart';
import 'package:project_2/controllers/browse_all_category_provider/browse_all_category_provider.dart';
import 'package:project_2/controllers/custom_textform_field_provider/custom_text_form_field_provider.dart';
import 'package:project_2/controllers/policy_provider/policy_provider.dart';
import 'package:project_2/controllers/rating_provider/rating_provider.dart';
import 'package:project_2/controllers/search_filter_provider/filter_provider.dart';
import 'package:project_2/controllers/search_filter_provider/search_provider.dart';
import 'package:project_2/controllers/service_provider_details_provider/service_provider_details_provider.dart';
import 'package:project_2/controllers/service_provider_details_provider/service_provider_favorite_provider.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';
import 'package:project_2/View/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

import 'controllers/bottom_nav_provider/bottom_nav_provider.dart' show NavigationProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  await MediaStore.ensureInitialized();
  MediaStore.appFolder = 'GoServe';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RatingProvider()),
        ChangeNotifierProvider(create: (_) => CustomTextFormFieldProvider()),
        ChangeNotifierProvider(create: (_) => UserAuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => BrowseAllCategoryProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()..loadFavorites()),
        ChangeNotifierProvider(create: (_) => ServiceProviderDetailsProvider()),
        ChangeNotifierProvider(create: (_) => BookingRequestProvider()),
        ChangeNotifierProvider(create: (_) => PolicyProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: SplashScreen(),
      ),
    );
  }
}
