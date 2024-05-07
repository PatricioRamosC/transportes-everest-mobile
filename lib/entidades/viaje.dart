import 'dart:convert';

import 'usuario.dart';

class Viaje {
  int? id;
  int? idCliente;
  int? idConductor;
  String? fechaHoraSolicitud;
  String? fechaHoraInicio;
  String? fechaHoraFin;
  String? origenLatitud;
  String? origenLongitud;
  String? destinoLatitud;
  String? destinoLongitud;
  String? distancia;
  String? costoTotal;
  String? metodoPago;
  int? calificacionConductor;
  int? calificacionCliente;
  String? comentarios;
  String? direccion;
  String? numero;
  String? depto;
  String? referencia;
  int? idComuna;
  String? estado;
  DateTime? createdAt;
  DateTime? updatedAt;
  Usuario? conductor;
  Usuario? cliente;

  Viaje({
    this.id,
    this.idCliente,
    this.idConductor,
    this.fechaHoraSolicitud,
    this.fechaHoraInicio,
    this.fechaHoraFin,
    this.origenLatitud,
    this.origenLongitud,
    this.destinoLatitud,
    this.destinoLongitud,
    this.distancia,
    this.costoTotal,
    this.metodoPago,
    this.calificacionConductor,
    this.calificacionCliente,
    this.comentarios,
    this.direccion,
    this.numero,
    this.depto,
    this.referencia,
    this.idComuna,
    this.estado,
    this.createdAt,
    this.updatedAt,
    this.conductor,
    this.cliente,
  });

  @override
  String toString() {
    return 'Viajes(id: $id, idCliente: $idCliente, idConductor: $idConductor, fechaHoraSolicitud: $fechaHoraSolicitud, fechaHoraInicio: $fechaHoraInicio, fechaHoraFin: $fechaHoraFin, origenLatitud: $origenLatitud, origenLongitud: $origenLongitud, destinoLatitud: $destinoLatitud, destinoLongitud: $destinoLongitud, distancia: $distancia, costoTotal: $costoTotal, metodoPago: $metodoPago, calificacionConductor: $calificacionConductor, calificacionCliente: $calificacionCliente, comentarios: $comentarios, direccion: $direccion, numero: $numero, depto: $depto, referencia: $referencia, idComuna: $idComuna, estado: $estado, createdAt: $createdAt, updatedAt: $updatedAt, conductor: $conductor, cliente: $cliente)';
  }

  factory Viaje.fromMap(Map<String, dynamic> data) => Viaje(
        id: data['id'] as int?,
        idCliente: data['id_cliente'] as int?,
        idConductor: data['id_conductor'] as int?,
        fechaHoraSolicitud: data['fecha_hora_solicitud'] as String?,
        fechaHoraInicio: data['fecha_hora_inicio'] as String?,
        fechaHoraFin: data['fecha_hora_fin'] as String?,
        origenLatitud: data['origen_latitud'] as String?,
        origenLongitud: data['origen_longitud'] as String?,
        destinoLatitud: data['destino_latitud'] as String?,
        destinoLongitud: data['destino_longitud'] as String?,
        distancia: data['distancia'] as String?,
        costoTotal: data['costo_total'] as String?,
        metodoPago: data['metodo_pago'] as String?,
        calificacionConductor: data['calificacion_conductor'] as int?,
        calificacionCliente: data['calificacion_cliente'] as int?,
        comentarios: data['comentarios'] as String?,
        direccion: data['direccion'] as String?,
        numero: data['numero'] as String?,
        depto: data['depto'] as String?,
        referencia: data['referencia'] as String?,
        idComuna: data['id_comuna'] as int?,
        estado: data['estado'] as String?,
        createdAt: data['created_at'] == null
            ? null
            : DateTime.parse(data['created_at'] as String),
        updatedAt: data['updated_at'] == null
            ? null
            : DateTime.parse(data['updated_at'] as String),
        conductor: data['conductor'] == null
            ? null
            : Usuario.fromMap(data['conductor'] as Map<String, dynamic>),
        cliente: data['cliente'] == null
            ? null
            : Usuario.fromMap(data['cliente'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'id_cliente': idCliente,
        'id_conductor': idConductor,
        'fecha_hora_solicitud': fechaHoraSolicitud,
        'fecha_hora_inicio': fechaHoraInicio,
        'fecha_hora_fin': fechaHoraFin,
        'origen_latitud': origenLatitud,
        'origen_longitud': origenLongitud,
        'destino_latitud': destinoLatitud,
        'destino_longitud': destinoLongitud,
        'distancia': distancia,
        'costo_total': costoTotal,
        'metodo_pago': metodoPago,
        'calificacion_conductor': calificacionConductor,
        'calificacion_cliente': calificacionCliente,
        'comentarios': comentarios,
        'direccion': direccion,
        'numero': numero,
        'depto': depto,
        'referencia': referencia,
        'id_comuna': idComuna,
        'estado': estado,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'conductor': conductor?.toMap(),
        'cliente': cliente?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Viaje].
  factory Viaje.fromJson(String data) {
    return Viaje.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Viaje] to a JSON string.
  String toJson() => json.encode(toMap());

  Viaje copyWith({
    int? id,
    int? idCliente,
    int? idConductor,
    String? fechaHoraSolicitud,
    String? fechaHoraInicio,
    String? fechaHoraFin,
    String? origenLatitud,
    String? origenLongitud,
    String? destinoLatitud,
    String? destinoLongitud,
    String? distancia,
    String? costoTotal,
    String? metodoPago,
    int? calificacionConductor,
    int? calificacionCliente,
    String? comentarios,
    String? direccion,
    String? numero,
    String? depto,
    String? referencia,
    int? idComuna,
    String? estado,
    DateTime? createdAt,
    DateTime? updatedAt,
    Usuario? conductor,
    Usuario? cliente,
  }) {
    return Viaje(
      id: id ?? this.id,
      idCliente: idCliente ?? this.idCliente,
      idConductor: idConductor ?? this.idConductor,
      fechaHoraSolicitud: fechaHoraSolicitud ?? this.fechaHoraSolicitud,
      fechaHoraInicio: fechaHoraInicio ?? this.fechaHoraInicio,
      fechaHoraFin: fechaHoraFin ?? this.fechaHoraFin,
      origenLatitud: origenLatitud ?? this.origenLatitud,
      origenLongitud: origenLongitud ?? this.origenLongitud,
      destinoLatitud: destinoLatitud ?? this.destinoLatitud,
      destinoLongitud: destinoLongitud ?? this.destinoLongitud,
      distancia: distancia ?? this.distancia,
      costoTotal: costoTotal ?? this.costoTotal,
      metodoPago: metodoPago ?? this.metodoPago,
      calificacionConductor:
          calificacionConductor ?? this.calificacionConductor,
      calificacionCliente: calificacionCliente ?? this.calificacionCliente,
      comentarios: comentarios ?? this.comentarios,
      direccion: direccion ?? this.direccion,
      numero: numero ?? this.numero,
      depto: depto ?? this.depto,
      referencia: referencia ?? this.referencia,
      idComuna: idComuna ?? this.idComuna,
      estado: estado ?? this.estado,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      conductor: conductor ?? this.conductor,
      cliente: cliente ?? this.cliente,
    );
  }
}
