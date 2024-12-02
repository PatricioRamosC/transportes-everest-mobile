import 'package:flutter/material.dart';

class ViajeApi2 {
  String? message;
  int? errorCode;
  List<ViajePayload>? payload;

  ViajeApi2({this.message, this.errorCode, this.payload});

  ViajeApi2.fromJson(Map<String, dynamic> jsonText) {
    message = jsonText['message'];
    errorCode = jsonText['error_code'];
    if (jsonText['payload'] != null) {
      payload = List.empty(growable: true);
      jsonText['payload'].forEach((v) {
        debugPrint(v.toString());
        payload!.add(ViajePayload.fromJson(v));
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

class ViajePayload {
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
  User? conductor;
  List<Pasajero>? pasajeros;
  List<Ubicacion>? ubicaciones;

  ViajePayload(
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
      this.conductor,
      this.pasajeros,
      this.ubicaciones});

  ViajePayload.fromJson(Map<String, dynamic> json) {
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
    conductor =
        json['conductor'] != null ? User.fromJson(json['conductor']) : null;
    if (json['pasajeros'] != null) {
      pasajeros = List.empty(growable: true);
      json['pasajeros'].forEach((v) {
        pasajeros?.add(Pasajero.fromJson(v));
      });
    }
    if (json['ubicaciones'] != null) {
      ubicaciones = List.empty(growable: true);
      json['ubicaciones'].forEach((v) {
        ubicaciones?.add(Ubicacion.fromJson(v));
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
      'conductor': conductor?.toJson(),
      'pasajeros': pasajeros?.map((v) => v.toJson()).toList(),
      'ubicaciones': ubicaciones?.map((v) => v.toJson()).toList(),
    };
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? phone;
  String? createdAt;
  String? updatedAt;
  String? idNumber;

  User(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.phone,
      this.createdAt,
      this.updatedAt,
      this.idNumber});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    idNumber = json['id_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'phone': phone,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'id_number': idNumber,
    };
    return data;
  }
}

class Pasajero {
  int? id;
  int? viajeId;
  int? userId;
  int? ubicacionId;
  String? estado;
  String? createdAt;
  String? updatedAt;
  User? user;
  Ubicacion? ubicacion;

  Pasajero(
      {this.id,
      this.viajeId,
      this.userId,
      this.ubicacionId,
      this.estado,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.ubicacion});

  Pasajero.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    viajeId = json['viaje_id'];
    userId = json['user_id'];
    ubicacionId = json['ubicacion_id'];
    estado = json['estado'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    ubicacion = json['ubicacion'] != null
        ? Ubicacion.fromJson(json['ubicacion'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'viaje_id': viajeId,
      'user_id': userId,
      'ubicacion_id': ubicacionId,
      'estado': estado,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
      'ubicacion': ubicacion?.toJson(),
    };
    return data;
  }
}

/*
class Ubicacion {
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

  Ubicacion(
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
      this.updatedAt});

  Ubicacion.fromJson(Map<String, dynamic> json) {
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
    };
    return data;
  }
}
*/
class Ubicacion {
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
  Comuna? comuna;

  Ubicacion(
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
      this.comuna});

  Ubicacion.fromJson(Map<String, dynamic> json) {
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
    comuna = json['comuna'] != null ? Comuna.fromJson(json['comuna']) : null;
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
      'comuna': comuna?.toJson(),
    };
    return data;
  }
}

class Comuna {
  int? id;
  String? comuna;
  int? idRegion;
  String? createdAt;
  String? updatedAt;
  Region? region;

  Comuna(
      {this.id,
      this.comuna,
      this.idRegion,
      this.createdAt,
      this.updatedAt,
      this.region});

  Comuna.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comuna = json['comuna'];
    idRegion = json['id_region'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    region = json['region'] != null ? Region.fromJson(json['region']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'comuna': comuna,
      'id_region': idRegion,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'region': region?.toJson(),
    };
    return data;
  }
}

class Region {
  int? id;
  String? region;
  String? createdAt;
  String? updatedAt;

  Region({this.id, this.region, this.createdAt, this.updatedAt});

  Region.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    region = json['region'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'region': region,
      'created_at': createdAt,
      'updated_at': updatedAt
    };
    return data;
  }
}
