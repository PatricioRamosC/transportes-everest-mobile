// import 'dart:convert';

import 'package:flutter/material.dart';

import '../usuario.dart';
import '../comuna.dart';
// import '../region.dart';

class ListadoRevisionViajes {
  String? message;
  int? errorCode;
  List<RevisionViajesPayload>? payload;

  ListadoRevisionViajes({this.message, this.errorCode, this.payload});

  ListadoRevisionViajes.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    errorCode = json['error_code'];
    if (json['payload'] != null) {
      payload = List.empty(growable: true);
      json['payload'].forEach((v) {
        debugPrint(v.toString());
        payload!.add(RevisionViajesPayload.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'message': message,
      'error_code': errorCode,
      'payload': payload?.map((v) => v.toJson()).toList()
    };
    return data;
  }
}

class RevisionViajesPayload {
  int? id;
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
  String? createdAt;
  String? updatedAt;
  String? estado;
  String? tipoConvenio;
  String? centroCosto;
  int? convenioId;
  int? tarifa;
  Usuario? conductor;
  List<Ubicaciones>? ubicaciones;
  Convenio? convenio;
  MedioPago? medioPago;

  RevisionViajesPayload(
      {this.id,
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
      this.createdAt,
      this.updatedAt,
      this.estado,
      this.tipoConvenio,
      this.centroCosto,
      this.convenioId,
      this.tarifa,
      this.conductor,
      this.ubicaciones,
      this.convenio,
      this.medioPago});

  RevisionViajesPayload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idConductor = json['id_conductor'];
    fechaHoraSolicitud = json['fecha_hora_solicitud'];
    fechaHoraInicio = json['fecha_hora_inicio'];
    fechaHoraFin = json['fecha_hora_fin'];
    origenLatitud = json['origen_latitud'];
    origenLongitud = json['origen_longitud'];
    destinoLatitud = json['destino_latitud'];
    destinoLongitud = json['destino_longitud'];
    distancia = json['distancia'];
    costoTotal = json['costo_total'];
    metodoPago = json['metodo_pago'];
    calificacionConductor = json['calificacion_conductor'];
    calificacionCliente = json['calificacion_cliente'];
    comentarios = json['comentarios'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    estado = json['estado'];
    tipoConvenio = json['tipo_convenio'];
    centroCosto = json['centro_costo'];
    convenioId = json['convenio_id'];
    tarifa = json['tarifa'];
    conductor =
        json['conductor'] != null ? Usuario.fromMap(json['conductor']) : null;
    convenio =
        json['convenio'] != null ? Convenio.fromJson(json['convenio']) : null;
    medioPago = json['medio_pago'] != null
        ? MedioPago.fromJson(json['medio_pago'])
        : null;
    if (json['ubicaciones'] != null) {
      ubicaciones = List.empty(growable: true);
      json['ubicaciones'].forEach((v) {
        ubicaciones?.add(Ubicaciones.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
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
      'created_at': createdAt,
      'updated_at': updatedAt,
      'estado': estado,
      'tipo_convenio': tipoConvenio,
      'centro_costo': centroCosto,
      'convenio_id': convenioId,
      'tarifa': tarifa,
      'conductor': conductor?.toMap(),
      'ubicaciones': ubicaciones?.map((v) => v.toJson()).toList(),
      'convenio': convenio?.toJson(),
      'medio_pago': medioPago?.toJson(),
    };
    return data;
  }
}

class Ubicaciones {
  int? id;
  int? idViaje;
  String? direccion;
  String? referencia;
  String? tipo;
  int? idComuna;
  String? latitud;
  String? longitud;
  int? orden;
  String? createdAt;
  String? updatedAt;
  String? estado;
  List<Pasajeros>? pasajeros;
  Comuna? comuna;
  List<Espera>? esperas;

  Ubicaciones(
      {this.id,
      this.idViaje,
      this.direccion,
      this.referencia,
      this.tipo,
      this.idComuna,
      this.latitud,
      this.longitud,
      this.orden,
      this.createdAt,
      this.updatedAt,
      this.estado,
      this.pasajeros,
      this.comuna,
      this.esperas});

  Ubicaciones.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idViaje = json['id_viaje'];
    direccion = json['direccion'];
    referencia = json['referencia'];
    tipo = json['tipo'];
    idComuna = json['id_comuna'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    orden = json['orden'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    estado = json['estado'];
    if (json['pasajeros'] != null) {
      pasajeros = List.empty(growable: true);
      json['pasajeros'].forEach((v) {
        pasajeros?.add(Pasajeros.fromJson(v));
      });
    }
    comuna = json['comuna'] != null ? Comuna.fromMap(json['comuna']) : null;
    if (json['esperas'] != null) {
      esperas = List.empty(growable: true);
      json['esperas'].forEach((v) {
        esperas?.add(Espera.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'id_viaje': idViaje,
      'direccion': direccion,
      'referencia': referencia,
      'tipo': tipo,
      'id_comuna': idComuna,
      'latitud': latitud,
      'longitud': longitud,
      'orden': orden,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'estado': estado,
      'pasajeros': pasajeros?.map((v) => v.toJson()).toList(),
      'comuna': comuna?.toJson(),
      'esperas': esperas?.map((v) => v.toJson()).toList(),
    };
    return data;
  }
}

class Pasajeros {
  int? id;
  int? viajeId;
  int? userId;
  int? ubicacionId;
  String? estado;
  String? createdAt;
  String? updatedAt;
  String? accion;
  Usuario? user;

  Pasajeros(
      {this.id,
      this.viajeId,
      this.userId,
      this.ubicacionId,
      this.estado,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.accion});

  Pasajeros.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    viajeId = json['id_viaje'];
    userId = json['user_id'];
    ubicacionId = json['ubicacion_id'];
    estado = json['estado'];
    accion = json['accion'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? Usuario.fromMap(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'id_viaje': viajeId,
      'user_id': userId,
      'ubicacion_id': ubicacionId,
      'estado': estado,
      'accion': accion,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson()
    };
    return data;
  }
}

class Espera {
  int? id;
  int? ubicacionId;
  String? inicio;
  String? fin;
  String? createdAt;
  String? updatedAt;
  double? latitud;
  double? longitud;

  Espera({
    this.id,
    this.ubicacionId,
    this.inicio,
    this.fin,
    this.createdAt,
    this.updatedAt,
    this.latitud,
    this.longitud,
  });

  Espera.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ubicacionId = json['ubicacion_id'];
    inicio = json['inicio'];
    fin = json['fin'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    latitud = (json['latitud'] != null) ? json['latitud'].toDouble() : null;
    longitud = (json['longitud'] != null) ? json['longitud'].toDouble() : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ubicacion_id': ubicacionId,
      'inicio': inicio,
      'fin': fin,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'latitud': latitud,
      'longitud': longitud,
    };
  }
}

class Convenio {
  int? id;
  String? convenio;
  String? razonSocial;
  String? rut;
  int? administradorId;
  int? cicloFacturacion;
  int? diaFacturacion;
  int? plazoPago;
  String? createdAt;
  String? updatedAt;

  Convenio({
    this.id,
    this.convenio,
    this.razonSocial,
    this.rut,
    this.administradorId,
    this.cicloFacturacion,
    this.diaFacturacion,
    this.plazoPago,
    this.createdAt,
    this.updatedAt,
  });

  Convenio.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    convenio = json['convenio'];
    razonSocial =
        json['razon_social']; // ← Corregido de 'razonSocial' a 'razon_social'
    rut = json['rut'];
    administradorId = json['administrador_id'];
    cicloFacturacion = json['ciclo_facturacion'];
    diaFacturacion = json['dia_facturacion'];
    plazoPago = json['plazo_pago'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'convenio': convenio,
      'razon_social': razonSocial, // ← Corregido para coincidir con el JSON
      'rut': rut,
      'administrador_id': administradorId,
      'ciclo_facturacion': cicloFacturacion,
      'dia_facturacion': diaFacturacion,
      'plazo_pago': plazoPago,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
    return data;
  }
}

class MedioPago {
  int? id;
  String? medioPago;
  String? createdAt;
  String? updatedAt;

  MedioPago({
    this.id,
    this.medioPago,
    this.createdAt,
    this.updatedAt,
  });

  MedioPago.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    medioPago = json['medio_pago'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'medio_pago': medioPago,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
    return data;
  }
}
