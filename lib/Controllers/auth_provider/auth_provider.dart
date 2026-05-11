import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_2/view/add_account_screen/add_account_main.dart';
import 'package:project_2/view/bottom_nav/bottom_nav_screen.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuthProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    bool _isLoading=false;
    bool get isLoading=>_isLoading;

    void _setLoading(bool value) {
      _isLoading = value;
      notifyListeners();
  }





  Future<void> loginAccount(String email, String password, BuildContext context) async {
  try {
    _setLoading(true);
    context.read<UserProvider>().resetProfileState();
    await auth.signInWithEmailAndPassword(email: email, password: password);
    // await saveUserLoggedIn();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userExists = await userProvider.checkUserRegistration();

    if (userExists != null) {
      await userProvider.fetchUser(userExists);
      // ✅ Firestore document found → Go to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreenWithNavigation()),
      );
    } else {
      userProvider.resetProfileState();
      //  No document found → Go to Add Account (Profile Creation)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AddAccountMain()),
      );
    }
  } on FirebaseAuthException catch (e) {
    throw Exception(e.message);
  } finally {
    _setLoading(false);
  }
}




  Future<void> signUpAccount(String email, String password) async {
  try {
    _setLoading(true);
    await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await auth.signOut();
  } on FirebaseAuthException catch (e) {
    throw Exception(e.message);
  } finally {
    _setLoading(false);
  }
} 

  Future<void> logout(BuildContext context) async {
    try {
      await auth.signOut();
// await googleUser
 await _googleSignIn.signOut();
 context.read<UserProvider>().resetProfileState();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Future<bool> checkUserLogin() async {
  //   final sharedPref = await SharedPreferences.getInstance();
  //   return sharedPref.getBool('isLoggedIn') ?? false;
  // }

  // Future<void> saveUserLoggedIn() async {
  //   final sharedPref = await SharedPreferences.getInstance();
  //   sharedPref.setBool('isLoggedIn', true);
  //   notifyListeners();
  // }
//////////////
  //   Future<void> verifyPhone({
  //   required String phoneNumber,
  //   required Function(PhoneAuthCredential) onVerificationCompleted,
  //   required Function(FirebaseAuthException) onVerificationFailed,
  //   required Function(String verificationId, int? resendToken) onCodeSent,
  //   required Function(String) onCodeAutoRetrievalTimeout,
  // }) async {
  //   await auth.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     verificationCompleted: onVerificationCompleted,
  //     verificationFailed: onVerificationFailed,
  //     codeSent: onCodeSent,
  //     codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
  //   );
  // }

  // Future<User?> verifyOtp(String verificationId, String smsCode) async {
  //   final credential = PhoneAuthProvider.credential(
  //     verificationId: verificationId,
  //     smsCode: smsCode,
  //   );
  //   final userCredential = await auth.signInWithCredential(credential);
  //   return userCredential.user;
  // }



Future<void> verifyPhone({
  required String phoneNumber,
  required Function(PhoneAuthCredential) onVerificationCompleted,
  required Function(FirebaseAuthException) onVerificationFailed,
  required Function(String verificationId, int? resendToken) onCodeSent,
  required Function(String) onCodeAutoRetrievalTimeout,
}) async {
  try {
    _setLoading(true);  // ← add this
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: (e) {
        _setLoading(false); // ← stop on failure
        onVerificationFailed(e);
      },
      codeSent: (id, token) {
        _setLoading(false); // ← stop when code sent
        onCodeSent(id, token);
      },
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
    );
  } catch (e) {
    _setLoading(false);
    rethrow;
  }
}

Future<User?> verifyOtp(String verificationId, String smsCode) async {
  try {
    _setLoading(true);   // ← add this
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final userCredential = await auth.signInWithCredential(credential);
    return userCredential.user;
  } finally {
    _setLoading(false);  // ← add this
  }
}

  Future<void> resetPassword(String email) async {
  try {
    await auth.sendPasswordResetEmail(email: email);
  } on FirebaseAuthException catch (e) {
    throw Exception(e.message);
  } catch (_) {
    throw Exception("Something went wrong");
  }
}




  Future<void> signInWithGoogle(BuildContext context) async {
  try {
    _setLoading(true);
    context.read<UserProvider>().resetProfileState();

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google Sign-In aborted');

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await auth.signInWithCredential(credential);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userExists = await userProvider.checkUserRegistration();

    if (!context.mounted) return;

    if (userExists != null) {
      await userProvider.fetchUser(userExists);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreenWithNavigation()),
      );
    } else {
      userProvider.resetProfileState();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AddAccountMain()),
      );
    }
  } on FirebaseAuthException catch (e) {
    throw Exception(e.message);
  } finally {
    _setLoading(false);
  }
}



  // Future<void> signOutGoogle() async {
  //   try {
  //     await _googleSignIn.signOut();
  //     await _auth.signOut();
  //   } catch (e) {
  //     print("Sign-out Error: $e");
  //   }
  // }

}
