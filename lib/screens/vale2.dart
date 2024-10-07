import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:transportes_everest_mobile/config/constants.dart';
import 'package:transportes_everest_mobile/controllers/viaje_controller.dart';
import 'package:transportes_everest_mobile/entidades/viaje.dart';
import 'package:transportes_everest_mobile/entidades/viaje_api2.dart';
import 'package:transportes_everest_mobile/entidades/viajes_pendientes/viajes_pendientes.dart';
import '../entidades/enlace_request.dart';

class Vale2 extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const Vale2({super.key, required this.navigatorKey});

  @override
  State<Vale2> createState() => _Vale2State();
}

class _Vale2State extends State<Vale2> with WidgetsBindingObserver {
  late ViajeController viajeController;
  ViajeApi2 viajesPendientes = ViajeApi2();
  ViajeApi2 viajesEnCurso = ViajeApi2();
  ViajeApi2 viajesPorFirmar = ViajeApi2();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    viajeController = ViajeController(navigatorKey: widget.navigatorKey);
    debug('Inicio State');
    cargarInformacion();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // La app fue enviada al segundo plano
      // Guarda el estado si es necesario
    } else if (state == AppLifecycleState.resumed) {
      // La app volvió al primer plano
      // Restablece el estado si es necesario
    }
  }

  void debug(String msg) {
    debugPrint('DEBUG: $msg');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: const TabBar(
            tabs: [
              Tab(text: 'Pendiente'),
              Tab(text: 'En curso'),
              Tab(text: 'Por firmar')
            ],
          ),
          body: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : TabBarView(children: [
                    getViajes(viajesPendientes, Constants.pendiente),
                    getViajes(viajesEnCurso, Constants.enProceso),
                    getViajes(viajesPorFirmar, Constants.finalizado)
                  ]),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              cargarInformacion();
            },
            child: const Icon(Icons.refresh),
          ),
        ),
      ),
    );
  }

  Viaje getViaje(ViajesPendientes? item, int index) {
    Viaje viaje = Viaje();
    try {
      print("Listando getViaje [$index]....");
      List<Viaje> lista = item?.payload ?? List.empty();
      if (lista.isNotEmpty && lista.length > index) {
        viaje = (lista[index]);
      }
      print("Viajes listados [$index].");
    } on Exception catch (_) {
      debugPrint(_.toString());
    }
    return viaje;
  }

  Expanded getTexto(ViajePayload item, bool pendiente) {
    Ubicacion origen =
        viajeController.getLocation(item, Constants.ubicacionOrigen) ??
            Ubicacion();
    Ubicacion destino =
        viajeController.getLocation(item, Constants.ubicacionDestino) ??
            Ubicacion();
    Pasajero pasajero = viajeController.getPasajeroRetirar(item);
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          "Pasajero: ${pasajero.user?.name ?? ''}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1.0,
        ),
        const Text(
          Constants.textoUbicacionOrigen,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        getDireccion(origen),
        ElevatedButton(
          style: const ButtonStyle(
              shape: WidgetStatePropertyAll(BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))))),
          onPressed: () {
            viajeController.utils.openPhoneCall(viajeController.utils
                .phoneFormatted(pasajero.user?.phone ?? ''));
          },
          child: Text(
            viajeController.utils.phoneFormatted(pasajero.user?.phone ?? ''),
            style: const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
                fontSize: 14.0),
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1.0,
        ),
        const Text(
          Constants.textoUbicacionDestino,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        getDireccion(destino),
        const SizedBox(height: 10.0),
        ElevatedButton(
          style: const ButtonStyle(
              shape: WidgetStatePropertyAll(BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))))),
          onPressed: () {
            if (pendiente) {
              item.estado = 'EP';
            } else {
              item.estado = 'T';
            }
            viajeController.updateTravelStatus(item);
            cargarInformacion();
          },
          child: const Expanded(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Icon(Icons.time_to_leave),
              SizedBox(
                width: 10.0,
              ),
              Text('Iniciar')
            ]),
          ),
        ),
      ]),
    );
  }

  Row getDireccion(Ubicacion ubicacion) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  ubicacion.direccion ?? '',
                  style: const TextStyle(fontSize: 14.0),
                ),
                Text(ubicacion.comuna?.comuna ?? '',
                    style: const TextStyle(fontSize: 14.0))
              ],
            )),
        const SizedBox(width: 15.0),
        Expanded(
            flex: 1,
            child: Column(
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                      shape: WidgetStatePropertyAll(BeveledRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(5.0))))),
                  onPressed: () async {
                    if (!(await viajeController.utils.openWaze(
                            ubicacion.latitud ?? '',
                            ubicacion.longitud ?? '') ??
                        false)) {
                      viajeController.utils.openMaps(
                          ubicacion.direccion ?? '',
                          "",
                          ubicacion.comuna?.comuna ?? '',
                          ubicacion.comuna?.region?.region ?? '');
                    }
                  },
                  child: const Icon(Icons.copy),
                ),
              ],
            ))
      ],
    );
  }

  ListView getViajes(ViajeApi2 viajes, String estado) {
    return ListView.builder(
      itemCount: viajes.payload?.length ?? 0,
      itemBuilder: (context, index) {
        try {
          return ListTile(
              title: Card(
            color:
                index % 2 == 0 ? Colors.indigo.shade50 : Colors.indigo.shade100,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  getTexto(
                      viajes.payload![index], (estado == Constants.pendiente)),
                ],
              ),
            ),
          ));
        } catch (e, stackTrace) {
          debug("Error en el itemBuilder: $e");
          debug("StackTrace: $stackTrace");
          return ListTile(
            title: Card(
              color: Colors.red.shade100,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Error al cargar este elemento",
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  ///
  /// Propósito: Cambia el estado del viaje según las acciones que define el conductor.
  ///
  Future<bool?> setEstado(ViajePayload item, String estado) async {
    try {
      item.estado = estado;
      LocationData? location = await viajeController.utils.getLocation();
      if (location != null) {
        if (estado == Constants.enProceso) {
          item.origenLatitud = location.latitude.toString();
          item.origenLongitud = location.longitude.toString();
        } else {
          item.destinoLatitud = location.latitude.toString();
          item.destinoLongitud = location.longitude.toString();
        }
      }
      //Pasajero pasajero = viajeController.getPasajeroRetirar(item);
      viajeController.updateTravelStatus(item);
      cargarInformacion();
      return true;
    } on Exception catch (_) {
      viajeController.utils.toastError(_.toString());
      debug(_.toString());
    }
    return false;
  }

  ///
  /// Propósito: Enviar notificación al pasajero para que firme el viaje electrónicamente.
  ///
  void sendSign(ViajePayload item) async {
    EnlaceRequest enlace = EnlaceRequest();
    enlace.estado = "I";
    enlace.tipo = "V";
    enlace.idViaje = item.id;
    bool? estado = await viajeController.createLink(enlace);
    if ((estado ?? false) == false) {
      viajeController.utils.toastError(Constants.mensajeCantSendSMS);
    }
  }

  ///
  /// Propósito: Se finaliza el viaje y se envía el SMS para firmar el viaje.
  ///
  void finishTravel(ViajePayload item) async {
    bool? estado = await setEstado(item, Constants.terminado);
    if (estado ?? false) {
      sendSign(item);
    }
  }

  ///
  /// Propósito: Realiza las consultas de estado de los viajes que han sido asignados al conductor.
  ///
  void cargarInformacion() async {
    try {
      print('cargarInformacion');
      isLoading = true;
      ViajeApi2? viajes1 = ViajeApi2();
      ViajeApi2? viajes2 = ViajeApi2();
      ViajeApi2? viajes3 = ViajeApi2();

      print('Consultando getViajesPendientes...');
      viajes1 = await viajeController.getViajesPendientes();
      print('Consultando getViajesEnProceso...');
      viajes2 = await viajeController.getViajesEnProceso();
      print('Consultando getViajesPorFirmar...');
      viajes3 = await viajeController.getViajesPorFirmar();
      print('Informacion retornada.');

      print('Fijando el estado de las variables...');
      setState(() {
        viajesPendientes = (viajes1 ?? ViajeApi2());
        viajesEnCurso = (viajes2 ?? ViajeApi2());
        viajesPorFirmar = (viajes3 ?? ViajeApi2());
      });
      print('Fijado el estado de las variables.');
    } catch (e) {
      viajeController.utils.toastError(e.toString());
    } finally {
      isLoading = false;
    }
  }
}
