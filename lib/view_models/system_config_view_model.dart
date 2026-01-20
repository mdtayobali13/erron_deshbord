import 'package:flutter/material.dart';
import '../models/audit_log_model.dart';

class SystemConfigViewModel extends ChangeNotifier {
  // Feature Toggles
  bool _enableGifting = true;
  bool _enablePaidStreams = true;
  bool _newUserSignups = true;

  bool get enableGifting => _enableGifting;
  bool get enablePaidStreams => _enablePaidStreams;
  bool get newUserSignups => _newUserSignups;

  void toggleGifting(bool value) {
    _enableGifting = value;
    notifyListeners();
  }

  void togglePaidStreams(bool value) {
    _enablePaidStreams = value;
    notifyListeners();
  }

  void toggleNewUserSignups(bool value) {
    _newUserSignups = value;
    notifyListeners();
  }

  // Pricing Configuration
  double _tokenPricing = 0.01;
  int _platformCommission = 30;

  double get tokenPricing => _tokenPricing;
  int get platformCommission => _platformCommission;

  void setTokenPricing(double value) {
    _tokenPricing = value;
    notifyListeners();
  }

  void setPlatformCommission(int value) {
    _platformCommission = value;
    notifyListeners();
  }

  // Audit Logs
  final List<AuditLog> _logs = List.generate(
    25,
    (index) => AuditLog(
      id: "LOG-0${index + 1}",
      moderator: index % 2 == 0 ? "ModeratorJohn" : "AdminSarah",
      action: index % 3 == 0
          ? "Banned User"
          : (index % 3 == 1 ? "Approved KYC" : "Updated Config"),
      target: index % 2 == 0 ? "user_${index}" : "System",
      severity: index % 3 == 0 ? "High" : (index % 3 == 1 ? "Medium" : "Low"),
      timestamp: "${10 + (index % 2)}:${(index * 2) % 60} AM",
    ),
  );

  int _currentPage = 1;
  final int _itemsPerPage = 10;

  int get currentPage => _currentPage;

  List<AuditLog> get displayedLogs {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _logs.length) return [];
    return _logs.sublist(
      startIndex,
      endIndex > _logs.length ? _logs.length : endIndex,
    );
  }

  int get totalPages => (_logs.length / _itemsPerPage).ceil() == 0
      ? 1
      : (_logs.length / _itemsPerPage).ceil();

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
}
