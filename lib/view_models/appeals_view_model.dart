import 'package:flutter/material.dart';
import '../models/appeal_model.dart';
import '../services/network_caller.dart';

class AppealsViewModel extends ChangeNotifier {
  List<Appeal> _appeals = [];
  bool _isLoading = false;
  String? _errorMessage;

  int _currentPage = 1;
  final int _itemsPerPage = 3;

  List<Appeal> get appeals => _appeals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;

  List<Appeal> get displayedAppeals {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _appeals.length) return [];
    return _appeals.sublist(
      startIndex,
      endIndex > _appeals.length ? _appeals.length : endIndex,
    );
  }

  int get totalPages =>
      _appeals.isEmpty ? 1 : (_appeals.length / _itemsPerPage).ceil();

  AppealsViewModel() {
    fetchAppeals();
  }

  Future<void> fetchAppeals() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('📞 Fetching appeals from API...');
      final response = await NetworkCaller.getRequest(
        'https://erronliveapp.mtscorporate.com/api/v1/apologies/',
      );

      print('📊 Response Status: ${response.statusCode}');
      print('📊 Response Success: ${response.isSuccess}');

      if (response.isSuccess) {
        final data = response.responseData;

        print('📊 Response Data Type: ${data.runtimeType}');
        print('📊 Response Data: $data');

        // Handle both single object and array responses
        if (data is Map<String, dynamic>) {
          // API returns a single object
          _appeals = [Appeal.fromJson(data)];
          print('✅ Fetched 1 appeal from API');
        } else if (data is List) {
          _appeals = data.map((json) => Appeal.fromJson(json)).toList();
          print('✅ Fetched ${_appeals.length} appeals from array');
        } else {
          _appeals = [];
          print('⚠️ Unexpected data format: ${data.runtimeType}');
        }
      } else {
        // If the endpoint doesn't exist or returns an error, just show empty state
        // This is not a critical error - the feature might not be implemented yet
        _appeals = [];
        if (response.statusCode == 404) {
          print('ℹ️ Appeals endpoint not found (404) - showing empty state');
        } else if (response.statusCode == 401) {
          _errorMessage = 'Unauthorized - Please login again';
          print('❌ Unauthorized access to appeals');
        } else {
          _errorMessage =
              response.errorMessage ??
              'Failed to fetch appeals (Status: ${response.statusCode})';
          print('❌ Error fetching appeals: $_errorMessage');
          print('❌ Response data: ${response.responseData}');
        }
      }
    } catch (e, stackTrace) {
      // Don't show error to user if it's just a network issue
      // Just show empty state
      _appeals = [];
      print('❌ Exception fetching appeals: $e');
      print('❌ Stack trace: $stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < totalPages) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      notifyListeners();
    }
  }

  Future<bool> reviewAppeal(String appealId, String action) async {
    try {
      print('📝 Reviewing appeal $appealId with action: $action');

      final response = await NetworkCaller.patchRequest(
        'https://erronliveapp.mtscorporate.com/api/v1/apologies/$appealId/review',
        body: {
          'action': action, // APOLOGY_ACCEPTED or APOLOGY_REJECTED
        },
      );

      print('📊 Review Response Status: ${response.statusCode}');
      print('📊 Review Response Success: ${response.isSuccess}');

      if (response.isSuccess) {
        print('✅ Appeal reviewed successfully');
        // Refresh the appeals list
        await fetchAppeals();
        return true;
      } else {
        print('❌ Failed to review appeal: ${response.statusCode}');
        print('❌ Response: ${response.responseData}');
        return false;
      }
    } catch (e) {
      print('❌ Exception reviewing appeal: $e');
      return false;
    }
  }
}
