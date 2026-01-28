class AppUser {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  int? coins;
  bool? isOnline;
  int? followingCount;
  int? followersCount;
  int? totalLikes;
  bool? isVerified;
  String? profileImage;
  String? coverImage;
  String? bio;
  String? gender;
  String? country;
  String? dateOfBirth;
  int? shady;
  String? authProvider;
  String? createdAt;
  String? updatedAt;
  String? role;
  String? otp;
  String? accountStatus;
  KycModel? kyc;

  AppUser({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.coins,
    this.isOnline,
    this.followingCount,
    this.followersCount,
    this.totalLikes,
    this.isVerified,
    this.profileImage,
    this.coverImage,
    this.bio,
    this.gender,
    this.country,
    this.dateOfBirth,
    this.shady,
    this.authProvider,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.otp,
    this.accountStatus,
    this.kyc,
  });

  AppUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    coins = json['coins'];
    isOnline = json['is_online'];
    followingCount = json['following_count'];
    followersCount = json['followers_count'];
    totalLikes = json['total_likes'];
    isVerified = json['is_verified'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    bio = json['bio'];
    gender = json['gender'];
    country = json['country'];
    dateOfBirth = json['date_of_birth'];
    shady = json['shady'];
    authProvider = json['auth_provider'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    role = json['role'];
    otp = json['otp'];
    accountStatus = json['account_status'];
    kyc = json['kyc'] != null ? KycModel.fromJson(json['kyc']) : null;
  }

  // Helper getters for UI compatibility
  String get userName => (firstName != null || lastName != null)
      ? "${firstName ?? ""} ${lastName ?? ""}".trim()
      : (email ?? "No Name");

  String get userAvatar => (profileImage != null && profileImage != "string")
      ? profileImage!
      : "https://cdn.pixabay.com/photo/2017/06/13/12/54/profile-2398783_1280.png";

  int get trustScore => 100 - (shady ?? 0);
  int get legitPercentage => 100 - (shady ?? 0);
  int get suspiciousPercentage => shady ?? 0;
  String get tokens => coins?.toString() ?? "0";
  String get kycStatus {
    if (kyc?.status == null || kyc?.status?.toLowerCase() == "not started") {
      return "Not Verified";
    }
    return kyc!.status!;
  }

  bool get isPro => isVerified ?? false;
  bool get isShadowBanned => (shady ?? 0) > 50;
  String get userId => id ?? "N/A";
}

class KycModel {
  String? id;
  String? idFront;
  String? idBack;
  String? status;
  String? rejectionReason;
  String? createdAt;
  String? updatedAt;

  KycModel({
    this.id,
    this.idFront,
    this.idBack,
    this.status,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
  });

  KycModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idFront = json['id_front'];
    idBack = json['id_back'];
    status = json['status'];
    rejectionReason = json['rejection_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
