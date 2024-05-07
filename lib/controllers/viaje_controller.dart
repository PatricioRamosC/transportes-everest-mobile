import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transportes_everest_mobile/config/constants.dart';
import 'package:transportes_everest_mobile/controllers/base_controller.dart';
import '../config/url.dart';
import '../entidades/viaje.dart';
import '../entidades/viajes_pendientes/viajes_pendientes.dart';

class ViajeController extends BaseController {
  ///
  /// Propósito: Viajes pendientes para ser atendidos por el conductor.
  ///
  Future<ViajesPendientes?> obtenerViajesPendientes() async {
    return await obtenerViajes(Constants.pendiente);
  }

  ///
  /// Propósito: Viajes en proceso que ha sido atendido por el conductor.
  ///
  Future<ViajesPendientes?> obtenerViajesEnProceso() async {
    return await obtenerViajes(Constants.enProceso);
  }

  ///
  /// Propósito: Viajes finalizador por el conductor, pero que no han sido firmado.
  ///
  Future<ViajesPendientes?> obtenerViajesPorFirmar() async {
    return await obtenerViajes(Constants.terminado);
  }

  ///
  /// Propósito: Funcionalidad que permite obtener los viajes según el estado.
  ///
  Future<ViajesPendientes?> obtenerViajes(String estado) async {
    try {
      int conductor = await utils.getInteger("idConductor") ?? 1;
      conductor = 1;
      http.Response? response = await apiService.sendRequest(
          method: 'GET',
          endpoint: "${UrlConstants.viajesConductorUrl}/$conductor/$estado");

      if (response?.statusCode == 200) {
        debug(response!.body);
        Map<String, dynamic> json = jsonDecode(response.body);
        debug(json['payload'].toString());
        debug(ViajesPendientes.fromJson(response.body).toString());
        return ViajesPendientes.fromJson(response.body);
      } else if (response?.statusCode == 204) {
        utils.toastInfo(Constants.mensajeNotFound);
      } else {
        utils.toastErrorJson(response?.body ?? '');
      }
    } catch (e) {
      utils.toastError(e.toString());
    }
    return null;
  }

  ///
  /// Propósito: Actualizar estado del viaje.
  ///
  Future<bool?> updateStatus(Viaje item) async {
    try {
      http.Response? response = await apiService.sendRequest(
          method: 'PUT', endpoint: UrlConstants.viajesUrl, params: item);

      if (response?.statusCode == 200) {
        debug(response!.body);
        Map<String, dynamic> json = jsonDecode(response.body);
        debug(ViajesPendientes.fromJson(response.body).toString());
        if (json.containsKey("payload")) {
          debug(json['payload'].toString());
        }
        return true;
      } else {
        utils.toastErrorJson(response?.body ?? '');
      }
    } catch (e) {
      utils.toastError(e.toString());
    }
    return false;
  }

  Future<bool?> createLink(Viaje item) async {
    try {
      http.Response? response = await apiService.sendRequest(
          method: 'POST', endpoint: UrlConstants.enlaceUrl, params: item);

      if (response?.statusCode == 200) {
        debug(response!.body);
        Map<String, dynamic> json = jsonDecode(response.body);
        debug(ViajesPendientes.fromJson(response.body).toString());
        if (json.containsKey("payload")) {
          debug(json['payload'].toString());
        }
        return true;
      } else {
        utils.toastErrorJson(response?.body ?? '');
      }
    } catch (e) {
      utils.toastError(e.toString());
    }
    return false;
  }
}
