class ReportModel {
  String? id;
  ReportSession? session;
  ReporterUser? reporterUser;
  ReporterModerator? reporterModerator;
  String? category;
  String? description;
  String? status;
  String? createdAt;

  ReportModel({
    this.id,
    this.session,
    this.reporterUser,
    this.reporterModerator,
    this.category,
    this.description,
    this.status,
    this.createdAt,
  });

  ReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    session = json['session'] != null
        ? ReportSession.fromJson(json['session'])
        : null;
    reporterUser = json['reporter_user'] != null
        ? ReporterUser.fromJson(json['reporter_user'])
        : null;
    reporterModerator = json['reporter_moderator'] != null
        ? ReporterModerator.fromJson(json['reporter_moderator'])
        : null;
    category = json['category'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
  }
}

class ReportSession {
  String? id;
  ReporterUser? host;
  String? channelName;
  String? title;
  String? category;
  String? thumbnail;
  bool? isPremium;
  int? entryFee;
  String? startTime;
  String? endTime;
  int? totalViews;
  int? totalComments;
  String? status;

  ReportSession({
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
    this.totalViews,
    this.totalComments,
    this.status,
  });

  ReportSession.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    host = json['host'] != null ? ReporterUser.fromJson(json['host']) : null;
    channelName = json['channel_name'];
    title = json['title'];
    category = json['category'];
    thumbnail = json['thumbnail'];
    isPremium = json['is_premium'];
    entryFee = json['entry_fee'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    totalViews = json['total_views'];
    totalComments = json['total_comments'];
    status = json['status'];
  }
}

class ReporterUser {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;
  int? shady;
  String? status; // ACTIVE, INACTIVE

  ReporterUser({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.profileImage,
    this.shady,
    this.status,
  });

  ReporterUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    profileImage = json['profile_image'];
    shady = json['shady'];
    status = json['status'];
  }
}

class ReporterModerator {
  String? id;
  String? fullName;
  String? email;
  String? username;

  ReporterModerator({this.id, this.fullName, this.email, this.username});

  ReporterModerator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    username = json['username'];
  }
}
