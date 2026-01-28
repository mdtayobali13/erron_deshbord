import 'package:flutter/material.dart';
import '../models/moderator_model.dart';
import '../services/network_caller.dart';
import '../utils/app_urls.dart';

class ModeratorViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Moderator> _moderators = [];
  List<Moderator> get moderators => _moderators;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  int _currentPage = 1;
  int get currentPage => _currentPage;
  final int _itemsPerPage = 6;

  ModeratorViewModel() {
    loadModerators();
  }

  Future<void> loadModerators() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await NetworkCaller.getRequest(
      "${AppUrls.moderatorsList}?skip=0&limit=100",
    );

    if (response.isSuccess && response.responseData != null) {
      final List<dynamic> data = response.responseData;
      _moderators = data.map((json) => Moderator.fromJson(json)).toList();
    } else {
      _moderators = [];
      _errorMessage = response.errorMessage ?? "Failed to load moderators";
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateSearch(String query) {
    _searchQuery = query;
    _currentPage = 1;
    notifyListeners();
  }

  List<Moderator> get filteredModerators {
    if (_searchQuery.isEmpty) return _moderators;
    final query = _searchQuery.toLowerCase();
    return _moderators.where((m) {
      final matchesName = (m.fullName ?? "").toLowerCase().contains(query);
      final matchesUsername = (m.username ?? "").toLowerCase().contains(query);
      return matchesName || matchesUsername;
    }).toList();
  }

  List<Moderator> get displayedModerators {
    final filteredList = filteredModerators;
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    if (startIndex >= filteredList.length) return [];

    return filteredList.sublist(
      startIndex,
      endIndex > filteredList.length ? filteredList.length : endIndex,
    );
  }

  int get totalPages => (filteredModerators.length / _itemsPerPage).ceil() == 0
      ? 1
      : (filteredModerators.length / _itemsPerPage).ceil();

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

  Future<bool> createModerator(Map<String, dynamic> moderatorData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await NetworkCaller.postRequest(
        AppUrls.createModerator,
        body: moderatorData,
      );

      if (response.isSuccess) {
        await loadModerators(); // Refresh list
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.errorMessage ?? "Failed to create moderator";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateModerator(
    String id,
    Map<String, dynamic> moderatorData,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await NetworkCaller.patchRequest(
        "${AppUrls.updateModerator}/$id",
        body: moderatorData,
      );

      if (response.isSuccess) {
        await loadModerators(); // Refresh list
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.errorMessage ?? "Failed to update moderator";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteModerator(String id) async {
    // Implement delete logic when API is available
    // For now, local removal
    _moderators.removeWhere((m) => m.id == id);
    if (displayedModerators.isEmpty && _currentPage > 1) {
      _currentPage--;
    }
    notifyListeners();
    return true;
  }
}
