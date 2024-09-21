class LoginPayload {
  String? tokenType;
  String? accessToken;
  String? refreshToken;
  int? userId;
  String? clientId;
  String? createdAt;
  String? updatedAt;
  String? expiresAt;

  LoginPayload(
      {this.tokenType,
      this.accessToken,
      this.refreshToken,
      this.userId,
      this.clientId,
      this.createdAt,
      this.updatedAt,
      this.expiresAt});

  LoginPayload.fromJson(Map<String, dynamic> json) {
    tokenType = json['token_type'];
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    userId = json['user_id'];
    clientId = json['client_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    expiresAt = json['expires_at'];
  }
}

class Login {
  String? message;
  int? errorCode;
  LoginPayload? payload;

  Login.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    errorCode = json['error_code'];
    payload = json['payload'] != null
        ? LoginPayload?.fromJson(json['payload'])
        : null;
  }
}
