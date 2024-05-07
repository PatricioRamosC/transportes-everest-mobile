import 'dart:convert';

class Usuario {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? phone;
  DateTime? createdAt;
  DateTime? updatedAt;

  Usuario({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'Cliente(id: $id, name: $name, email: $email, emailVerifiedAt: $emailVerifiedAt, phone: $phone, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory Usuario.fromMap(Map<String, dynamic> data) => Usuario(
        id: data['id'] as int?,
        name: data['name'] as String?,
        email: data['email'] as String?,
        emailVerifiedAt: data['email_verified_at'] as dynamic,
        phone: data['phone'] as String?,
        createdAt: data['created_at'] == null
            ? null
            : DateTime.parse(data['created_at'] as String),
        updatedAt: data['updated_at'] == null
            ? null
            : DateTime.parse(data['updated_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'email_verified_at': emailVerifiedAt,
        'phone': phone,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Usuario].
  factory Usuario.fromJson(String data) {
    return Usuario.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Usuario] to a JSON string.
  String toJson() => json.encode(toMap());

  Usuario copyWith({
    int? id,
    String? name,
    String? email,
    dynamic emailVerifiedAt,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Usuario(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
