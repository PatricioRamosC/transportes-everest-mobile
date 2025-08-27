import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transportes_everest_mobile/controllers/everest_controller.dart';

import '../providers/session_provider.dart';

class Everest extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const Everest({super.key, required this.navigatorKey});

  @override
  State<Everest> createState() => _EverestState();
}

class _EverestState extends State<Everest> {
  late EverestController controller;
  String selectedPage = "";

  @override
  void initState() {
    super.initState();
    controller = EverestController(navigatorKey: widget.navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transporte Everest'),
      ),
      drawer: Drawer(
          child: FutureBuilder(
              future: controller.fetchMenuOptions(),
              builder: (context, snapshot) {
                debugPrint('builder $snapshot');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error cargando opciones'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No hay opciones disponibles'));
                } else {
                  final menuOptions = snapshot.data!;
                  return ListView(
                    children: [
                      // ... Opciones existentes del menú
                      ...menuOptions.map((option) {
                        return ListTile(
                          leading: Icon(option?.getIconData()),
                          title: Text(option?.optionName ?? ''),
                          onTap: () {
                            Navigator.pop(context); // Cierra el Drawer
                            Navigator.pushNamed(
                                context, option?.widgetName ?? '');
                          },
                        );
                      }),
                      // Divisor para separar la opción de salir
                      const Divider(),
                      // Nueva opción para cerrar la aplicación
                      ListTile(
                        leading:
                            const Icon(Icons.exit_to_app), // Icono apropiado
                        title: const Text('Cerrar aplicación'),
                        onTap: () {
                          Navigator.pop(context); // Cierra el Drawer primero
                          _showExitDialog(
                              context); // Muestra el diálogo de confirmación
                        },
                      ),
                    ],
                  );
                }
              })),
      body: const Center(
        child: Text('Versión Beta 1.4.3'),
      ),
    );
  }

  Future<void> _showExitDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe tocar un botón para cerrar
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Cerrar aplicación?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    '¿Estás seguro de que quieres salir de Transporte Everest?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: const Text('Sí, salir'),
              onPressed: () {
                // Cierra el diálogo primero
                Navigator.of(context).pop();
                // Luego cierra la aplicación
                _closeApp();
              },
            ),
          ],
        );
      },
    );
  }

  void _closeApp() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login', // o la ruta de tu login
      (Route<dynamic> route) =>
          false, // Esto remueve todas las rutas anteriores
    );

    // Opcional: Si necesitas limpiar el estado de la sesión
    final sessionProvider = context.read<SessionProvider>();
    sessionProvider.logout();
  }
}
