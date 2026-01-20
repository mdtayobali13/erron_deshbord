class AuditLog {
  final String id;
  final String moderator;
  final String action;
  final String target;
  final String severity; // High, Medium, Low
  final String timestamp;

  AuditLog({
    required this.id,
    required this.moderator,
    required this.action,
    required this.target,
    required this.severity,
    required this.timestamp,
  });
}
