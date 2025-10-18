import 'dart:convert';

class Usuario {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? phone;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? idNumber;
  int? userId;
  int? convenioId;
  Movil? movil;

  Usuario(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.phone,
      this.createdAt,
      this.updatedAt,
      this.idNumber,
      this.userId,
      this.convenioId,
      this.movil});

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
      idNumber: data['id_number'],
      userId: data['user_id'],
      convenioId: data['convenio_id'],
      movil: data['movil'] != null ? Movil.fromMap(data['movil']) : null);

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'email_verified_at': emailVerifiedAt,
        'phone': phone,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'id_number': idNumber,
        'user_id': userId,
        'convenio_id': convenioId,
        'movil': movil?.toMap()
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

class Movil {
  int? id;
  String? cdgMovil;
  String? tipoVehiculo;
  String? patente;
  String? marca;
  String? modelo;
  String? color;
  double? comision;
  int? conductorId;
  String? createdAt;
  String? updatedAt;

  Movil(
      {this.id,
      this.cdgMovil,
      this.tipoVehiculo,
      this.patente,
      this.marca,
      this.modelo,
      this.color,
      this.comision,
      this.conductorId,
      this.createdAt,
      this.updatedAt});

  factory Movil.fromMap(Map<String, dynamic> data) => Movil(
        id: data['id'] as int?,
        cdgMovil: data['cdg_movil'] as String?,
        tipoVehiculo: data['tipo_vehiculo'] as String?,
        patente: data['patente'] as String?,
        marca: data['marca'] as String?,
        modelo: data['modelo'] as String?,
        color: data['color'] as String?,
        comision: (data['comision'] as num?)?.toDouble(),
        conductorId: data['conductor_id'] as int?,
        createdAt: data['created_at'] as String?,
        updatedAt: data['updated_at'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'cdg_movil': cdgMovil,
        'tipo_vehiculo': tipoVehiculo,
        'patente': patente,
        'marca': marca,
        'modelo': modelo,
        'color': color,
        'comision': comision,
        'conductor_id': conductorId,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  factory Movil.fromJson(String data) {
    return Movil.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  Movil copyWith({
    int? id,
    String? cdgMovil,
    String? tipoVehiculo,
    String? patente,
    String? marca,
    String? modelo,
    String? color,
    double? comision,
    int? conductorId,
    String? createdAt,
    String? updatedAt,
  }) {
    return Movil(
      id: id ?? this.id,
      cdgMovil: cdgMovil ?? this.cdgMovil,
      tipoVehiculo: tipoVehiculo ?? this.tipoVehiculo,
      patente: patente ?? this.patente,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      color: color ?? this.color,
      comision: comision ?? this.comision,
      conductorId: conductorId ?? this.conductorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
