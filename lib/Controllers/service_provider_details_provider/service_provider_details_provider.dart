import 'package:flutter/foundation.dart';
import 'package:project_2/model/service_model.dart';
import 'package:project_2/services/service_provider_details_service.dart';

class ServiceProviderDetailsProvider extends ChangeNotifier {
  final ServiceProviderDetailsService _service = ServiceProviderDetailsService();

  List<ServiceProviderModel> _providers = [];
  List<ServiceProviderModel> get providers => _providers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _hasFetched = false;

  Future<void> fetchAllProviders() async {
    if(_hasFetched)return;
    _hasFetched=true;
    _isLoading = true;
    notifyListeners();

    try {
      _providers = await _service.getAllWorks();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching providers: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }
// Filter providers by category
  List<ServiceProviderModel> getProvidersByCategory(String category) {
    return _providers.where((provider) {
      return provider.selectService.toLowerCase() == category.toLowerCase();
    }).toList();
  }
}