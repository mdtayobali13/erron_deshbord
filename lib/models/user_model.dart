class AppUser {
  final String userId;
  final String userName;
  final String userAvatar;
  final int trustScore;
  final int legitPercentage;
  final int suspiciousPercentage;
  final String tokens;
  final String kycStatus; // Verified, Rejected, Pending
  final bool isPro;
  final bool isShadowBanned;

  AppUser({
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.trustScore,
    required this.legitPercentage,
    required this.suspiciousPercentage,
    required this.tokens,
    required this.kycStatus,
    this.isPro = true,
    this.isShadowBanned = false,
  });
}
