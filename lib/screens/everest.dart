import 'package:flutter/material.dart';
import 'package:transportes_everest_mobile/controllers/everest_controller.dart';

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
              print('builder $snapshot');
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error cargando opciones'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('No hay opciones disponibles'));
              } else {
                return ListView(
                  children: snapshot.data!.map((option) {
                      return ListTile(
                        leading: Icon(option?.getIconData()),
                        title: Text(option?.optionName ?? ''),
                        onTap: () {
                          Navigator.pop(context); // Cierra el Drawer
                          Navigator.pushNamed(
                            context,
                            option?.widgetName ?? ''
                          );
                        },
                      );
                    }).toList()
                );
              }
            })),
      body: Center(
        child: Text('Versión Beta 1.1.1'),
      ),
    );
  }
}
