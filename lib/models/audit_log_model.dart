class AuditLog {
  final String? id;
  final String? action;
  final String? target;
  final String? severity;
  final String? details;
  final DateTime? timestamp;
  final String? actorName;

  AuditLog({
    this.id,
    this.action,
    this.target,
    this.severity,
    this.details,
    this.timestamp,
    this.actorName,
  });

  factory AuditLog.fromJson(Map<String, dynamic> json) {
    return AuditLog(
      id: json['id'],
      action: json['action'],
      target: json['target'],
      severity: json['severity'],
      details: json['details'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
      actorName: json['actor_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'action': action,
      'target': target,
      'severity': severity,
      'details': details,
      'timestamp': timestamp?.toIso8601String(),
      'actor_name': actorName,
    };
  }

  // Getter for moderator name (for backward compatibility)
  String get moderator => actorName ?? "Unknown";
}
