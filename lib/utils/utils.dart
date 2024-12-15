import "dart:convert";
import "dart:io";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:geocoding/geocoding.dart";
import "package:intl/intl.dart";
import "package:location/location.dart" as location_current;
import "package:path_provider/path_provider.dart";
import "package:permission_handler/permission_handler.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_sms/flutter_sms.dart';
import "package:transportes_everest_mobile/config/constants.dart";
import "package:url_launcher/url_launcher.dart";

class Utils {
  // late BuildContext _context;
  static const String prefijoBlueExpress = '53300';
  final location_current.Location location = location_current.Location();

  /// Propósito: Método que se ejecuta para cerrar la aplicación por completo.
  /// Autor: Patricio Ramos Castro
  /// Fecha: 2024-01-06
  Future<dynamic> exitMethod(BuildContext context) {
    // _context = context;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar aplicación'),
          content:
              const Text('¿Estás seguro de que deseas cerrar la aplicación?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    debugPrint("getString [$key] value [$value]");
    if (value == null) {
      return "";
    }
    return value;
  }

  Future<int?> getInteger(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    debugPrint("getInteger [$key] value [$value]");
    if (value == null) {
      return 0;
    }
    return int.parse(value);
  }

  Future<void> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    debugPrint("setString [$key] value [$value]");
  }

