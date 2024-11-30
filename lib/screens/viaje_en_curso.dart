import 'package:flutter/material.dart';
import 'package:transportes_everest_mobile/entidades/listado-revision-viajes/listado_revision_viajes.dart';
import 'package:uuid/uuid.dart';
import '../config/constants.dart';
import '../controllers/viaje_controller.dart';
import '../entidades/enlace_request.dart';

class ViajeEnCurso extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const ViajeEnCurso({super.key, required this.navigatorKey});

  @override
  State<ViajeEnCurso> createState() => _ViajeEnCursoState();
}

class _ViajeEnCursoState extends State<ViajeEnCurso> with WidgetsBindingObserver {
  late ViajeController viajeController;
  ListadoRevisionViajes viajes = ListadoRevisionViajes();
  bool isLoading = false;
  Uuid uuid = const Uuid();
  Key uniqueId = "uuid";

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

  void cargarInformacion() async {
    debugPrint("DEBUG: Consultando información...");
    ListadoRevisionViajes?  response = await viajeController.getViajesV2();
    if (response != null) {
      setState(() {
        viajes = response;
      });
    }
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
                    getViajes(viajes.payload!.where((item) => item.estado == Constants.pendiente).toList()),
                    getViajes(viajes.payload!.where((item) => item.estado == Constants.enProceso).toList()),
                    getViajes(viajes.payload!.where((item) => item.estado == Constants.terminado).toList())
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

  ListView getViajes(List<RevisionViajesPayload> lista) {
    if (lista.isEmpty) {
      return ListView();
    }
    return ListView.builder(
      key: ValueKey(value),
      itemCount: lista.length,
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
                  getViaje(lista[index]),
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

  Expanded getViaje(RevisionViajesPayload item) {
    try {
      item.ubicaciones!.sort((a, b) => a.id!.compareTo(b.id!));
      Ubicaciones ubicacion = getUbicacion(item);
      debugPrint("DEBUG: ${ubicacion.direccion} - ${ubicacion.estado} - ${ubicacion.tipo} - ${ubicacion.pasajeros?.length}");
      return Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("Solicitud: ${item.fechaHoraSolicitud}"),
          Text("Pasajeros: ${getPasajeros(item)}"),
          Text("Tarifa: ${viajeController.utils.formatNumber(item.tarifa ?? 0, 0, "\$")}"),
          const Divider(color: Colors.grey, thickness: 1.0),
          (ubicacion.direccion != null && ubicacion.direccion!.isEmpty ? const Text('data') :
            Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(children: [
                    Text(ubicacion.direccion ?? ''),
                    Text(ubicacion.comuna?.comuna ?? '')
                  ])
                ),
                const SizedBox(width: 15.0),
                SizedBox(
                  width: 50.0,
                  child: 
                  IconButton(onPressed: () async {
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
                  icon: const Icon(Icons.location_pin))
                )
              ]
            )
          ),
          (ubicacion.pasajeros != null && ubicacion.pasajeros!.isEmpty ? const Text('Destino Final') : 
          Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(),
              1: FixedColumnWidth(160.0)
            },
            border: const TableBorder(
              top: BorderSide(color: Colors.black, width: 1), // Borde superior
              bottom: BorderSide(color: Colors.black, width: 1), // Borde inferior
              horizontalInside: BorderSide(color: Colors.grey, width: 1), // Bordes entre filas
              left: BorderSide.none, // Sin borde izquierdo
              right: BorderSide.none, // Sin borde derecho
            ),          
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: List.generate(ubicacion.pasajeros?.length ?? 0, (index) => TableRow(
                children: <Widget> [
                  TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle, 
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(ubicacion.pasajeros?[index].user?.name ?? ''))
                  ),
                  TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle, 
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(onPressed: () {
                                viajeController.utils.openPhoneCall(phoneFormatted(ubicacion.pasajeros?[index].user?.phone ?? ''));
                              }, 
                              child: Text(phoneFormatted(ubicacion.pasajeros?[index].user?.phone ?? ''),
                              style: const TextStyle(fontSize: 16.0),)))
                  ),
                ])
            )
          )),
          botonViaje(item)
        ]));
    } catch (e, stackTrace) {
      debugPrint("DEBUG: Se generó un error al momento de mostrar el viaje ${item.id}");
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      // viajeController.utils.toastError(e.toString());     
      return const Expanded(child: Text('Sin información.'));
    }
  }

  String glosaBoton(RevisionViajesPayload item, Ubicaciones ubicacion) {
    if (item.estado == Constants.terminado) {
      return "Firmar";
    }
    if (ubicacion.tipo == Constants.ubicacionDestino) {
      return "Terminar viaje";
    }
    int pasajeros = 0;
    if (ubicacion.pasajeros != null) {
      pasajeros = ubicacion.pasajeros!.length;
    }
    if (ubicacion.estado == Constants.pendiente) {
      return "En camino";
    } else if (ubicacion.estado == Constants.enProceso) {
      return "Recoger pasajero${pasajeros > 1 ? '(s)' : ''}";
    }
    return "Iniciar";
  }

  Ubicaciones getUbicacion(RevisionViajesPayload item) {
    if (item.ubicaciones != null && item.ubicaciones!.isEmpty) {
      return Ubicaciones();
    }
    item.ubicaciones!.sort((a, b) => a.id!.compareTo(b.id!));
    return item.estado == Constants.terminado ?
      item.ubicaciones!.firstWhere((x) => x.tipo == Constants.ubicacionDestino , orElse: () => Ubicaciones() ) :
      item.ubicaciones!.firstWhere((x) => x.estado == Constants.pendiente || x.estado == Constants.enProceso, orElse: () => Ubicaciones() );
  }

  ElevatedButton botonViaje(RevisionViajesPayload item) {
    Ubicaciones ubicacion = getUbicacion(item);
    return  ElevatedButton(onPressed: () {
        if (item.estado != Constants.terminado) {
          actualizarUbicacion(ubicacion);
        } else {
          sendSign(item);
        }
      }, child: Row(
        mainAxisAlignment: MainAxisAlignment.center, 
        mainAxisSize: MainAxisSize.min,
        children: [
          (item.estado == Constants.terminado ? const Icon(Icons.edit_document) : const Icon(Icons.drive_eta_rounded)),
          Text(glosaBoton(item, ubicacion), style: const TextStyle(fontSize: 18.0),)
        ],)
    );
  }

  void actualizarUbicacion(Ubicaciones ubicacion) async {
    RevisionViajesPayload? response = await viajeController.updateStatusLocation(ubicacion.id ?? 0);
    if (response != null) {
      int indexFind = viajes.payload?.indexWhere((ubicacion) => ubicacion.id == response.id) ?? 0;
      if (indexFind != -1) {
        setState(() {
          // viajes.payload?[indexFind] = response;
          viajes.payload = List.from(viajes.payload ?? [])..[indexFind] = response;
        });
      }
      // viajes.payload.map((x) => debugPrint("${x.id} ${x.estado}"))
    }
  }

  ///
  /// Propósito: Enviar notificación al pasajero para que firme el viaje electrónicamente.
  ///
  void sendSign(RevisionViajesPayload item) async {
    EnlaceRequest enlace = EnlaceRequest();
    enlace.estado = "I";
    enlace.tipo = "V";
    enlace.idViaje = item.id;
    bool? estado = await viajeController.createLink(enlace);
    if ((estado ?? false) == false) {
      viajeController.utils.toastError(Constants.mensajeCantSendSMS);
    }
  }

  String phoneFormatted(String phone) {
    return viajeController.utils.phoneFormatted(phone);
  }

  List<DataCell> getCells(Ubicaciones item) {
    return <DataCell>[
      DataCell(Text(item.pasajeros!.first.user?.name ?? '')),
      DataCell(
        ElevatedButton(onPressed: () { 

          },
          child: Text(item.pasajeros!.first.user?.phone ?? ''))
        )
    ];

  }

  int getPasajeros(RevisionViajesPayload item) {
    bool flag = false;
    List<Pasajeros> usuarios = List.empty(growable: true);
    item.ubicaciones?.forEach((ubicacion) {
      ubicacion.pasajeros?.forEach((pasajero) {
        flag = false;
        for (var usuario in usuarios) {
          if (pasajero.userId == usuario.id) {
            flag = true;
            break;
          }
        }
        if (!flag) {
          usuarios.add(pasajero);
        }
      });
    });
    return usuarios.length;
  }

}
