import 'dart:convert';

import 'comuna.dart';

class Ubicacion {
  int? id;
  int? idViaje;
  String? direccion;
  String? numero;
  String? depto;
  String? referencia;
  String? tipo;
  int? idComuna;
  dynamic createdAt;
  dynamic updatedAt;
  Comuna? comuna;

  Ubicacion({
    this.id,
    this.idViaje,
    this.direccion,
    this.numero,
    this.depto,
    this.referencia,
    this.tipo,
    this.idComuna,
    this.createdAt,
    this.updatedAt,
    this.comuna,
  });

  @override
  String toString() {
    return 'Ubicacione(id: $id, idViaje: $idViaje, direccion: $direccion, numero: $numero, depto: $depto, referencia: $referencia, tipo: $tipo, idComuna: $idComuna, createdAt: $createdAt, updatedAt: $updatedAt, comuna: $comuna)';
  }

  factory Ubicacion.fromMap(Map<String, dynamic> data) => Ubicacion(
        id: data['id'] as int?,
        idViaje: data['id_viaje'] as int?,
        direccion: data['direccion'] as String?,
        numero: data['numero'] as String?,
        depto: data['depto'] as String?,
        referencia: data['referencia'] as String?,
        tipo: data['tipo'] as String?,
        idComuna: data['id_comuna'] as int?,
        createdAt: data['created_at'] as dynamic,
        updatedAt: data['updated_at'] as dynamic,
        comuna: data['comuna'] == null
            ? null
            : Comuna.fromMap(data['comuna'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'id_viaje': idViaje,
        'direccion': direccion,
        'numero': numero,
        'depto': depto,
        'referencia': referencia,
        'tipo': tipo,
        'id_comuna': idComuna,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'comuna': comuna?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Ubicacion.
  factory Ubicacion.fromJson(String data) {
    return Ubicacion.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Ubicacion to a JSON string.
  String toJson() => json.encode(toMap());

  Ubicacion copyWith({
    int? id,
    int? idViaje,
    String? direccion,
    String? numero,
    String? depto,
    String? referencia,
    String? tipo,
    int? idComuna,
    dynamic createdAt,
    dynamic updatedAt,
    Comuna? comuna,
  }) {
    return Ubicacion(
      id: id ?? this.id,
      idViaje: idViaje ?? this.idViaje,
      direccion: direccion ?? this.direccion,
      numero: numero ?? this.numero,
      depto: depto ?? this.depto,
      referencia: referencia ?? this.referencia,
      tipo: tipo ?? this.tipo,
      idComuna: idComuna ?? this.idComuna,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      comuna: comuna ?? this.comuna,
    );
  }
}
