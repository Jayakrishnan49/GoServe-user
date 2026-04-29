import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_2/model/service_model.dart';

class ServiceProviderDetailsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _serviceProviderCollection => _firestore.collection('service_provider');

  // Get all service_provider
  Future<List<ServiceProviderModel>> getAllWorks() async {
    final snapshot = await _serviceProviderCollection.where('status',isEqualTo: 'approved').get();
    return snapshot.docs
        .map((doc) => ServiceProviderModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Get specific service_provider
  Future<ServiceProviderModel?> getWork(String id) async {
    final doc = await _serviceProviderCollection.doc(id).get();
    if (doc.exists) {
      return ServiceProviderModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}
