class LoginRequestModel {
  String? username;
  String? password;

  LoginRequestModel({this.username, this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}

class LoginResponseModel {
  String? status;
  String? message;
  String? accessToken;
  String? tokenType;
  LoginData? data;

  LoginResponseModel({
    this.status,
    this.message,
    this.accessToken,
    this.tokenType,
    this.data,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    accessToken = json['access_token']?.toString().trim();
    tokenType = json['token_type'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;

    // Support for different API formats:
    // If access_token is missing but data.token exists, use it.
    if (accessToken == null && data != null) {
      accessToken = data!.token?.trim();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData['status'] = status;
    jsonData['message'] = message;
    jsonData['access_token'] = accessToken;
    jsonData['token_type'] = tokenType;
    if (data != null) {
      jsonData['data'] = data!.toJson();
    }
    return jsonData;
  }
}

class LoginData {
  String? token;
  UserData? user;

  LoginData({this.token, this.user});

  LoginData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? name;
  String? email;
  String? role;
  String? avatar;

  UserData({this.id, this.name, this.email, this.role, this.avatar});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['avatar'] = avatar;
    return data;
  }
}
