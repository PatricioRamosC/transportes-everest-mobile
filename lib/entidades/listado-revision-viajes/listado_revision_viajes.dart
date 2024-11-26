import 'dart:convert';

import '../usuario.dart';
import '../ubicacion.dart';
import '../comuna.dart';
import '../region.dart';


class ListadoRevisionViajes {
  String message;
  int errorCode;
  List<RevisionViajesPayload> payload;

  ListadoRevisionViajes({this.message, this.errorCode, this.payload});

  ListadoRevisionViajes.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    errorCode = json['error_code'];
    if (json['payload'] != null) {
      payload = new List<RevisionViajesPayload>();
      json['payload'].forEach((v) {
        payload.add(new RevisionViajesPayload.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['error_code'] = this.errorCode;
    if (this.payload != null) {
      data['payload'] = this.payload.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RevisionViajesPayload {
  int id;
  int idConductor;
  String fechaHoraSolicitud;
  String fechaHoraInicio;
  String fechaHoraFin;
  String origenLatitud;
  String origenLongitud;
  String destinoLatitud;
  String destinoLongitud;
  String distancia;
  String costoTotal;
  String metodoPago;
  int calificacionConductor;
  int calificacionCliente;
  String comentarios;
  String createdAt;
  String updatedAt;
  String estado;
  String tipoConvenio;
  String centroCosto;
  int convenioId;
  int tarifa;
  Usuario conductor;
  List<Ubicacion> ubicaciones;

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
      this.ubicaciones});

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
    conductor = json['conductor'] != null
        ? new Usuario.fromJson(json['conductor'])
        : null;
    if (json['ubicaciones'] != null) {
      ubicaciones = new List<Ubicacion>();
      json['ubicaciones'].forEach((v) {
        ubicaciones.add(new Ubicacion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_conductor'] = this.idConductor;
    data['fecha_hora_solicitud'] = this.fechaHoraSolicitud;
    data['fecha_hora_inicio'] = this.fechaHoraInicio;
    data['fecha_hora_fin'] = this.fechaHoraFin;
    data['origen_latitud'] = this.origenLatitud;
    data['origen_longitud'] = this.origenLongitud;
    data['destino_latitud'] = this.destinoLatitud;
    data['destino_longitud'] = this.destinoLongitud;
    data['distancia'] = this.distancia;
    data['costo_total'] = this.costoTotal;
    data['metodo_pago'] = this.metodoPago;
    data['calificacion_conductor'] = this.calificacionConductor;
    data['calificacion_cliente'] = this.calificacionCliente;
    data['comentarios'] = this.comentarios;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['estado'] = this.estado;
    data['tipo_convenio'] = this.tipoConvenio;
    data['centro_costo'] = this.centroCosto;
    data['convenio_id'] = this.convenioId;
    data['tarifa'] = this.tarifa;
    if (this.conductor != null) {
      data['conductor'] = this.conductor.toJson();
    }
    if (this.ubicaciones != null) {
      data['ubicaciones'] = this.ubicaciones.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Ubicaciones {
  int id;
  int idViaje;
  String direccion;
  String referencia;
  String tipo;
  int idComuna;
  String latitud;
  String longitud;
  int orden;
  String createdAt;
  String updatedAt;
  String estado;
  List<Usuario> pasajeros;
  Comuna comuna;

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
      this.comuna});

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
      pasajeros = new List<Usuario>();
      json['pasajeros'].forEach((v) {
        pasajeros.add(new Usuario.fromJson(v));
      });
    }
    comuna =
        json['comuna'] != null ? new Comuna.fromJson(json['comuna']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_viaje'] = this.idViaje;
    data['direccion'] = this.direccion;
    data['referencia'] = this.referencia;
    data['tipo'] = this.tipo;
    data['id_comuna'] = this.idComuna;
    data['latitud'] = this.latitud;
    data['longitud'] = this.longitud;
    data['orden'] = this.orden;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['estado'] = this.estado;
    if (this.pasajeros != null) {
      data['pasajeros'] = this.pasajeros.map((v) => v.toJson()).toList();
    }
    if (this.comuna != null) {
      data['comuna'] = this.comuna.toJson();
    }
    return data;
  }
}

