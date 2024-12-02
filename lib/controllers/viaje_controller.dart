import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:transportes_everest_mobile/config/constants.dart';
import 'package:transportes_everest_mobile/controllers/base_controller.dart';
import 'package:transportes_everest_mobile/entidades/enlace_response.dart';
import 'package:transportes_everest_mobile/entidades/listado-revision-viajes/listado_revision_viajes.dart';
import 'package:transportes_everest_mobile/entidades/viaje_api2.dart';
import 'package:transportes_everest_mobile/entidades/viaje_mobile.dart';
import '../config/url.dart';
import '../entidades/enlace_request.dart';
import '../entidades/viaje.dart';

class ViajeController extends BaseController {
  ViajeController({required super.navigatorKey});
  ///
  /// Propósito: Viajes pendientes para ser atendidos por el conductor.
  ///
  Future<ViajeMobile?> obtenerViajesPendientes() async {
    return await obtenerViajes(Constants.pendiente);
  }

  ///
  /// Propósito: Viajes en proceso que ha sido atendido por el conductor.
  ///
  Future<ViajeMobile?> obtenerViajesEnProceso() async {
    return await obtenerViajes(Constants.enProceso);
  }

  ///
  /// Propósito: Viajes finalizador por el conductor, pero que no han sido firmado.
  ///
  Future<ViajeMobile?> obtenerViajesPorFirmar() async {
    return await obtenerViajes(Constants.terminado);
  }

  ///
  /// Propósito: Funcionalidad que permite obtener los viajes según el estado.
  ///
  Future<ViajeMobile?> obtenerViajes(String estado) async {
    try {
      int conductor = await apiService.getIntStorage("userID");
      Response? response = await apiService.get(
          "${UrlConstants.viajesConductorUrl}/$conductor/$estado", null);

      debug('obtenerViajes statusCode ${response?.statusCode}');
      if (response?.statusCode == 200) {
        try {
          return ViajeMobile.fromJson(response?.data);
        } catch (e, stackTrace) {
          debug(stackTrace.toString());
          debug(e.toString());
        }
      } else if (response?.statusCode == 204) {
        utils.toastInfo(Constants.mensajeNotFound);
      } else {
        utils.toastErrorJson(response?.data.toString() ?? '{}');
      }
    } catch (e, stackTrace) {
      debug(stackTrace.toString());
      utils.toastError(e.toString());
    }
    return ViajeMobile();
  }

  Future<ViajeApi2?> getViajes(String estado) async {
    try {
      int conductor = await apiService.getIntStorage("userID");
      Response? response = await apiService.get(
          "${UrlConstants.viajesConductorUrl}/$conductor/$estado", null);

      debug('obtenerViajes statusCode ${response?.statusCode}');
      if (response?.statusCode == 200) {
        try {
          return ViajeApi2.fromJson(response?.data);
        } catch (e, stackTrace) {
          debug(stackTrace.toString());
          debug(e.toString());
        }
      } else if (response?.statusCode == 204) {
        utils.toastInfo(Constants.mensajeNotFound);
      } else {
        utils.toastErrorJson(response?.data.toString() ?? '{}');
      }
    } catch (e, stackTrace) {
      debug(stackTrace.toString());
      utils.toastError(e.toString());
    }
    return ViajeApi2();
  }

  Future<ViajeApi2?> getViajesPendientes() async {
    return await getViajes(Constants.pendiente);
  }

  ///
  /// Propósito: Viajes en proceso que ha sido atendido por el conductor.
  ///
  Future<ViajeApi2?> getViajesEnProceso() async {
    return await getViajes(Constants.enProceso);
  }

  ///
  /// Propósito: Viajes finalizador por el conductor, pero que no han sido firmado.
  ///
  Future<ViajeApi2?> getViajesPorFirmar() async {
    return await getViajes(Constants.terminado);
  }

  ///
  /// Propósito: Actualizar estado del viaje.
  ///
  Future<bool?> updateStatus(Viaje item) async {
    try {
      Response? response = await apiService.sendRequest(
          method: 'PUT',
          endpoint: "${UrlConstants.viajesUrl}/${item.id}",
          params: item.toJson());

      if (response?.statusCode == 200) {
        debug(response!.data);
        Map<String, dynamic> json = jsonDecode(response.data);
        if (json.containsKey("payload")) {
          debug(json['payload'].toString());
          // debug(Viaje.fromJson(json['payload']));
        }
        return true;
      } else {
        utils.toastErrorJson(response?.data ?? '');
      }
    } catch (e) {
      debug(e.toString());
      utils.toastError(e.toString());
    }
    return false;
  }

