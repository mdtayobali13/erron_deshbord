import 'package:flutter/material.dart';
import '../models/moderator_model.dart';

class ModeratorViewModel extends ChangeNotifier {
  final List<Moderator> _moderators = [
    Moderator(
      id: "mod-1",
      name: "Maria Garcia",
      username: "moderator1",
      avatar:
          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      status: "Inactive",
      reports: 1089,
      bans: 89,
      appeals: 156,
      accuracy: 96,
      joinedDate: "Feb 3, 2023",
    ),
    Moderator(
      id: "mod-2",
      name: "Dianne Russell",
      username: "moderator2",
      avatar:
          "https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      status: "Inactive",
      reports: 1089,
      bans: 89,
      appeals: 156,
      accuracy: 96,
      joinedDate: "Feb 3, 2023",
    ),
    Moderator(
      id: "mod-3",
      name: "Floyd Miles",
      username: "moderator3",
      avatar:
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      status: "Inactive",
      reports: 1089,
      bans: 89,
      appeals: 156,
      accuracy: 96,
      joinedDate: "Feb 3, 2023",
    ),
    Moderator(
      id: "mod-4",
      name: "Kathryn Murphy",
      username: "moderator4",
      avatar:
          "https://images.unsplash.com/photo-1517841905240-472988bad1fa?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      status: "Inactive",
      reports: 1089,
      bans: 89,
      appeals: 156,
      accuracy: 96,
      joinedDate: "Feb 3, 2023",
    ),
    Moderator(
      id: "mod-5",
      name: "Brooklyn Simmons",
      username: "moderator4",
      avatar:
          "https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      status: "Inactive",
      reports: 1089,
      bans: 89,
      appeals: 156,
      accuracy: 96,
      joinedDate: "Feb 3, 2023",
    ),
    Moderator(
      id: "mod-6",
      name: "Ronald Richards",
      username: "moderator6",
      avatar:
          "https://images.unsplash.com/photo-1521119956491-c7ef7368d581?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      status: "Inactive",
      reports: 1089,
      bans: 89,
      appeals: 156,
      accuracy: 96,
      joinedDate: "Feb 3, 2023",
    ),
  ];

  int _currentPage = 1;
  final int _itemsPerPage = 6;

  List<Moderator> get moderators => _moderators;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;
  int get currentPage => _currentPage;

  void updateSearch(String query) {
    _searchQuery = query;
    _currentPage = 1;
    notifyListeners();
  }

  List<Moderator> get filteredModerators {
    if (_searchQuery.isEmpty) return _moderators;
    return _moderators
        .where(
          (m) =>
              m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              m.username.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
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

  void deleteModerator(String id) {
    _moderators.removeWhere((m) => m.id == id);
    if (displayedModerators.isEmpty && _currentPage > 1) {
      _currentPage--;
    }
    notifyListeners();
  }
}
