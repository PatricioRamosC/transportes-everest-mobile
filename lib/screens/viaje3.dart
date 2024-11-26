import 'package:flutter/material.dart';
import 'package:transportes_everest_mobile/entidades/viaje_api2.dart';

import '../config/constants.dart';
import '../controllers/viaje_controller.dart';
import '../entidades/viaje_mobile.dart';

class Viaje3 extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const Viaje3({super.key, required this.navigatorKey});

  @override
  State<Viaje3> createState() => _Viaje3State();
}

class _Viaje3State extends State<Viaje3> with WidgetsBindingObserver {
  late ViajeController viajeController;
  bool isLoading = false;
  ViajeMobile viajesPendientes = ViajeMobile();
  ViajeMobile viajesEnCurso = ViajeMobile();
  ViajeMobile viajesPorFirmar = ViajeMobile();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    viajeController = ViajeController(navigatorKey: widget.navigatorKey);
    debugPrint('Inicio State');
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

  void cargarInformacion() async {
    try {
      debugPrint('cargarInformacion...');
      isLoading = true;
      ViajeMobile? viajes1 = ViajeMobile();
      ViajeMobile? viajes2 = ViajeMobile();
      ViajeMobile? viajes3 = ViajeMobile();

      debugPrint('Consultando getViajesPendientes...');
      viajes1 = await viajeController.obtenerViajesPendientes();
      debugPrint('Consultando getViajesEnProceso...');
      viajes2 = await viajeController.obtenerViajesEnProceso();
      debugPrint('Consultando getViajesPorFirmar...');
      viajes3 = await viajeController.obtenerViajesPorFirmar();
      debugPrint('Informacion retornada.');

      debugPrint('Fijando el estado de las variables...');
      setState(() {
        viajesPendientes = (viajes1 ?? ViajeMobile());
        viajesEnCurso = (viajes2 ?? ViajeMobile());
        viajesPorFirmar = (viajes3 ?? ViajeMobile());
      });
      debugPrint('Fin cargarInformacion.');
    } catch (e) {
      viajeController.utils.toastError(e.toString());
    } finally {
      isLoading = false;
    }
  }

  ListView getViajes(ViajeMobile viajes, String estado) {
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
                      viajes.payload![index]!, (estado == Constants.pendiente)),
                ],
              ),
            ),
          ));
        } catch (e, stackTrace) {
          debugPrint("Error en el itemBuilder: $e");
          debugPrint("StackTrace: $stackTrace");
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

  // Card de cada Viaje que se muestra en pantalla.
  Expanded getTexto(ViajeMobilePayload item, bool pendiente) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text("Solicitud: ${item.fechahorasolicitud}"),
        Text("Pasajeros: ${item.pasajeros}"),
        (item.proximoDestinoId != item.destinoId ? 
        Text(
          "Pasajero: ${item.pasajero ?? ''}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ) : 
        const Text(
          "Destino Final",
          style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        )
        ),
        Text("Tarifa : ${item.tarifa}",
          style: const TextStyle(fontWeight: FontWeight.bold)),
        const Divider(
          color: Colors.grey,
          thickness: 1.0,
        ),
        const Text(
          Constants.textoUbicacionOrigen,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        getDireccion(item, true),
        ElevatedButton(
          style: const ButtonStyle(
              shape: WidgetStatePropertyAll(BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))))),
          onPressed: () {
            viajeController.utils.openPhoneCall(viajeController.utils
                .phoneFormatted(item.phone ?? ''));
          },
          child: Text(
            viajeController.utils.phoneFormatted(item.phone ?? ''),
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
        getDireccion(item, false),
        const SizedBox(height: 10.0),
        ElevatedButton(
          style: const ButtonStyle(
              shape: WidgetStatePropertyAll(BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))))),
          onPressed: () {
            viajeController.updateStatusPassanger(item.pasajeroId ?? 0)
                .then(
                  (response) {
                    cargarInformacion();
                  }, 
                onError: (error) {
                  viajeController.utils.toastError(error);
                });
          },
          child: const Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.time_to_leave),
                  SizedBox(width: 10.0),
                  Text('Iniciar')
                ]),
        ),
      ]),
    );
  }

  Row getDireccion(ViajeMobilePayload ubicacion, bool proximoDestino) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  (proximoDestino ? ubicacion.proximoDestino : ubicacion.destino) ?? '',
                  style: const TextStyle(fontSize: 14.0),
                ),
                Text(
                  (proximoDestino ? ubicacion.comunaProximoDestino : ubicacion.destinoComuna) ?? '',
                    style: const TextStyle(fontSize: 14.0)),
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
                    if (proximoDestino) {
                      if (!(await viajeController.utils.openWaze(
                              ubicacion.latitud ?? '',
                              ubicacion.longitud ?? '') ??
                          false)) {
                        viajeController.utils.openMaps(
                            ubicacion.proximoDestino ?? '',
                            "",
                            ubicacion.comunaProximoDestino ?? '',
                            ubicacion.region ?? '');
                      }
                    } else {
                      if (!(await viajeController.utils.openWaze(
                              ubicacion.destinoLatitud ?? '',
                              ubicacion.destinoLongitud ?? '') ??
                          false)) {
                        viajeController.utils.openMaps(
                            ubicacion.destino ?? '',
                            "",
                            ubicacion.destinoComuna ?? '',
                            ubicacion.destinoRegion ?? '');
                      }
                    }
                  },
                  child: const Icon(Icons.location_pin),
                ),
              ],
            ))
      ],
    );
  }

}