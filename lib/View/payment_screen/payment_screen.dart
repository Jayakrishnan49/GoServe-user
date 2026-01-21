// import 'package:flutter/material.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class PaymentScreen extends StatefulWidget {
//   final String bookingId;
//   final String userId;
//   final double amount;

//   const PaymentScreen({
//     super.key,
//     required this.bookingId,
//     required this.userId,
//     required this.amount,
//   });

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   late Razorpay _razorpay;

//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
//   }

//   void openCheckout() {
//     final int amountInPaise=(widget.amount*100).round();
//     var options = {
//       'key': 'rzp_test_RwbpGuEwSTJwRE', // your test key
//       'amount': amountInPaise, // amount in paise
//       'name': 'GoServe',
//       'description': 'Service Payment',
//       'prefill': {
//         'contact': '9876543210',
//         'email': 'test@gmail.com',
//       }
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error: $e');
//     }
//   }


// void _handleSuccess(PaymentSuccessResponse response) async {
//   if (!mounted) return;

//   try {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.userId)              // 👈 USER DOCUMENT
//         .collection('my_bookings')        // 👈 SUBCOLLECTION
//         .doc(widget.bookingId)           // 👈 BOOKING DOC
//         .update({
//       'paymentStatus': 'paid',
//       'paymentId': response.paymentId,
//       'paidAt': FieldValue.serverTimestamp(),
//     });

//     Fluttertoast.showToast(msg: "Payment Successful");

//     if (mounted) Navigator.pop(context);
//   } catch (e) {
//     debugPrint('Firestore error: $e');
//     Fluttertoast.showToast(msg: "Payment done, but update failed");
//   }
// }


// void _handleError(PaymentFailureResponse response) {
//   if (!mounted) return;
//   Fluttertoast.showToast(msg: "Payment Failed");
// }


//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Payment')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//     debugPrint("Pay button pressed");
//     openCheckout();
//   },
//           child: Text('Pay ₹${widget.amount}'),
//         ),
//       ),
//     );
//   }
// }
