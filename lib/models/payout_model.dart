class PayoutRequest {
  String? id;
  PayoutUser? user;
  PayoutBeneficiary? beneficiary;
  int? amountCoins;
  num? amountFiat;
  num? platformFee;
  num? finalAmount;
  String? status;
  String? adminNote;
  String? createdAt;
  String? updatedAt;

  PayoutRequest({
    this.id,
    this.user,
    this.beneficiary,
    this.amountCoins,
    this.amountFiat,
    this.platformFee,
    this.finalAmount,
    this.status,
    this.adminNote,
    this.createdAt,
    this.updatedAt,
  });

  PayoutRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? PayoutUser.fromJson(json['user']) : null;
    beneficiary = json['beneficiary'] != null
        ? PayoutBeneficiary.fromJson(json['beneficiary'])
        : null;
    amountCoins = json['amount_coins'];
    amountFiat = json['amount_fiat'];
    platformFee = json['platform_fee'];
    finalAmount = json['final_amount'];
    status = json['status'];
    adminNote = json['admin_note'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  // UI Helper Getters
  String get hostName {
    if (user == null) return "Unknown";
    if ((user!.firstName != null && user!.firstName!.isNotEmpty) ||
        (user!.lastName != null && user!.lastName!.isNotEmpty)) {
      return "${user!.firstName ?? ''} ${user!.lastName ?? ''}".trim();
    }
    return user!.email ?? "Unknown";
  }

  String get hostAvatar =>
      user?.profileImage ??
      "https://cdn.pixabay.com/photo/2017/06/13/12/54/profile-2398783_1280.png";

  String get timeAgo =>
      createdAt != null ? _calculateTimeAgo(createdAt!) : 'Just now';

  String get baseKycStatus => user?.kyc?.status ?? 'Pending';

  String get kycStatus => _capitalize(baseKycStatus);

  double get amount => (amountFiat ?? 0).toDouble();

  int get tokens => amountCoins ?? 0;

  String get destination {
    if (beneficiary == null) return "Unknown";
    final method = beneficiary!.method ?? 'Unknown';
    // Handle dynamic details
    String detailStr = "";
    if (beneficiary!.details != null && beneficiary!.details!.isNotEmpty) {
      detailStr = beneficiary!.details!.values.first.toString();
    }

    if (detailStr.length > 5) {
      detailStr = "***${detailStr.substring(detailStr.length - 4)}";
    }
    return "$method: $detailStr";
  }

  String get displayStatus => _capitalize(status ?? 'Pending');

  static String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

  static String _calculateTimeAgo(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateString;
    }
  }
}

class PayoutUser {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;
  PayoutKyc? kyc;

  PayoutUser({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.profileImage,
    this.kyc,
  });

  PayoutUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    profileImage = json['profile_image'];
    kyc = json['kyc'] != null ? PayoutKyc.fromJson(json['kyc']) : null;
  }
}

class PayoutKyc {
  String? status;
  String? rejectionReason;

  PayoutKyc({this.status, this.rejectionReason});

  PayoutKyc.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    rejectionReason = json['rejection_reason'];
  }
}

class PayoutBeneficiary {
  String? id;
  String? method;
  Map<String, dynamic>? details;

  PayoutBeneficiary({this.id, this.method, this.details});

  PayoutBeneficiary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    method = json['method'];
    details = json['details'];
  }
}
