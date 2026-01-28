import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../services/network_caller.dart';
import '../utils/app_urls.dart';

class ModerationQueueViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ReportModel> _reports = [];
  List<ReportModel> get reports => _reports;

  String _currentStatus = "PENDING"; // Default status
  String get currentStatus => _currentStatus;

  ModerationQueueViewModel() {
    loadReports();
  }

  void setStatus(String status) {
    _currentStatus = status;
    loadReports();
  }

  Future<void> loadReports() async {
    _isLoading = true;
    notifyListeners();

    // The API uses status as a query param
    final response = await NetworkCaller.getRequest(
      "${AppUrls.reports}?status=$_currentStatus",
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
}
