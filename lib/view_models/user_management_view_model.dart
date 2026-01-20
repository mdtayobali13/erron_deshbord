import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserManagementViewModel extends ChangeNotifier {
  int _currentPage = 1;
  final int _itemsPerPage = 8;
  String _searchQuery = "";

  final List<AppUser> _users = [
    AppUser(
      userId: "User-001",
      userName: "sarahjenkins",
      userAvatar:
          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      trustScore: 92,
      legitPercentage: 92,
      suspiciousPercentage: 8,
      tokens: "5,420",
      kycStatus: "Verified",
    ),
    AppUser(
      userId: "User-002",
      userName: "tyradhillon",
      userAvatar:
          "https://images.unsplash.com/photo-1524504526464-051c57c51ad3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      trustScore: 96,
      legitPercentage: 96,
      suspiciousPercentage: 4,
      tokens: "8,420",
      kycStatus: "Verified",
    ),
    AppUser(
      userId: "User-003",
      userName: "toxicuser",
      userAvatar:
          "https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      trustScore: 92,
      legitPercentage: 92,
      suspiciousPercentage: 8,
      tokens: "5,420",
      kycStatus: "Rejected",
      isShadowBanned: true,
    ),
    AppUser(
      userId: "User-004",
      userName: "emmaart",
      userAvatar:
          "https://images.unsplash.com/photo-1517841905240-472988bad1fa?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      trustScore: 92,
      legitPercentage: 92,
      suspiciousPercentage: 8,
      tokens: "9,420",
      kycStatus: "Pending",
    ),
    AppUser(
      userId: "User-005",
      userName: "sarahjenkins_v2",
      userAvatar:
          "https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      trustScore: 92,
      legitPercentage: 92,
      suspiciousPercentage: 8,
      tokens: "5,420",
      kycStatus: "Verified",
    ),
    AppUser(
      userId: "User-006",
      userName: "tyradhillon_v2",
      userAvatar:
          "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      trustScore: 96,
      legitPercentage: 96,
      suspiciousPercentage: 4,
      tokens: "8,420",
      kycStatus: "Verified",
    ),
    AppUser(
      userId: "User-007",
      userName: "toxicuser_v2",
      userAvatar:
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      trustScore: 92,
      legitPercentage: 92,
      suspiciousPercentage: 8,
      tokens: "5,420",
      kycStatus: "Rejected",
      isShadowBanned: true,
    ),
    AppUser(
      userId: "User-008",
      userName: "emmaart_v2",
      userAvatar:
          "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      trustScore: 92,
      legitPercentage: 92,
      suspiciousPercentage: 8,
      tokens: "9,420",
      kycStatus: "Pending",
    ),
    // Additional users for pagination
    AppUser(
      userId: "User-009",
      userName: "jane_doe",
      userAvatar:
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      trustScore: 88,
      legitPercentage: 88,
      suspiciousPercentage: 12,
      tokens: "2,100",
      kycStatus: "Verified",
    ),
    AppUser(
      userId: "User-010",
      userName: "mike_stone",
      userAvatar:
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      trustScore: 94,
      legitPercentage: 94,
      suspiciousPercentage: 6,
      tokens: "4,300",
      kycStatus: "Pending",
    ),
  ];

  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  String get searchQuery => _searchQuery;

  List<AppUser> get filteredUsers {
    if (_searchQuery.isEmpty) return _users;
    return _users.where((user) {
      return user.userName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.userId.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<AppUser> get displayedUsers {
    final filteredList = filteredUsers;
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    if (startIndex >= filteredList.length) return [];

    return filteredList.sublist(
      startIndex,
      endIndex > filteredList.length ? filteredList.length : endIndex,
    );
  }

  int get totalPages => (filteredUsers.length / _itemsPerPage).ceil() == 0
      ? 1
      : (filteredUsers.length / _itemsPerPage).ceil();

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

  void updateSearch(String query) {
    _searchQuery = query;
    _currentPage = 1; // Reset to page 1 on search
    notifyListeners();
  }
}
