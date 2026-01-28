import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/network_caller.dart';
import '../utils/app_urls.dart';

class UserManagementViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<AppUser> _users = [];
  List<AppUser> get users => _users;

  String _searchQuery = "";
  String _selectedStatus = "All Status";
  String _selectedVerified = "Is Verified";

  int _currentPage = 1;
  final int _itemsPerPage = 8;

  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;

  UserManagementViewModel() {
    loadUsers();
  }

  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    print('🔍 [Users] Fetching from: ${AppUrls.userList}');
    final response = await NetworkCaller.getRequest(AppUrls.userList);

    if (response.isSuccess && response.responseData != null) {
      final List<dynamic> data = response.responseData;
      print('✅ [Users] Fetched ${data.length} users');
      print(
        '📦 [Users] Response Data: $data',
      ); // Printing response as requested
      _users = data.map((json) => AppUser.fromJson(json)).toList();
    } else {
      print('❌ [Users] Failed to fetch users: ${response.errorMessage}');
      _users = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _currentPage = 1;
    notifyListeners();
  }

  void updateSearch(String query) => setSearchQuery(query);

  void setStatusFilter(String status) {
    _selectedStatus = status;
    _currentPage = 1;
    notifyListeners();
  }

  void setVerifiedFilter(String filter) {
    _selectedVerified = filter;
    _currentPage = 1;
    notifyListeners();
  }

  List<AppUser> get filteredUsers {
    return _users.where((user) {
      final matchesSearch =
          user.userName.toLowerCase().contains(_searchQuery) ||
          user.userId.toLowerCase().contains(_searchQuery);

      bool matchesStatus = true;
      if (_selectedStatus == "Active") {
        matchesStatus = user.accountStatus == "ACTIVE";
      } else if (_selectedStatus == "Inactive") {
        matchesStatus = user.accountStatus == "INACTIVE";
      }

      bool matchesVerified = true;
      if (_selectedVerified == "Verified") {
        matchesVerified = user.isVerified == true;
      } else if (_selectedVerified == "Not Verified") {
        matchesVerified = user.isVerified == false;
      }

      bool matchesRole = user.role?.toUpperCase() != "ADMIN";

      return matchesSearch && matchesStatus && matchesVerified && matchesRole;
    }).toList();
  }

  List<AppUser> get displayedUsers {
    final filtered = filteredUsers;
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    if (startIndex >= filtered.length) return [];

    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }

  int get totalPages => (filteredUsers.length / _itemsPerPage).ceil() == 0
      ? 1
      : (filteredUsers.length / _itemsPerPage).ceil();

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

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  Future<bool> toggleUserStatus(String userId, String currentStatus) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final newStatus = currentStatus == "ACTIVE" ? "INACTIVE" : "ACTIVE";

    print("🔘 User Status Update Initiated - New Status: $newStatus");
    print("📤 Request URL: ${"${AppUrls.updateUserStatus}/$userId"}");
    print(
      "📤 Request Body: ${{"userId": userId, "account_status": newStatus, "status": newStatus}}",
    );

    final response = await NetworkCaller.patchRequest(
      "${AppUrls.updateUserStatus}/$userId",
      body: {
        "userId": userId,
        "account_status": newStatus,
        "status": newStatus,
      },
    );

    print("📥 Response Status Code: ${response.statusCode}");
    print("📥 Response Data: ${response.responseData}");

    if (response.isSuccess) {
      final index = _users.indexWhere((u) => u.id == userId);
      if (index != -1) {
        _users[index].accountStatus = newStatus;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _errorMessage =
        response.errorMessage ??
        (response.responseData is Map
            ? response.responseData['message']
            : null) ??
        "Failed to update status";
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updateKycStatus(
    String id,
    String status, {
    String? rejectionReason,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final Map<String, dynamic> body = {
      "status": status,
      if (rejectionReason != null && rejectionReason.isNotEmpty)
        "rejection_reason": rejectionReason,
    };

    print("🔘 KYC Update Initiated - Action: $status");
    print("📤 Request URL: ${"${AppUrls.kycVerificationLocation}/$id"}");
    print("📤 Request Body: $body");

    final response = await NetworkCaller.patchRequest(
      "${AppUrls.kycVerificationLocation}/$id",
      body: body,
    );

    print("📥 Response Status Code: ${response.statusCode}");
    print("📥 Response Data: ${response.responseData}");
    print("📥 Response Error Error: ${response.errorMessage}");

    if (response.isSuccess) {
      // Try to find the user by ID if the ID passed is indeed the user ID.
      // If it's a KYC ID, we might not find it directly so easily unless we knew which user it belongs to.
      // Assuming for now ID == userId or we reload.
      // Safe bet: find user with this ID.
      final index = _users.indexWhere((u) => u.id == id);
      if (index != -1) {
        if (_users[index].kyc != null) {
          _users[index].kyc!.status = status;
          _users[index].kyc!.rejectionReason = rejectionReason;
        }
      }
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _errorMessage =
        response.errorMessage ??
        (response.responseData is Map
            ? response.responseData['message']
            : null) ??
        "Failed to update KYC status";
    _isLoading = false;
    notifyListeners();
    return false;
  }
}
