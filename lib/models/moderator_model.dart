class Moderator {
  final String id;
  final String name;
  final String username;
  final String avatar;
  final String status; // Active, Inactive
  final int reports;
  final int bans;
  final int appeals;
  final int accuracy;
  final String joinedDate;

  Moderator({
    required this.id,
    required this.name,
    required this.username,
    required this.avatar,
    required this.status,
    required this.reports,
    required this.bans,
    required this.appeals,
    required this.accuracy,
    required this.joinedDate,
  });
}
