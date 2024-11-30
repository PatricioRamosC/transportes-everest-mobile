import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transportes_everest_mobile/providers/screens_provider.dart';
import 'package:transportes_everest_mobile/providers/session_provider.dart';
import 'package:transportes_everest_mobile/screens/everest.dart';
import 'package:transportes_everest_mobile/screens/login.dart';
import 'package:transportes_everest_mobile/screens/vale2.dart';
import 'package:transportes_everest_mobile/screens/viaje3.dart';
import 'package:transportes_everest_mobile/screens/viaje_en_curso.dart';
import 'package:transportes_everest_mobile/utils/theme.dart';

void main() {
  runApp(MultiProvider(providers: [
    Provider<SessionProvider>(create: (_) => SessionProvider()),
    Provider<ScreensProvider>(create: (_) => ScreensProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = ColorScheme(
      // Definir colores primarios y secundarios
      primary: Colors.black54, // Color para los botones y el icono.
      primaryContainer: Colors.blue.shade700,
      secondary: Colors.green,
      secondaryContainer: Colors.green.shade700,
      // Colores para los botones.

      // Definir colores para diferentes partes de la interfaz de usuario
      surface: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onError: Colors.white,
      // Opcional: definir un brillo para los colores claros y oscuros
      brightness: Brightness.light,
    );

    TextTheme textTheme = const TextTheme(
      // Definir estilos de texto para diferentes encabezados
      displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold), // Estilo del titulo del AppBar
      // Definir estilos de texto para el cuerpo de texto
      bodyLarge: TextStyle(fontSize: 12), // Estilo de los input
      bodyMedium: TextStyle(fontSize: 10),
      // Otros estilos de texto
      titleMedium: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      titleSmall: TextStyle(fontSize: 12, color: Colors.grey),
      // Estilo de texto para botones
      labelLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    );

    MaterialTheme materialTheme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Transportes Everest',
      theme: materialTheme.lightHighContrast(),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: Colors.red,
      //   ),
      // ),
      navigatorKey: navigatorKey,
      home: LoginPage(navigatorKey: navigatorKey),
      onGenerateRoute: generateRoute,
      //home: const MyHomePage(title: 'Transportes Everest'),
      initialRoute: '/',
      //initialRoute: '/login',
      /*
      routes: {
        // '/login': (context) => LoginPage(navigatorKey: navigatorKey),
        '/menu': (context) => Everest(navigatorKey: navigatorKey),
        '/vale': (context) => Vale2(
              navigatorKey: navigatorKey,
            ),
        // '/details': (context) => DetailsScreen(),
      },
      */
      // Pantalla inicial
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    // Aquí definimos las rutas personalizadas
    switch (settings.name) {
      case '/menu':
        return MaterialPageRoute(
            builder: (_) => Everest(navigatorKey: navigatorKey));
      case '/vale':
        return MaterialPageRoute(
            builder: (_) => ViajeEnCurso(
                  navigatorKey: navigatorKey,
                ));
      // case '/tripDetails':
      //   final tripId =
      //       settings.arguments as String; // Pasando argumentos a la ruta
      //   return MaterialPageRoute(
      //       builder: (_) => TripDetailsScreen(tripId: tripId));
      default:
        return MaterialPageRoute(
            builder: (_) =>
                const NotFoundScreen()); // Ruta por defecto si no se encuentra la ruta
    }
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Text('Opción no encontrada.'));
  }
}

