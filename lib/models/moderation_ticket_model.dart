class ModerationTicket {
  final String ticketId;
  final String reporter;
  final String target;
  final String category;
  final String time;

  ModerationTicket({
    required this.ticketId,
    required this.reporter,
    required this.target,
    required this.category,
    required this.time,
  });

  factory ModerationTicket.fromMap(Map<String, String> map) {
    return ModerationTicket(
      ticketId: map['ticket'] ?? '',
      reporter: map['reporter'] ?? '',
      target: map['target'] ?? '',
      category: map['category'] ?? '',
      time: map['time'] ?? '',
    );
  }
}
