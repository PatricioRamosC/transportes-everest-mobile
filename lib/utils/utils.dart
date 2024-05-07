import "dart:convert";
import "dart:io";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:path_provider/path_provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_sms/flutter_sms.dart';
import "package:transportes_everest_mobile/config/constants.dart";

class Utils {
  // late BuildContext _context;
  static const String prefijoBlueExpress = '53300';

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
    if (value == null) {
      return "";
    }
    return value;
  }

  Future<int?> getInteger(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    if (value == null) {
      return 0;
    }
    return int.parse(value);
  }

  Future<void> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
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

  void send(List<String> recipents, String msg) async {
    bool canSend = await canSendSMS();
    if (canSend) {
      String result = await sendSMS(message: msg, recipients: recipents)
          .catchError((onError) {
        debugPrint(onError.toString());
        return "${Constants.mensajeErrorSendSMS} : ${onError.toString()}";
      });
      toastInfo(result);
    } else {
      toastInfo(Constants.mensajeCantSendSMS);
    }
  }
}
