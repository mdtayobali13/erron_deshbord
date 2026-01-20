class PayoutRequest {
  final String id;
  final String hostName;
  final String hostAvatar;
  final String timeAgo;
  final String kycStatus; // Verified, Rejected, Pending
  final double amount;
  final int tokens;
  final String destination;
  final String status; // Pending, Approved, Declined

  PayoutRequest({
    required this.id,
    required this.hostName,
    required this.hostAvatar,
    required this.timeAgo,
    required this.kycStatus,
    required this.amount,
    required this.tokens,
    required this.destination,
    required this.status,
  });
}
