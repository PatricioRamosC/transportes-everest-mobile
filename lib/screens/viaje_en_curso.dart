import 'package:flutter/material.dart';
import 'package:transportes_everest_mobile/entidades/listado-revision-viajes/listado_revision_viajes.dart';
import '../components/waiting_timer.dart';
import '../config/constants.dart';
import '../controllers/viaje_controller.dart';
import '../entidades/enlace_request.dart';

class ViajeEnCurso extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const ViajeEnCurso({super.key, required this.navigatorKey});

  @override
  State<ViajeEnCurso> createState() => _ViajeEnCursoState();
}

class _ViajeEnCursoState extends State<ViajeEnCurso>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late ViajeController viajeController;
  ListadoRevisionViajes viajes = ListadoRevisionViajes();
  bool isLoading = false;
  String conductor = "";
  bool isEnCurso = true;
  bool isPorFirmar = true;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    viajeController = ViajeController(navigatorKey: widget.navigatorKey);
    tabController = TabController(length: 3, vsync: this);
    cargarInformacion();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    tabController.dispose();
    super.dispose();
  }

  void cargarInformacion() async {
    debugPrint("DEBUG: Consultando información...");
    isEnCurso = false;
    isPorFirmar = false;
    ListadoRevisionViajes? response = await viajeController.getViajesV2();
    if (response != null) {
      conductor = response.payload?.first.conductor?.name ?? '';
      setState(() {
        viajes = response;
        final viajesEnCurso = viajes.payload
                ?.where((x) => x.estado == Constants.enProceso)
                .toList() ??
            [];
        isEnCurso = viajesEnCurso.isNotEmpty;
        final viajesPorFirmar = viajes.payload
                ?.where((x) => x.estado == Constants.terminado)
                .toList() ??
            [];
        isPorFirmar = viajesPorFirmar.isNotEmpty;
        if (isEnCurso) {
          mostrarEnCurso();
        }
        /*
        if (isEnCurso && !isPorFirmar) {
          mostrarEnCurso();
        } else if (isPorFirmar) {
          mostrarPorFirmar();
        }
        */
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
    return SafeArea(
      child: Scaffold(
        appBar: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Pendiente'),
            Tab(text: 'En curso'),
            Tab(text: 'Por firmar')
          ],
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            getViajes(Constants.pendiente),
            getViajes(Constants.enProceso),
            getViajes(Constants.terminado)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: cargarInformacion,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  ListView getViajes(String estado) {
    List<RevisionViajesPayload> lista = [];
    if (viajes.payload != null) {
      lista = viajes.payload!.where((x) => x.estado == estado).toList();
    }
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) {
        return Card(
          color:
              index % 2 == 0 ? Colors.indigo.shade50 : Colors.indigo.shade100,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: getViaje(lista[index]),
          ),
        );
      },
    );
  }

  Widget getViaje(RevisionViajesPayload item) {
    item.ubicaciones!.sort((a, b) => a.id!.compareTo(b.id!));
    Ubicaciones ubicacion = getUbicacion(item);
    Ubicaciones destinoFinal = getDestino(item);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHeader(item),
        _buildServiceInfo(item),
        _buildPassengerInfo(item),
        _buildTariffInfo(item),
        if (destinoFinal.id != ubicacion.id)
          _buildDestinationInfo(destinoFinal),
        const Divider(color: Colors.grey, thickness: 1.0),
        if (ubicacion.direccion != null && ubicacion.direccion!.isNotEmpty)
          _buildLocationSection(ubicacion),
        if (ubicacion.pasajeros != null && ubicacion.pasajeros!.isNotEmpty)
          _buildPassengersTable(ubicacion),
        const SizedBox(height: 8),
        _buildActionButtons(item, ubicacion),
      ],
    );
  }

  /// Propósito: Crear la sección del encabezado del viaje en la pantalla.
  /// Parámetros:
  ///   - RevisionViajesPayload item: El objeto que contiene la información del viaje.
  /// Retorna: Widget que muestra el encabezado del viaje.
  Widget _buildHeader(RevisionViajesPayload item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Viaje Nro: ${item.id}",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        if (item.comentarios != null && item.comentarios!.isNotEmpty)
          IconButton(
            onPressed: () =>
                showObservacionesDialog(context, item.comentarios ?? ''),
            icon: const Icon(Icons.info, size: 30),
            color: Colors.red,
          ),
      ],
    );
  }

  Widget _buildServiceInfo(RevisionViajesPayload item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Tipo de Servicio: ${item.convenio?.convenio ?? 'Particular'}"),
        Text("Solicitud: ${item.fechaHoraSolicitud}"),
      ],
    );
  }

  Widget _buildPassengerInfo(RevisionViajesPayload item) {
    return Text(
      "Pasajeros: ${getPasajeros(item)}",
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTariffInfo(RevisionViajesPayload item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Tarifa: ${viajeController.utils.formatNumber(item.tarifa ?? 0, 0, "\$")}",
          textAlign: TextAlign.center,
          // style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "Medio de Pago: ${item.medioPago?.medioPago ?? ''}",
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildDestinationInfo(Ubicaciones destinoFinal) {
    return Text(
      "Destino: ${destinoFinal.direccion} - ${destinoFinal.comuna?.comuna}",
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLocationSection(Ubicaciones ubicacion) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ubicacion.direccion ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Text(
                ubicacion.comuna?.comuna ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
        const SizedBox(width: 15.0),
        SizedBox(
          width: 50.0,
          child: IconButton(
            onPressed: () => _openNavigation(ubicacion),
            icon: const Icon(Icons.location_pin),
          ),
        ),
      ],
    );
  }

  void _openNavigation(Ubicaciones ubicacion) async {
    if (!(await viajeController.utils
            .openWaze(ubicacion.latitud ?? '', ubicacion.longitud ?? '') ??
        false)) {
      viajeController.utils.openMaps(
        ubicacion.direccion ?? '',
        "",
        ubicacion.comuna?.comuna ?? '',
        ubicacion.comuna?.region?.region ?? '',
      );
    }
  }

  Widget _buildPassengersTable(Ubicaciones ubicacion) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FixedColumnWidth(160.0)
      },
      border: const TableBorder(
        top: BorderSide(color: Colors.black, width: 1),
        bottom: BorderSide(color: Colors.black, width: 1),
        horizontalInside: BorderSide(color: Colors.grey, width: 1),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: List.generate(ubicacion.pasajeros?.length ?? 0,
          (index) => _buildPassengerRow(ubicacion.pasajeros![index])),
    );
  }

  /// Propósito: Mostrar la información de los pasajeros que están involucrados en la ubicación actual que debe ser procesado en el viaje.
  /// Parámetros:
  ///   - Pasajeros pasajero: lista que contiene los pasajeros que están relacionados a la ubicación.
  /// Retorna: TableRow con el nombre y teléfonos de cada pasajeros.
  TableRow _buildPassengerRow(Pasajeros pasajero) {
    return TableRow(
      children: <Widget>[
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(pasajero.user?.name ?? ''),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: pasajero.accion == Constants.accionBajada
                ? const Text("Baja")
                : ElevatedButton(
                    onPressed: () => viajeController.utils.openPhoneCall(
                      phoneFormatted(pasajero.user?.phone ?? ''),
                    ),
                    child: Text(
                      phoneFormatted(pasajero.user?.phone ?? ''),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  /// Propósito: Construir los botones de acción basados en el estado del viaje y la ubicación actual.
  /// Parámetros:
  /// - item: El objeto RevisionViajesPayload que contiene la información del viaje.
  /// - ubicacion: El objeto Ubicaciones que representa la ubicación actual del viaje.
  /// Retorna: Un widget Row que contiene los botones de acción apropiados.
  Widget _buildActionButtons(
      RevisionViajesPayload item, Ubicaciones ubicacion) {
    debugPrint(
        "DEBUG: Construyendo botones de acción para viaje ${item.id} en estado ${item.estado} y ubicación ${ubicacion.id} en estado ${ubicacion.estado}");
    if (activoBotonEsperando(item)) {
      return Center(
          child: Row(
        spacing: 8.0,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: _buildWaitingSection(item),
          ),
          Flexible(flex: 1, child: _buildMainActionButton(item, ubicacion)),
        ],
      ));
    } else {
      return Center(
        child: _buildMainActionButton(item, ubicacion),
      );
    }
  }

  /// Propósito: Construir la sección de espera con el temporizador o el botón de "Esperando".
  /// Parámetros:
  /// - item: El objeto RevisionViajesPayload que contiene la información del viaje.
  /// Retorna: Un widget que representa la sección de espera.
  Widget _buildWaitingSection(RevisionViajesPayload item) {
    Ubicaciones ubicacion = getUbicacion(item);
    List<Pasajeros> subida = ubicacion.pasajeros!
        .where((x) => x.accion == Constants.accionSubida)
        .toList();
    if (ubicacion.esperas != null &&
        ubicacion.esperas!.isNotEmpty &&
        subida.isNotEmpty) {
      final waitingStartTime =
          DateTime.tryParse(ubicacion.esperas!.first.inicio ?? '');
      return WaitingTimerWidget(
        startTime: waitingStartTime!,
        isActive: true,
        onTimerFinished: () {},
      );
    } else {
      return botonEsperando(item);
    }
  }

  /// Propósito: Construir el botón de acción principal basado en el estado del viaje y la ubicación actual.
  /// Parámetros:
  /// - item: El objeto RevisionViajesPayload que contiene la información del viaje.
  /// - ubicacion: El objeto Ubicaciones que representa la ubicación actual del viaje.
  /// Retorna: Un widget ElevatedButton que representa el botón de acción principal.
  Widget _buildMainActionButton(
      RevisionViajesPayload item, Ubicaciones ubicacion) {
    return ElevatedButton(
      onPressed: () => _handleMainAction(item, ubicacion),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _getActionIcon(item),
          Flexible(
              child: Text(
            glosaBoton(item, ubicacion),
            style: const TextStyle(fontSize: 18.0),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ))
        ],
      ),
    );
  }

  /// Propósito: Obtener el ícono apropiado para el botón de acción principal basado en el estado del viaje.
  /// Parámetros:
  /// - item: El objeto RevisionViajesPayload que contiene la información del viaje.
  /// Retorna: Un widget Icon que representa el ícono adecuado.
  Icon _getActionIcon(RevisionViajesPayload item) {
    return item.estado == Constants.terminado
        ? const Icon(Icons.edit_document)
        : const Icon(Icons.drive_eta_rounded);
  }

  /// Propósito: Actualiza el estado de la ubicación según el flujo del viaje o si ha concluido
  ///           el viaje, acciona la opción de firmar el viaje pidiendo al backend que genere
  ///           una URL que será enviada al cliente para su firma.
  /// Parámetros:
  /// - item: El objeto RevisionViajesPayload que contiene la información del viaje.
  /// - ubicacion: El objeto Ubicaciones que representa la ubicación actual del viaje.
  /// Retorna: void
  void _handleMainAction(RevisionViajesPayload item, Ubicaciones ubicacion) {
    if (item.estado != Constants.terminado) {
      actualizarUbicacion(ubicacion);
    } else {
      sendSign(item);
    }
  }

  /// Propósito: Determinar la etiqueta del botón principal basado en el estado del viaje y la ubicación actual.
  /// Retorna: La etiqueta del botón como un String.
  /// Parámetros:
  /// - item: El objeto RevisionViajesPayload que contiene la información del viaje.
  /// - ubicacion: El objeto Ubicaciones que representa la ubicación actual del viaje.
  /// Retorna: String
  String glosaBoton(RevisionViajesPayload item, Ubicaciones ubicacion) {
    if (item.estado == Constants.terminado) {
      return "Firmar";
    }
    if (ubicacion.tipo == Constants.ubicacionDestino) {
      return "Terminar viaje";
    }
    int pasajeros = 0;
    String accion = Constants.accionBajada;
    if (ubicacion.pasajeros != null) {
      pasajeros = ubicacion.pasajeros!.length;
      List<Pasajeros> lista = ubicacion.pasajeros!
          .where((x) => x.accion == Constants.accionSubida)
          .toList();
      if (lista.isNotEmpty) {
        accion = Constants.accionSubida;
      }
    }
    if (ubicacion.estado == Constants.pendiente) {
      return "En camino";
    } else if (ubicacion.estado == Constants.enProceso) {
      return "${accion == Constants.accionSubida ? 'Recoger' : 'Dejar'} pasajero${pasajeros > 1 ? 's' : ''}";
    }
    return "Iniciar";
  }

  Ubicaciones getUbicacion(RevisionViajesPayload item) {
    if (item.ubicaciones != null && item.ubicaciones!.isEmpty) {
      return Ubicaciones();
    }
    item.ubicaciones!.sort((a, b) => a.id!.compareTo(b.id!));
    return item.estado == Constants.terminado
        ? item.ubicaciones!.firstWhere(
            (x) => x.tipo == Constants.ubicacionDestino,
            orElse: () => Ubicaciones())
        : item.ubicaciones!.firstWhere(
            (x) =>
                x.estado == Constants.pendiente ||
                x.estado == Constants.enProceso,
            orElse: () => Ubicaciones());
  }

  Ubicaciones getDestino(RevisionViajesPayload viaje) {
    return viaje.ubicaciones!.firstWhere(
        (x) => x.tipo == Constants.ubicacionDestino,
        orElse: () => Ubicaciones());
  }

  ElevatedButton botonViaje(RevisionViajesPayload item) {
    Ubicaciones ubicacion = getUbicacion(item);
    return ElevatedButton(
        onPressed: () {
          if (item.estado != Constants.terminado) {
            actualizarUbicacion(ubicacion);
          } else {
            sendSign(item);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            (item.estado == Constants.terminado
                ? const Icon(Icons.edit_document)
                : const Icon(Icons.drive_eta_rounded)),
            Text(
              glosaBoton(item, ubicacion),
              style: const TextStyle(fontSize: 18.0),
              maxLines: 2,
            )
          ],
        ));
  }

  activoBotonEsperando(RevisionViajesPayload item) {
    Ubicaciones ubicacion = getUbicacion(item);
    List<Pasajeros> lista = ubicacion.pasajeros
            ?.where((element) => element.accion == Constants.accionSubida)
            .toList() ??
        List.empty();
    bool valor = (lista.isNotEmpty && ubicacion.estado == Constants.enProceso);
    debugPrint(
        "DEBUG: Activo botón esperando para viaje ${item.id} en ubicación ${ubicacion.id}: $valor");
    return valor;
  }

  /// Propósito: Construir el botón de "Esperando" que permite al conductor notificar su llegada y comenzar el temporizador de espera.
  /// Parámetros:
  /// - item: El objeto RevisionViajesPayload que contiene la información del viaje.
  /// Retorna: Un widget ElevatedButton que representa el botón de "Esperando".
  Widget botonEsperando(RevisionViajesPayload item) {
    Ubicaciones ubicacion = getUbicacion(item);
    debugPrint(
        "DEBUG: Construyendo botón esperando para viaje ${item.id} en ubicación ${ubicacion.id}");
    return ElevatedButton(
        onPressed: () async {
          final espera = await viajeController.setWaiting(ubicacion);
          setState(() {
            ubicacion.esperas ??= [];
            ubicacion.esperas!.add(espera);
          });
          notificarEsperando(ubicacion);
          // _arriveAtPickup();
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_bottom_rounded),
            Text(
              "Esperando",
              style: TextStyle(fontSize: 18.0),
            )
          ],
        ));
  }

  void actualizarUbicacion(Ubicaciones ubicacion) async {
    RevisionViajesPayload? response =
        await viajeController.updateStatusLocation(ubicacion.id ?? 0);
    if (response != null) {
      if (ubicacion.estado == Constants.pendiente &&
          ubicacion.tipo != Constants.ubicacionDestino) {
        String vehiculo =
            "${response.conductor?.movil?.marca} ${response.conductor?.movil?.modelo} ${response.conductor?.movil?.patente}";
        notificarEnRuta(ubicacion, vehiculo);
        mostrarEnCurso();
      }
      cargarInformacion();
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

  void notificarEnRuta(Ubicaciones ubicacion, String vehiculo) {
    List<String> recipients = getDestinatarios(ubicacion);
    if (recipients.isNotEmpty) {
      viajeController.utils.sendList(recipients,
          "Hola, mi nombre es $conductor de Transportes Everest, voy en camino en $vehiculo.");
    }
  }

  void notificarEsperando(Ubicaciones ubicacion) {
    List<String> recipients = getDestinatarios(ubicacion);
    if (recipients.isNotEmpty) {
      viajeController.utils.sendList(
          recipients, "He llegado y me encuentro esperando por usted.");
    }
  }

  List<String> getDestinatarios(Ubicaciones ubicacion) {
    List<String> recipents = List.empty(growable: true);
    ubicacion.pasajeros?.forEach((item) {
      if (item.accion == Constants.accionSubida && item.user != null) {
        recipents
            .add(viajeController.utils.phoneFormatted(item.user?.phone ?? ''));
      }
    });
    return recipents;
  }

  String phoneFormatted(String phone) {
    return viajeController.utils.phoneFormatted(phone);
  }

  List<DataCell> getCells(Ubicaciones item) {
    return <DataCell>[
      DataCell(Text(item.pasajeros!.first.user?.name ?? '')),
      DataCell(ElevatedButton(
          onPressed: () {},
          child: Text(item.pasajeros!.first.user?.phone ?? '')))
    ];
  }

  int getPasajeros(RevisionViajesPayload item) {
    Set<int> idsUnicos = {};
    item.ubicaciones?.forEach((ubicacion) {
      ubicacion.pasajeros?.forEach((pasajero) {
        idsUnicos.add(pasajero.userId ?? 0);
      });
    });
    return idsUnicos.length;
  }

  void showObservacionesDialog(BuildContext context, String observaciones) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Observaciones'),
            content: SingleChildScrollView(child: Text(observaciones)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'))
            ],
          );
        });
  }

  void mostrarEnCurso() {
    if (tabController.index != 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          tabController.animateTo(1);
        }
      });
    }
  }

  void mostrarPorFirmar() {
    if (tabController.index != 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          tabController.animateTo(2);
        }
      });
    }
  }
}
