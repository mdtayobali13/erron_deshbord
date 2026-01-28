import 'package:flutter/material.dart';
import '../models/audit_log_model.dart';
import '../models/system_config_model.dart';
import '../models/payout_config_model.dart';
import '../services/network_caller.dart';
import '../utils/app_urls.dart';

class SystemConfigViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  SystemConfig? _config;
  SystemConfig? get config => _config;

  // Feature Toggles
  bool _enableGifting = true;
  bool _enablePaidStreams = true;
  bool _newUserSignups = true;

  bool get enableGifting => _enableGifting;
  bool get enablePaidStreams => _enablePaidStreams;
  bool get newUserSignups => _newUserSignups;

  // Pricing/Payout Configuration
  PayoutConfig? _payoutConfig;
  PayoutConfig? get payoutConfig => _payoutConfig;

  double _tokenPricing = 0.01;
  double _platformCommission = 30;
  double _minWithdrawalAmount = 50;

  double get tokenPricing => _tokenPricing;
  double get platformCommission => _platformCommission;
  double get minWithdrawalAmount => _minWithdrawalAmount;

  SystemConfigViewModel() {
    loadConfig();
  }

  Future<void> loadConfig() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await NetworkCaller.getRequest(AppUrls.systemConfig);

    if (response.isSuccess && response.responseData != null) {
      _config = SystemConfig.fromJson(response.responseData);
      _newUserSignups = _config?.enableRegistration ?? true;
      _enablePaidStreams = _config?.enablePaidStreams ?? true;
      _enableGifting = _config?.enableGifting ?? true;
    } else {
      _errorMessage = response.errorMessage ?? "Failed to load configuration";
    }

    await fetchAuditLogs(); // Fetch logs when loading config
    await loadPayoutConfig();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadPayoutConfig() async {
    final response = await NetworkCaller.getRequest(AppUrls.payoutConfig);
    if (response.isSuccess && response.responseData != null) {
      _payoutConfig = PayoutConfig.fromJson(response.responseData);
      _tokenPricing = _payoutConfig?.tokenRateUsd ?? 0.01;
      _platformCommission = _payoutConfig?.platformFeePercent ?? 30;
      _minWithdrawalAmount = _payoutConfig?.minWithdrawalAmount ?? 50;
      notifyListeners();
    }
  }

  void toggleGifting(bool value) {
    _enableGifting = value;
    notifyListeners();
    _updateConfig();
  }

  void togglePaidStreams(bool value) {
    _enablePaidStreams = value;
    notifyListeners();
    _updateConfig();
  }

  void toggleNewUserSignups(bool value) {
    _newUserSignups = value;
    notifyListeners();
    _updateConfig();
  }

  Future<void> _updateConfig() async {
    final updateData = {
      "enable_registration": _newUserSignups,
      "enable_paid_streams": _enablePaidStreams,
      "enable_gifting": _enableGifting,
    };

    print('🔧 [System Config] Updating configuration...');
    print('📤 [System Config] URL: ${AppUrls.systemConfig}');
    print('📦 [System Config] Data: $updateData');

    final response = await NetworkCaller.patchRequest(
      AppUrls.systemConfig,
      body: updateData,
    );

    if (response.isSuccess && response.responseData != null) {
      _config = SystemConfig.fromJson(response.responseData);
      print('✅ [System Config] Update successful!');
      print('📥 [System Config] Response: ${response.responseData}');
    } else {
      _errorMessage = response.errorMessage ?? "Failed to update configuration";
      print('❌ [System Config] Update failed: $_errorMessage');
      // Revert the change if update failed
      await loadConfig();
    }
    notifyListeners();
  }

  // Pricing Configuration
  void setTokenPricing(double value) {
    _tokenPricing = value;
    notifyListeners();
  }

  void setPlatformCommission(double value) {
    _platformCommission = value;
    notifyListeners();
  }

  void setMinWithdrawalAmount(double value) {
    _minWithdrawalAmount = value;
    notifyListeners();
  }

  Future<bool> updatePayoutConfig() async {
    _isLoading = true;
    notifyListeners();

    final body = {
      "token_rate_usd": _tokenPricing,
      "platform_fee_percent": _platformCommission,
      "min_withdrawal_amount": _minWithdrawalAmount,
    };

    final response = await NetworkCaller.patchRequest(
      AppUrls.payoutConfig,
      body: body,
    );

    _isLoading = false;
    if (response.isSuccess) {
      if (response.responseData != null) {
        _payoutConfig = PayoutConfig.fromJson(response.responseData);
      }
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  // Audit Logs
  List<AuditLog> _logs = [];

  // Expose logs directly as they are now fetched per page
  List<AuditLog> get displayedLogs => _logs;

  int _currentPage = 1;
  final int _itemsPerPage = 20;

  int get currentPage => _currentPage;

  // Since API doesn't return total count in the array response, we infer availability of next page
  int get totalPages {
    if (_logs.length < _itemsPerPage) return _currentPage;
    return _currentPage + 1;
  }

  Future<void> fetchAuditLogs() async {
    final skip = (_currentPage - 1) * _itemsPerPage;
    final url = "${AppUrls.auditLogs}?limit=$_itemsPerPage&skip=$skip";

    print('🔍 [Audit Logs] Fetching logs: $url');

    final response = await NetworkCaller.getRequest(url);

    if (response.isSuccess && response.responseData != null) {
      final List<dynamic> data = response.responseData;
      _logs = data.map((json) => AuditLog.fromJson(json)).toList();
      print('✅ [Audit Logs] Fetched ${_logs.length} logs');
    } else {
      print('❌ [Audit Logs] Failed to fetch logs: ${response.errorMessage}');
    }
    notifyListeners();
  }

  void setPage(int page) {
    _currentPage = page;
    fetchAuditLogs();
  }

  void nextPage() {
    _currentPage++;
    fetchAuditLogs();
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      fetchAuditLogs();
    }
  }
}
