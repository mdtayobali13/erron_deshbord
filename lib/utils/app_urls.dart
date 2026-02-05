class AppUrls {
  static const String base = "https://api.instalive.cloud/api/v1";
  static const String authBase = "$base/auth";

  static const String login = "$authBase/login";
  static const String activeStreams = "$base/streaming/stats/active-streams";
  static const String pendingReports =
      "$base/streaming/interactions/stats/pending-reports";
  static const String pendingKyc = "$base/users/kyc/stats/pending";
  static const String activeStreamsList = "$base/streaming/all/streams";
  static const String resumeStream = "$base/streaming/resume";
  static const String stopStream = "$base/streaming/stop";
  static const String reports = "$base/streaming/interactions/report";
  static const String updateUserStatus =
      "$authBase/moderator/update-user-status";
  static const String userList = "$base/users/";
  static const String moderatorsList = "$base/users/all/moderators";
  static const String createModerator = "$base/auth/create-moderator";
  static const String updateModerator = "$base/auth/update-moderator";
  static const String systemConfig = "$base/admin/config";
  static const String auditLogs = "$base/admin/audit-logs";
  static const String kycVerificationLocation = "$base/users/kyc-verifications";
  static const String payouts = "$base/finance/admin/payouts";
  static const String userStatsMonthly = "$base/admin/stats/users/monthly";
  static const String revenueTrend = "$base/admin/stats/finance/revenue-trend";
  static const String payoutConfig = "$base/finance/admin/config/payout";
  static String payoutAction(String id) => "$payouts/$id/action";
}
