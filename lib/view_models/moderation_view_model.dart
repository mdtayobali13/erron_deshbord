import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../services/network_caller.dart';
import '../utils/app_urls.dart';

class ModerationViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ReportModel> _reports = [];
  List<ReportModel> get reports => _reports;

  String _selectedFilter = "All"; // Matches UI tabs
  String get selectedFilter => _selectedFilter;

  int _currentPage = 1;
  final int _itemsPerPage = 10;
  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;

  ModerationViewModel() {
    loadReports();
  }

  void setSelectedFilter(String filter) {
    _selectedFilter = filter;
    _currentPage = 1;
    loadReports();
  }

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  Future<void> loadReports() async {
    _isLoading = true;
    notifyListeners();

    // Map UI filters to API status
    String status = "";
    if (_selectedFilter == "New") status = "PENDING";
    if (_selectedFilter == "Resolved") status = "RESOLVED";

    final response = await NetworkCaller.getRequest(
      "${AppUrls.reports}${status.isNotEmpty ? '?status=$status' : ''}",
    );

    if (response.isSuccess && response.responseData != null) {
      final List<dynamic> data = response.responseData;
      _reports = data.map((json) => ReportModel.fromJson(json)).toList();
    } else {
      _reports = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // UI Helpers (Legacy compatibility or derived data)
  List<ReportModel> get displayedTickets {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    if (startIndex >= _reports.length) return [];

    return _reports.sublist(
      startIndex,
      endIndex > _reports.length ? _reports.length : endIndex,
    );
  }

  int get totalPages => (_reports.length / _itemsPerPage).ceil() == 0
      ? 1
      : (_reports.length / _itemsPerPage).ceil();

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

  Future<bool> handleReportAction({
    required String reportId,
    required String action, // "DISMISS", "WARN", "BAN"
    String? note,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Mapping actions to API status updates or specialized endpoints
    String status = "PENDING";
    if (action == "DISMISS") status = "RESOLVED";
    if (action == "WARN") status = "WARNED";
    if (action == "BAN") status = "BANNED";

    final response = await NetworkCaller.patchRequest(
      "${AppUrls.reports}/$reportId",
      body: {"status": status, "note": note ?? ""},
    );

    _isLoading = false;
    if (response.isSuccess) {
      loadReports(); // Refresh list
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<bool> toggleUserStatus(String userId, String currentStatus) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final newStatus = currentStatus == "ACTIVE" ? "INACTIVE" : "ACTIVE";

    final response = await NetworkCaller.postRequest(
      "${AppUrls.updateUserStatus}/$userId",
      body: {
        "userId": userId,
        "account_status": newStatus,
        "status": newStatus,
      },
    );

    _isLoading = false;

    if (response.isSuccess) {
      loadReports(); // Refresh to get updated status
      notifyListeners();
      return true;
    }

    _errorMessage =
        response.errorMessage ??
        (response.responseData is Map
            ? response.responseData['message']
            : null) ??
        "Failed to update status";
    notifyListeners();
    return false;
  }
}
