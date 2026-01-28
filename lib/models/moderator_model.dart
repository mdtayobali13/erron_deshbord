class Moderator {
  final String? id;
  final String? fullName;
  final String? email;
  final String? username;
  final String? role;
  final bool? isActive;
  final bool? canViewReports;
  final bool? canReviewAppeals;
  final bool? canAccessLiveMonitor;
  final bool? canSystemConfig;
  final bool? canIssueBans;
  final bool? canManageUsers;
  final bool? canApprovePayouts;
  final int? suspendedCount;
  final int? activatedCount;
  final int? inactivatedCount;
  final int? reportedCount;
  final int? appealCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Moderator({
    this.id,
    this.fullName,
    this.email,
    this.username,
    this.role,
    this.isActive,
    this.canViewReports,
    this.canReviewAppeals,
    this.canAccessLiveMonitor,
    this.canSystemConfig,
    this.canIssueBans,
    this.canManageUsers,
    this.canApprovePayouts,
    this.suspendedCount,
    this.activatedCount,
    this.inactivatedCount,
    this.reportedCount,
    this.appealCount,
    this.createdAt,
    this.updatedAt,
  });

  factory Moderator.fromJson(Map<String, dynamic> json) {
    return Moderator(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      username: json['username'],
      role: json['role'],
      isActive: json['is_active'],
      canViewReports: json['can_view_reports'],
      canReviewAppeals: json['can_review_appeals'],
      canAccessLiveMonitor: json['can_access_live_monitor'],
      canSystemConfig: json['can_system_config'],
      canIssueBans: json['can_issue_bans'],
      canManageUsers: json['can_manage_users'],
      canApprovePayouts: json['can_approve_payouts'],
      suspendedCount: json['suspended_count'],
      activatedCount: json['activated_count'],
      inactivatedCount: json['inactivated_count'],
      reportedCount: json['reported_count'],
      appealCount: json['appeal_count'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'username': username,
      'role': role,
      'is_active': isActive,
      'can_view_reports': canViewReports,
      'can_review_appeals': canReviewAppeals,
      'can_access_live_monitor': canAccessLiveMonitor,
      'can_system_config': canSystemConfig,
      'can_issue_bans': canIssueBans,
      'can_manage_users': canManageUsers,
      'can_approve_payouts': canApprovePayouts,
      'suspended_count': suspendedCount,
      'activated_count': activatedCount,
      'inactivated_count': inactivatedCount,
      'reported_count': reportedCount,
      'appeal_count': appealCount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
