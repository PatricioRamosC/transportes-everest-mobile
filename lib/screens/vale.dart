import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:transportes_everest_mobile/config/constants.dart';
import 'package:transportes_everest_mobile/controllers/viaje_controller.dart';
import 'package:transportes_everest_mobile/entidades/ubicacion.dart';
import 'package:transportes_everest_mobile/entidades/viaje.dart';
import 'package:transportes_everest_mobile/entidades/viajes_pendientes/viajes_pendientes.dart';
import 'package:transportes_everest_mobile/screens/map_screen.dart';
import '../entidades/enlace_request.dart';

class Vale extends StatefulWidget {
  const Vale({super.key});

  @override
  State<Vale> createState() => _ValeState();
}

class _ValeState extends State<Vale> {
  ViajeController viajeController = ViajeController();
  ViajesPendientes viajesPendientes = ViajesPendientes();
  ViajesPendientes viajesEnCurso = ViajesPendientes();
  ViajesPendientes viajesPorFirmar = ViajesPendientes();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    debug('Inicio State');
    cargarInformacion();
  }

  void debug(String msg) {
    debugPrint('DEBUG: $msg');
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Viajes Pendientes';

    return MaterialApp(
      title: title,
      home: DefaultTabController(
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
      ),
    );
  }

  Viaje getViaje(ViajesPendientes? item, int index) {
    Viaje viaje = Viaje();
    try {
      List<Viaje> lista = item?.payload ?? List.empty();
      if (lista.isNotEmpty && lista.length > index) {
        viaje = (lista[index]);
      }
    } on Exception catch (_) {
      debugPrint(_.toString());
    }
    return viaje;
  }

  Expanded getTexto(Viaje item, bool estado) {
    Ubicacion origen =
        viajeController.getUbicacion(item, Constants.ubicacionOrigen) ??
            Ubicacion();
    Ubicacion destino =
        viajeController.getUbicacion(item, Constants.ubicacionDestino) ??
            Ubicacion();
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          item.cliente?.name ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(5.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onPressed: () => {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  Constants.textoUbicacionOrigen,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
                Text("${origen.direccion ?? ''} ${origen.numero}"),
                Text(origen.comuna?.comuna ?? ''),
              ],
            )),
        const SizedBox(height: 10.0),
        const Text(
          Constants.textoUbicacionDestino,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
        Text("${destino.direccion ?? ''} ${destino.numero}"),
        Text(destino.comuna?.comuna ?? ''),
        GestureDetector(
          onTap: () {
            // Launch the phone call intent with the phone number
            viajeController.utils.openPhoneCall(viajeController.utils
                .phoneFormatted(item.cliente?.phone ?? ''));
          },
          child: Text(
            viajeController.utils.phoneFormatted(item.cliente?.phone ?? ''),
            style: const TextStyle(
              decoration: TextDecoration
                  .underline, // Optional: Underline the phone number
              color: Colors
                  .blue, // Optional: Set a distinct color for the phone number
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            // Launch the phone call intent with the phone number
            viajeController.utils.obtenerCoordenadas(
                destino.direccion ?? '',
                destino.numero ?? '',
                destino.comuna?.comuna ?? '',
                destino.comuna?.region?.region ?? '');
            // viajeController.utils.openMaps(
            //     origen.direccion ?? '',
            //     origen.numero ?? '',
            //     origen.comuna?.comuna ?? '',
            //     origen.comuna?.region?.region ?? '');
          },
          child: Text(
            "${origen.direccion ?? ''}${origen.numero ?? ''}",
            style: const TextStyle(
              decoration: TextDecoration
                  .underline, // Optional: Underline the phone number
              color: Colors
                  .blue, // Optional: Set a distinct color for the phone number
            ),
          ),
        ),
        ElevatedButton(
            onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(
                          informacionDestino: origen.direccion ?? '',
                          source: LatLng(
                              double.parse(item.origenLatitud ?? "0"),
                              double.parse(item.origenLongitud ?? "0")),
                          destination: LatLng(
                              double.parse(item.destinoLatitud ?? "0"),
                              double.parse(item.destinoLongitud ?? "0"))),
                    ),
                  )
                },
            child: const Text('Ir'))
      ]),
    );
  }

  ListView getViajes(ViajesPendientes viajes, String estado) {
    return ListView.builder(
      itemCount: viajes.payload?.length ?? 0,
      itemBuilder: (context, index) {
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
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.time_to_leave),
                  label: Text(estado == Constants.pendiente
                      ? "Iniciar"
                      : (estado == Constants.enProceso
                          ? "Terminar"
                          : "Firmar")),
                  onPressed: () {
                    if (estado != Constants.finalizado) {
                      setEstado(viajes.payload![index], estado);
                    } else {
                      sendSign(viajes.payload![index]);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
      },
    );
  }

  ///
  /// Propósito: Cambia el estado del viaje según las acciones que define el conductor.
  ///
  Future<bool?> setEstado(Viaje item, String estado) async {
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
      viajeController.updateStatus(item);
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
  void sendSign(Viaje item) async {
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
  void finishTravel(Viaje item) async {
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
      isLoading = true;
      ViajesPendientes? viajes1 = ViajesPendientes();
      ViajesPendientes? viajes2 = ViajesPendientes();
      ViajesPendientes? viajes3 = ViajesPendientes();

      viajes1 = await viajeController.obtenerViajesPendientes();
      viajes2 = await viajeController.obtenerViajesEnProceso();
      viajes3 = await viajeController.obtenerViajesPorFirmar();

      setState(() {
        viajesPendientes = (viajes1 ?? ViajesPendientes());
        viajesEnCurso = (viajes2 ?? ViajesPendientes());
        viajesPorFirmar = (viajes3 ?? ViajesPendientes());
      });
    } catch (e) {
      viajeController.utils.toastError(e.toString());
    } finally {
      isLoading = false;
    }
  }
}
