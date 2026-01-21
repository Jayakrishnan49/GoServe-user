import 'package:project_2/view/rating_page/rating_page.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentService {
  late Razorpay _razorpay;
  final BuildContext context;
  final String bookingId;
  final String userId;
  final String providerId;
  final double amount;

  PaymentService({
    required this.context,
    required this.bookingId,
    required this.userId,
    required this.providerId,
    required this.amount,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
  }

  void openCheckout() {
    final int amountInPaise = (amount * 100).round();

    var options = {
      'key': 'rzp_test_RwbpGuEwSTJwRE',
      'amount': amountInPaise,
      'name': 'GoServe',
      'description': 'Service Payment',
      'prefill': {
        'contact': '9876543210',
        'email': 'test@gmail.com',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay error: $e');
    }
  }

  Future<void> _handleSuccess(PaymentSuccessResponse response) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('my_bookings')
          .doc(bookingId)
          .update({
        'paymentStatus': 'paid',
        'paymentId': response.paymentId,
        'paidAt': FieldValue.serverTimestamp(),
      });
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Payment Successful");
      // Navigator.pop(context); // optional (close bottom sheet/dialog)
      // Navigator.push(context, MaterialPageRoute(builder: (context) => RatingPage(providerId: providerId, bookingId: bookingId),));
      showDialog(
        context: context,
        builder: (_) =>  RatingDialog(
          providerId: providerId,
          bookingId: bookingId,
        ),
      );


    } catch (e) {
      debugPrint('Firestore error: $e');
      Fluttertoast.showToast(msg: "Payment done, but update failed");
    } finally {
      dispose();
    }
  }

  void _handleError(PaymentFailureResponse response) {
    // Fluttertoast.showToast(msg: "Payment Failed");
    Fluttertoast.showToast(
  msg: "Payment Failed",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
);

    dispose();
  }

  void dispose() {
    _razorpay.clear();
  }
}