  void toastError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void toastInfo(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black12,
      textColor: Colors.white,
    );
  }

  void toastErrorJson(String response) {
    String message = "Error al obtener información.";
    Map<String, dynamic> error = json.decode(response);
    if (error.containsKey('message')) {
      message = error['message'];
    }
    toastError(message);
  }

  Future<String?> takePicture(String prefix) async {
    try {
      ImagePicker picker = ImagePicker();
      XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        File imagen = File(pickedFile.path);
        List<int> imagenComprimida =
            await FlutterImageCompress.compressWithList(
          imagen.readAsBytesSync(),
          minHeight: 800,
          minWidth: 800,
          quality: 85,
        );
        int i;
        String workFolder = await obtenerDirectorioDocuments();
        String filename = "$workFolder/";
        for (i = 0; i < 10000; i++) {
          filename = "$workFolder/foto-${i.toString().padLeft(4, '0')}.jpg";
          if (await File(filename).exists() == false) {
            break;
          }
        }
        if (i.compareTo(10000) == 0) {
          i = 0;
          filename = "$workFolder/foto-${i.toString().padLeft(4, '0')}.jpg";
        }
        File(filename).writeAsBytesSync(imagenComprimida);
        debugPrint('FOTO $filename');
        return filename;
      }
    } catch (e) {
      debugPrint('FOTO ERROR: Al obtener la imagen: $e');
      toastError(e.toString());
    } finally {
      debugPrint('FOTO finalizada');
    }
    return "";
  }

  Future<String> obtenerDirectorioDocuments() async {
    final directorioDocuments = await getApplicationDocumentsDirectory();
    return directorioDocuments.path;
  }

  void send(String phone, String msg) async {
    List<String> lista = [];
    lista.add(phone);
    String? resultado = await sendList(lista, msg);
    debugPrint(resultado);
  }

  Future<String?> sendList(List<String> recipents, String msg) async {
    debugPrint("Enviando SMS...");
    bool canSend = await canSendSMS();
    if (canSend && await checkSmsPermission()) {
      String result =
          await sendSMS(message: msg, recipients: recipents, sendDirect: true)
              .catchError((onError) {
        debugPrint(onError.toString());
        toastError(onError.toString());
        return "${Constants.mensajeErrorSendSMS} : ${onError.toString()}";
      });
      return result;
    } else {
      return null;
    }
  }

  Future<bool> checkSmsPermission() async {

    var status = (await Permission.sms.status);
    if (status.isDenied) {
      status = await Permission.sms.request();
    }
    return (status.isGranted);
  }

  Future<location_current.LocationData?> getLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        toastError(Constants.mensajeErrorGPSOff);
        return null;
      }
    }
    location_current.PermissionStatus permissionGranted =
        await location.hasPermission();
    if (permissionGranted == location_current.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != location_current.PermissionStatus.granted) {
        toastError(Constants.mensajeErrorGPSAccess);
        return null;
      }
    }
    location_current.LocationData? currentLocation;
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      toastError(e.toString());
    }
    return currentLocation;
  }

  Future<bool?> openPhoneCall(String phoneNumber) async {
    bool estado = false;
    Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      estado = await launchUrl(launchUri);
    }
    return estado;
  }

  String phoneFormatted(String phoneNumber) {
    String phone = phoneNumber;
    if (phone.length < 8) {
      phone = phone.padLeft(8, "2");
    }
    if (phone.length < 9) {
      phone = phone.padLeft(9, "9");
    }
    if (phone.length < 11) {
      phone = "56$phone";
    }
    if (!phoneNumber.startsWith("+")) {
      phone = "+$phone";
    }
    return phone;
  }

  String getFormattedAddress(
      String street, String number, String commune, String region) {
    String destine = street.trim();
    if (number.isNotEmpty) {
      if (destine.isNotEmpty) {
        destine += " ";
      }
      destine += number.trim();
    }
    if (commune.isNotEmpty) {
      if (destine.isNotEmpty) {
        destine += ", ";
      }
      destine += commune.trim();
    }
    if (region.isNotEmpty) {
      if (destine.isNotEmpty) {
        destine += ", ";
      }
      destine += region.trim();
    }
    return destine;
  }

  Future<bool?> openWaze(String latitud, String longitud) async {
    bool estado = false;
    try {
      Uri wazeMapsUri = Uri(
        scheme: 'https',
        host: 'www.waze.com',
        path: '/ul',
        queryParameters: {
          'll': "ll=$latitud%2C$longitud",
          'navigate': "yes",
          'zoom': 17
        },
      );

      if (await canLaunchUrl(wazeMapsUri)) {
        estado = await launchUrl(wazeMapsUri);
      }
    } catch (e, stackTrace) {
      debugPrint("StackTrace: $stackTrace");
      debugPrint(e.toString());
    }
    return estado;
  }

  Future<bool?> openMaps(
      String street, String number, String commune, String region) async {
    bool estado = false;
    String address = getFormattedAddress(street, number, commune, region);
    Uri googleMapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/dir/?api=1',
      queryParameters: {
        'destination': address,
        'travelmode': Constants.travelModeDriving
      },
    );

    Clipboard.setData(ClipboardData(text: address));
    if (await canLaunchUrl(googleMapsUri)) {
      estado = await launchUrl(googleMapsUri);
      // } else {
    }
    return estado;
  }

  Future<Location?> obtenerCoordenadas(
      String street, String number, String commune, String region) async {
    String address = getFormattedAddress(street, number, commune, region);
    List<Location> resultados = await locationFromAddress(address);

    if (resultados.isNotEmpty) {
      debugPrint(resultados.first.toString());
      return resultados.first;
    } else {
      return null;
    }
  }

  Future<void> saveRouteStack(List<Map<String, dynamic>> routeStack) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString =
        jsonEncode(routeStack); // Convertimos la lista de mapas a JSON
    await prefs.setString('routeStack', jsonString); // Guardamos la cadena JSON
  }

  Future<List<Map<String, dynamic>>> getRouteStack() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString =
        prefs.getString('routeStack'); // Recuperamos la cadena JSON

    if (jsonString != null) {
      List<dynamic> jsonList =
          jsonDecode(jsonString); // Decodificamos de JSON a lista dinámica
      return List<Map<String, dynamic>>.from(
          jsonList); // Convertimos la lista dinámica en lista de mapas
    }

    return []; // Si no hay nada almacenado, retornamos una lista vacía
  }

  void loadRouteStack(NavigatorState navigatorKey) async {
    getRouteStack().then((routeStackWithArgs) {
      for (var route in routeStackWithArgs) {
        navigatorKey.pushNamed(
          route['route'],
          arguments: route['arguments'],
        );
      }
    });
  }

  String formatNumber(int value, decimalDigits, String symbol) {
    String valor = NumberFormat.currency(
      decimalDigits: decimalDigits, 
      locale: 'es_CL', 
      symbol: '').format(value);
    return "$symbol $valor";
  }

  int unixTimestamp() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }
}
