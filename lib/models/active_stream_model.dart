class ActiveStreamModel {
  String? id;
  Host? host;
  String? channelName;
  String? title;
  String? category;
  String? thumbnail;
  bool? isPremium;
  int? entryFee;
  String? startTime;
  String? endTime;
  int? totalLikes;
  int? earnCoins;
  String? livekitToken;
  int? totalViews;
  int? totalComments;
  String? status;
  String? createdAt;
  String? updatedAt;
  bool? isFrozen;

  ActiveStreamModel({
    this.id,
    this.host,
    this.channelName,
    this.title,
    this.category,
    this.thumbnail,
    this.isPremium,
    this.entryFee,
    this.startTime,
    this.endTime,
    this.totalLikes,
    this.earnCoins,
    this.livekitToken,
    this.totalViews,
    this.totalComments,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isFrozen,
  });

  ActiveStreamModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    host = json['host'] != null ? Host.fromJson(json['host']) : null;
    channelName = json['channel_name'];
    title = json['title'];
    category = json['category'];
    thumbnail = json['thumbnail'];
    isPremium = json['is_premium'];
    entryFee = json['entry_fee'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    totalLikes = json['total_likes'];
    earnCoins = json['earn_coins'];
    livekitToken = json['livekit_token'];
    totalViews = json['total_views'];
    totalComments = json['total_comments'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isFrozen = json['is_frozen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (host != null) {
      data['host'] = host!.toJson();
    }
    data['channel_name'] = channelName;
    data['title'] = title;
    data['category'] = category;
    data['thumbnail'] = thumbnail;
    data['is_premium'] = isPremium;
    data['entry_fee'] = entryFee;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['total_likes'] = totalLikes;
    data['earn_coins'] = earnCoins;
    data['livekit_token'] = livekitToken;
    data['total_views'] = totalViews;
    data['total_comments'] = totalComments;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Host {
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
  Kyc? kyc;

  Host({
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

  Host.fromJson(Map<String, dynamic> json) {
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
    kyc = json['kyc'] != null ? Kyc.fromJson(json['kyc']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['coins'] = coins;
    data['is_online'] = isOnline;
    data['following_count'] = followingCount;
    data['followers_count'] = followersCount;
    data['total_likes'] = totalLikes;
    data['is_verified'] = isVerified;
    data['profile_image'] = profileImage;
    data['cover_image'] = coverImage;
    data['bio'] = bio;
    data['gender'] = gender;
    data['country'] = country;
    data['date_of_birth'] = dateOfBirth;
    data['shady'] = shady;
    data['auth_provider'] = authProvider;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['role'] = role;
    data['otp'] = otp;
    data['account_status'] = accountStatus;
    if (kyc != null) {
      data['kyc'] = kyc!.toJson();
    }
    return data;
  }
}

class Kyc {
  String? idFront;
  String? idBack;
  String? status;
  Null rejectionReason;
  String? createdAt;
  String? updatedAt;

  Kyc({
    this.idFront,
    this.idBack,
    this.status,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
  });

  Kyc.fromJson(Map<String, dynamic> json) {
    idFront = json['id_front'];
    idBack = json['id_back'];
    status = json['status'];
    rejectionReason = json['rejection_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_front'] = idFront;
    data['id_back'] = idBack;
    data['status'] = status;
    data['rejection_reason'] = rejectionReason;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
