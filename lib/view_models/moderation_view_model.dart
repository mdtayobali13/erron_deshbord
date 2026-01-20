import 'package:flutter/material.dart';
import '../models/moderation_ticket_model.dart';

class ModerationViewModel extends ChangeNotifier {
  String _selectedFilter = "All";
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  final List<ModerationTicket> _tickets = [
    ModerationTicket(
      ticketId: "RPT-1001",
      reporter: "user1",
      target: "streamer1",
      category: "Nudity",
      time: "5 min ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1002",
      reporter: "user2",
      target: "streamer2",
      category: "Harassment",
      time: "10 min ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1003",
      reporter: "user3",
      target: "streamer3",
      category: "Scam",
      time: "15 min ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1004",
      reporter: "user4",
      target: "streamer4",
      category: "Violence",
      time: "20 min ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1005",
      reporter: "user5",
      target: "streamer5",
      category: "Hate Speech",
      time: "25 min ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1006",
      reporter: "user1",
      target: "streamer6",
      category: "Fake News",
      time: "30 min ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1007",
      reporter: "user2",
      target: "streamer7",
      category: "Nudity",
      time: "35 min ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1008",
      reporter: "user3",
      target: "streamer8",
      category: "Harassment",
      time: "40 min ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1009",
      reporter: "user4",
      target: "streamer9",
      category: "Violence",
      time: "45 min ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1010",
      reporter: "user5",
      target: "streamer10",
      category: "Scam",
      time: "50 min ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1011",
      reporter: "user1",
      target: "streamer11",
      category: "Hate Speech",
      time: "1 hour ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1012",
      reporter: "user2",
      target: "streamer12",
      category: "Fake News",
      time: "1 hour ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1013",
      reporter: "user3",
      target: "streamer13",
      category: "Nudity",
      time: "1 hour ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1014",
      reporter: "user4",
      target: "streamer14",
      category: "Harassment",
      time: "1 hour ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1015",
      reporter: "user5",
      target: "streamer15",
      category: "Violence",
      time: "2 hours ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1016",
      reporter: "user1",
      target: "streamer16",
      category: "Scam",
      time: "2 hours ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1017",
      reporter: "user2",
      target: "streamer17",
      category: "Hate Speech",
      time: "3 hours ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1018",
      reporter: "user3",
      target: "streamer18",
      category: "Fake News",
      time: "3 hours ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1019",
      reporter: "user4",
      target: "streamer19",
      category: "Nudity",
      time: "4 hours ago",
    ),
    ModerationTicket(
      ticketId: "RPT-1020",
      reporter: "user5",
      target: "streamer20",
      category: "Violence",
      time: "5 hours ago",
    ),
  ];

  String get selectedFilter => _selectedFilter;
  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  List<ModerationTicket> get allTickets => _tickets;

  void setSelectedFilter(String filter) {
    _selectedFilter = filter;
    _currentPage = 1; // Reset to page 1 on filter change
    notifyListeners();
  }

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  List<ModerationTicket> get filteredTickets {
    if (_selectedFilter == "All") return _tickets;
    if (_selectedFilter == "New") {
      // Logic for "New" (e.g., tickets from last hour or specific state)
      // For now, just return all as we don't have status, but let's mock it
      return _tickets
          .where((t) => t.time.contains("min") || t.time.contains("5 min"))
          .toList();
    }
    if (_selectedFilter == "Resolved") {
      // Mocking resolved tickets
      return [];
    }
    return _tickets;
  }

  List<ModerationTicket> get displayedTickets {
    final tickets = filteredTickets;
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    if (startIndex >= tickets.length) return [];

    return tickets.sublist(
      startIndex,
      endIndex > tickets.length ? tickets.length : endIndex,
    );
  }

  int get totalPages => (filteredTickets.length / _itemsPerPage).ceil() == 0
      ? 1
      : (filteredTickets.length / _itemsPerPage).ceil();

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
