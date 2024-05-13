import 'dart:convert';

class EnlaceResponse {
  String? message;
  String? messageUser;
  String? phone;

  EnlaceResponse({this.message, this.messageUser, this.phone});

  @override
  String toString() {
    return 'EnlaceResponse(message: $message, messageUser: $messageUser, phone: $phone)';
  }

  factory EnlaceResponse.fromMap(Map<String, dynamic> data) {
    return EnlaceResponse(
        message: data['message'] as String?,
        messageUser: data['message_user'] as String?,
        phone: data['phone'] as String?);
  }

  Map<String, dynamic> toMap() =>
      {'message': message, 'message_user': messageUser, 'phone': phone};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EnlaceResponse].
  factory EnlaceResponse.fromJson(String data) {
    return EnlaceResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [EnlaceResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  EnlaceResponse copyWith(
      {String? message, String? messageUser, String? phone}) {
    return EnlaceResponse(
        message: message ?? this.message,
        messageUser: messageUser ?? this.messageUser,
        phone: messageUser ?? this.phone);
  }
}