  ///
  /// Propósito: Actualizar estado del viaje.
  ///
  Future<bool?> updateTravelStatus(ViajePayload item) async {
    try {
      Response? response = await apiService.put(
          "${UrlConstants.viajesUrl}/${item.id}", item.toJson(), null);

      if (response?.statusCode == 200) {
        Map<String, dynamic> json = response?.data;
        if (json.containsKey("payload")) {
          debug(json['payload'].toString());
          // debug(Viaje.fromJson(json['payload']));
        }
        return true;
      } else {
        utils.toastErrorJson(response?.data ?? '');
      }
    } catch (e, stackTrace) {
      debug("StackTrace: $stackTrace");
      debug(e.toString());
      utils.toastError(e.toString());
    }
    return false;
  }

  ///
  /// Propósito: Actualizar estado del viaje.
  ///
  Future<RevisionViajesPayload?> updateStatusPassanger(int id) async {
    try {
      Response? response = await apiService.put(
          "${UrlConstants.viajesPasajeroUrl}/$id", null, null);

      if (response?.statusCode == 200) {
          return RevisionViajesPayload.fromJson(response?.data);
      } else {
        utils.toastErrorJson(response?.data ?? '');
      }
    } catch (e) {
      debug(e.toString());
      utils.toastError(e.toString());
    }
    return null;
  }

  ///
  /// Propósito: Actualizar estado del viaje.
  ///
  Future<RevisionViajesPayload?> updateStatusLocation(int id) async {
    try {
      Response? response = await apiService.put(
          "${UrlConstants.viajesUbicacionUrl}/$id", null, null);

      if (response?.statusCode == 200) {
          return RevisionViajesPayload.fromJson(response?.data);
      } else {
        utils.toastErrorJson(response?.data ?? '');
      }
    } catch (e) {
      debugPrint(e.toString());
      utils.toastError(e.toString());
    }
    return null;
  }

  Future<bool?> createLink(EnlaceRequest item) async {
    try {
      Response? response = await apiService.post(
          UrlConstants.enlaceUrl, item.toJson(), null);

      if (response?.statusCode == 200) {
        debugPrint('DEBUG: recibiendo el response del createLink...');
        debugPrint(jsonEncode(response!.data));
        debugPrint('DEBUG: response del createLink recibido.');
        if (response.data.containsKey("payload")) {
          String phone;
          EnlaceResponse enlaceResponse = EnlaceResponse.fromMap(response.data['payload']);
          phone = utils.phoneFormatted(enlaceResponse.phone ?? '');
          utils.toastInfo(enlaceResponse.message ?? '');
          utils.send(phone, enlaceResponse.messageUser ?? '');
          return true;
        }
      } else {
        debugPrint(jsonEncode(response));
        debugPrint(response?.statusCode.toString());
        utils.toastErrorJson(jsonEncode(response?.data ?? ''));
      }
    } catch (e, stackTrace) {
      debugPrint('DEBUG: createLink');
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      utils.toastError(e.toString());
    }
    return false;
  }

/*   Ubicacion? getUbicacion(Viaje item, String tipo) {
    return item.ubicaciones?.firstWhere((element) => element.tipo == tipo,
        orElse: () => Ubicacion());
  }
 */
  Ubicacion? getLocation(ViajePayload item, String tipo) {
    return item.ubicaciones?.firstWhere((element) => element.tipo == tipo,
        orElse: () => Ubicacion());
  }

  Pasajero getPasajeroRetirar(ViajePayload item) {
    return item.pasajeros
            ?.firstWhere((x) => x.estado == "P", orElse: () => Pasajero()) ??
        Pasajero();
  }

  Future<ListadoRevisionViajes?> getViajesV2() async {
    try {
      int conductor = await apiService.getIntStorage("userID");
      Response? response = await apiService.get(
          "${UrlConstants.viajesV2Url}/$conductor", null);

      debug('obtenerViajes statusCode ${response?.statusCode}');
      if (response?.statusCode == 200) {
        try {
          return ListadoRevisionViajes.fromJson(response?.data);
        } catch (e, stackTrace) {
          debug(stackTrace.toString());
          debug(e.toString());
        }
      } else if (response?.statusCode == 204) {
        utils.toastInfo(Constants.mensajeNotFound);
      } else {
        utils.toastErrorJson(response?.data.toString() ?? '{}');
      }
    } catch (e, stackTrace) {
      debug(stackTrace.toString());
      utils.toastError(e.toString());
    }
    return ListadoRevisionViajes();
  }



}
