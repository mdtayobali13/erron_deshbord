import 'package:flutter/material.dart';
import '../models/payout_model.dart';
import '../services/network_caller.dart';
import '../utils/app_urls.dart';

class FinanceViewModel extends ChangeNotifier {
  List<PayoutRequest> _requests = [];
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Pagination props
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;

  FinanceViewModel() {
    loadPayouts();
  }

  Future<void> loadPayouts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await NetworkCaller.getRequest(AppUrls.payouts);

    if (response.isSuccess) {
      final List<dynamic> data = response.responseData ?? [];
      try {
        _requests = data.map((json) {
          try {
            return PayoutRequest.fromJson(json);
          } catch (e) {
            print("Error parsing PayoutRequest: $e");
            print("JSON: $json");
            rethrow;
          }
        }).toList();
      } catch (e) {
        print("Error processing payouts data: $e");
        _errorMessage = "Failed to parse payouts data";
      }
    } else {
      _errorMessage = response.errorMessage ?? "Failed to load payouts";
    }

    _isLoading = false;
    notifyListeners();
  }

  List<PayoutRequest> get displayedRequests {
    // For now, client-side pagination since API seems to return all
    if (_requests.isEmpty) return [];

    final startIndex = (_currentPage - 1) * _itemsPerPage;

    // Safety check if pagination index is out of bounds (e.g. after filtering or deletion)
    if (startIndex >= _requests.length) {
      // Automatically reset to first page or return empty if that was the issue
      // We can't easily mutate state in a getter safely without a scheduleMicrotask,
      // so we just safely return what we can or empty.
      return [];
    }

    final endIndex = startIndex + _itemsPerPage;

    return _requests.sublist(
      startIndex,
      endIndex > _requests.length ? _requests.length : endIndex,
    );
  }

  int get totalPages => (_requests.length / _itemsPerPage).ceil() == 0
      ? 1
      : (_requests.length / _itemsPerPage).ceil();

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

  Future<bool> updatePayoutStatus(
    String id,
    String action, {
    String note = "Processed by Admin",
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await NetworkCaller.postRequest(
      AppUrls.payoutAction(id),
      body: {"action": action, "note": note},
    );

    _isLoading = false;
    if (response.isSuccess) {
      // Update local state
      final index = _requests.indexWhere((r) => r.id == id);
      if (index != -1) {
        // API returns full updated object, we can use it or just update the status
        if (response.responseData != null) {
          try {
            _requests[index] = PayoutRequest.fromJson(response.responseData);
          } catch (e) {
            _requests[index].status = action == "approve"
                ? "approved"
                : "rejected";
          }
        } else {
          _requests[index].status = action == "approve"
              ? "approved"
              : "rejected";
        }
      }
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.errorMessage ?? "Failed to update payout status";
      notifyListeners();
      return false;
    }
  }
}
