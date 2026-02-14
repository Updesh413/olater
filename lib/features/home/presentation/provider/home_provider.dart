import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:olater/features/home/domain/models/location_model.dart';

enum ServiceType { ride, delivery }

class HomeProvider extends ChangeNotifier {
  ServiceType _selectedService = ServiceType.ride;
  List<LocationModel> _searchResults = [];
  final List<LocationModel> _recentLocations = [];
  bool _isSearching = false;
  Timer? _debounce;

  ServiceType get selectedService => _selectedService;
  List<LocationModel> get searchResults => _searchResults;
  List<LocationModel> get recentLocations => _recentLocations;
  bool get isSearching => _isSearching;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void selectService(ServiceType type) {
    _selectedService = type;
    notifyListeners();
  }

  Future<void> searchLocation(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty || query.length < 3) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 800), () async {
      _isSearching = true;
      notifyListeners();

      try {
        final response = await http.get(
          Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5'),
          headers: {
            'User-Agent': 'OlaterApp/1.0 (com.example.olater)',
            'Accept-Language': 'en',
          },
        );

        if (response.statusCode == 200) {
          final List data = json.decode(response.body);
          _searchResults = data.map((item) => LocationModel.fromJson(item)).toList();
        } else {
          debugPrint('Search failed with status: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Search error: $e');
      } finally {
        _isSearching = false;
        notifyListeners();
      }
    });
  }

  void addToRecent(LocationModel location) {
    // Check if already exists
    if (!_recentLocations.any((loc) => loc.address == location.address)) {
      _recentLocations.insert(0, location);
      if (_recentLocations.length > 5) {
        _recentLocations.removeLast();
      }
      notifyListeners();
    }
  }
}
