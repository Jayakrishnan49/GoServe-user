import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubmissionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _submissions =>
      _firestore.collection('user_submissions');

  String get _userId => FirebaseAuth.instance.currentUser?.uid ?? '';

  // ── Submit a report ───────────────────────────────────────────────
  Future<void> submitReport({
    required String userName,
    required String userEmail,
    required String category,
    required String description,
  }) async {
    await _submissions.add({
      'type': 'report',
      'userId': _userId,
      'userName': userName,
      'userEmail': userEmail,
      'category': category,
      'description': description,
      'status': 'pending',
      'createdAt': Timestamp.now(),
    });
  }

  // ── Submit feedback ───────────────────────────────────────────────
  Future<void> submitFeedback({
    required String userName,
    required String userEmail,
    required String message,
  }) async {
    await _submissions.add({
      'type': 'feedback',
      'userId': _userId,
      'userName': userName,
      'userEmail': userEmail,
      'message': message,
      'status': 'pending',
      'createdAt': Timestamp.now(),
    });
  }

  // ── Get current user's submissions (real-time) ────────────────────
  Stream<QuerySnapshot> getUserSubmissions() {
    return _submissions
        .where('userId', isEqualTo: _userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}