class AppealUser {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final int? coins;
  final bool? isOnline;
  final int? followingCount;
  final int? followersCount;
  final int? totalLikes;
  final bool? isVerified;
  final String? profileImage;
  final String? coverImage;
  final String? bio;
  final String? gender;
  final String? country;
  final String? dateOfBirth;
  final int? shady;
  final String? authProvider;
  final String? createdAt;
  final String? updatedAt;
  final String? role;
  final String? otp;
  final String? accountStatus;
  final dynamic kyc;

  AppealUser({
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

  factory AppealUser.fromJson(Map<String, dynamic> json) {
    return AppealUser(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      coins: json['coins'],
      isOnline: json['is_online'],
      followingCount: json['following_count'],
      followersCount: json['followers_count'],
      totalLikes: json['total_likes'],
      isVerified: json['is_verified'],
      profileImage: json['profile_image'],
      coverImage: json['cover_image'],
      bio: json['bio'],
      gender: json['gender'],
      country: json['country'],
      dateOfBirth: json['date_of_birth'],
      shady: json['shady'],
      authProvider: json['auth_provider'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      role: json['role'],
      otp: json['otp'],
      accountStatus: json['account_status'],
      kyc: json['kyc'],
    );
  }
}

class Appeal {
  final String? id;
  final String? message;
  final String? status;
  final AppealUser? user;
  final List<dynamic>? reports;
  final List<dynamic>? reportReviews;
  final String? createdAt;
  final String? updatedAt;

  Appeal({
    this.id,
    this.message,
    this.status,
    this.user,
    this.reports,
    this.reportReviews,
    this.createdAt,
    this.updatedAt,
  });

  factory Appeal.fromJson(Map<String, dynamic> json) {
    return Appeal(
      id: json['id'],
      message: json['message'],
      status: json['status'],
      user: json['user'] != null ? AppealUser.fromJson(json['user']) : null,
      reports: json['reports'] ?? [],
      reportReviews: json['report_reviews'] ?? [],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  String get userName {
    if (user == null) return 'Unknown User';
    return '${user!.firstName ?? ''} ${user!.lastName ?? ''}'.trim();
  }

  String get userAvatar {
    return user?.profileImage ??
        'https://i.pravatar.cc/150?u=${user?.email ?? 'default'}';
  }

  String get timeAgo {
    if (createdAt == null) return 'Unknown';
    try {
      final dateTime = DateTime.parse(createdAt!);
      final difference = DateTime.now().difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} min ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  String get originalReason {
    // This would come from the reports array if available
    if (reports != null && reports!.isNotEmpty) {
      return 'Violation reported';
    }
    return 'Appeal request';
  }

  String get appealMessage {
    return message ?? 'No message provided';
  }
}
