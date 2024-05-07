import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:transportes_everest_mobile/config/constants.dart';
import 'package:transportes_everest_mobile/controllers/viaje_controller.dart';
import 'package:transportes_everest_mobile/entidades/viaje.dart';
import 'package:transportes_everest_mobile/entidades/viajes_pendientes/viajes_pendientes.dart';

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
            body: TabBarView(
              children: [
                ListView.builder(
                  itemCount: viajesPendientes.payload?.length ?? 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                              getViaje(viajesPendientes, index).cliente?.name ??
                                  ''),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.time_to_leave),
                            label: const Text("Iniciar"),
                            onPressed: () {
                              setEstado(viajesPendientes.payload![index],
                                  Constants.enProceso);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
                  },
                ),
                ListView.builder(
                  itemCount: viajesEnCurso.payload?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(getViaje(viajesEnCurso, index).cliente?.name ??
                              ''),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.stop),
                            label: const Text("Terminar"),
                            onPressed: () {
                              setEstado(viajesPendientes.payload![index],
                                  Constants.terminado);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
                  },
                ),
                ListView.builder(
                  itemCount: viajesPorFirmar.payload?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(getViaje(viajesPorFirmar, index).cliente?.name ??
                              ''),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.send),
                            label: const Text("Enviar"),
                            onPressed: () {
                              sendSign(viajesPendientes.payload![index]);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
                  },
                ),
              ],
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

  ///
  /// Propósito: Cambia el estado del viaje según las acciones que define el conductor.
  ///
  bool setEstado(Viaje item, String estado) {
    try {
      item.estado = estado;
      viajeController.updateStatus(item);
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
  void sendSign(Viaje item) {
    viajeController.createLink(item);
  }

  ///
  /// Propósito: Se finaliza el viaje y se envía el SMS para firmar el viaje.
  ///
  void finishTravel(Viaje item) {
    if (setEstado(item, Constants.terminado)) {
      sendSign(item);
    }
  }

  ///
  /// Propósito: Realiza las consultas de estado de los viajes que han sido asignados al conductor.
  ///
  void cargarInformacion() async {
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
  }
}
