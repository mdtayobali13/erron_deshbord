import 'package:flutter/material.dart';
import '../models/payout_model.dart';

class FinanceViewModel extends ChangeNotifier {
  final List<PayoutRequest> _requests = List.generate(
    25,
    (index) => PayoutRequest(
      id: (index + 1).toString(),
      hostName: "Sarah Streams",
      hostAvatar: "https://i.pravatar.cc/150?u=sarah${index}",
      timeAgo: "1 hour ago",
      kycStatus: index % 3 == 0
          ? "Verified"
          : (index % 3 == 1 ? "Rejected" : "Pending"),
      amount: (35 + (index * 12.5)),
      tokens: (3500 + (index * 1250)),
      destination: index % 2 == 0
          ? "PayPal: sa***"
          : "Bank: ***123${index % 10}",
      status: index % 4 == 0
          ? "Pending"
          : (index % 4 == 1 ? "Approved" : "Declined"),
    ),
  );

  int _currentPage = 1;
  final int _itemsPerPage = 10;

  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;

  List<PayoutRequest> get displayedRequests {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _requests.length) return [];
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
}
