import 'package:flutter/material.dart';
import '../models/appeal_model.dart';

class AppealsViewModel extends ChangeNotifier {
  final List<Appeal> _appeals = [
    Appeal(
      id: "1",
      userName: "Dianne Russell",
      userAvatar: "https://i.pravatar.cc/150?u=dianne",
      timeAgo: "2 hours ago",
      originalReason: "Nudity in stream",
      appealMessage:
          "I sincerely apologize for my actions. It was a mistake and I was not aware that my clothing violated the community guidelines. I have reviewed the rules thoroughly and promise to follow them strictly going forward. Please give me another chance to be part of this community.",
      status: "Pending",
    ),
    Appeal(
      id: "2",
      userName: "Dianne Russell",
      userAvatar: "https://i.pravatar.cc/150?u=dianne",
      timeAgo: "2 hours ago",
      originalReason: "Harassment of other users",
      appealMessage:
          "I deeply regret my behavior towards other community members. I was going through a difficult time, but that is no excuse. I have taken time to reflect on my actions and understand the harm I caused. I would be grateful for the opportunity to make amends and contribute positively to the platform.",
      status: "Pending",
    ),
    Appeal(
      id: "3",
      userName: "Dianne Russell",
      userAvatar: "https://i.pravatar.cc/150?u=dianne",
      timeAgo: "2 hours ago",
      originalReason: "Scam attempt",
      appealMessage:
          "I understand why I was banned and I take full responsibility. What I did was wrong and violated the trust of the community. I have learned my lesson and would never attempt anything like that again. I miss being part of this platform and hope you can find it in your hearts to give me one more chance.",
      status: "Pending",
    ),
    Appeal(
      id: "4",
      userName: "Guy Hawkins",
      userAvatar: "https://i.pravatar.cc/150?u=guy",
      timeAgo: "5 hours ago",
      originalReason: "Spamming",
      appealMessage:
          "I was just trying to share some interesting links with my friends. I didn't realize it would be considered spam. I'll be more careful next time.",
      status: "Pending",
    ),
    Appeal(
      id: "5",
      userName: "Eleanor Pena",
      userAvatar: "https://i.pravatar.cc/150?u=eleanor",
      timeAgo: "1 day ago",
      originalReason: "Inappropriate language",
      appealMessage:
          "I'm sorry for the words I used. I was frustrated and lost my cool. It won't happen again.",
      status: "Pending",
    ),
  ];

  int _currentPage = 1;
  final int _itemsPerPage = 3;

  int get currentPage => _currentPage;

  List<Appeal> get displayedAppeals {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _appeals.length) return [];
    return _appeals.sublist(
      startIndex,
      endIndex > _appeals.length ? _appeals.length : endIndex,
    );
  }

  int get totalPages => (_appeals.length / _itemsPerPage).ceil();

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
