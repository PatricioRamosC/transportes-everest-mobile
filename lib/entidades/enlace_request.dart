import 'dart:convert';

class EnlaceRequest {
  int? idViaje;
  String? tipo;
  String? estado;

  EnlaceRequest({this.idViaje, this.tipo, this.estado});

  @override
  String toString() {
    return 'EnlaceRequest(idViaje: $idViaje, tipo: $tipo, estado: $estado)';
  }

  factory EnlaceRequest.fromMap(Map<String, dynamic> data) => EnlaceRequest(
        idViaje: data['id_viaje'] as int?,
        tipo: data['tipo'] as String?,
        estado: data['estado'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id_viaje': idViaje,
        'tipo': tipo,
        'estado': estado,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EnlaceRequest].
  factory EnlaceRequest.fromJson(String data) {
    return EnlaceRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [EnlaceRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  EnlaceRequest copyWith({
    int? idViaje,
    String? tipo,
    String? estado,
  }) {
    return EnlaceRequest(
      idViaje: idViaje ?? this.idViaje,
      tipo: tipo ?? this.tipo,
      estado: estado ?? this.estado,
    );
  }
}
