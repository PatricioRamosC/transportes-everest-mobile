import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;
  final http.Client client;

  ApiService({required this.baseUrl, required this.client});

  Future<http.Response> _handleRequest(
      http.Request request, Duration timeout) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Agregar token de acceso a los encabezados si está disponible
    String? accessToken = prefs.getString('access_token');
    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    } else {
      debugPrint('Sin token');
    }
    request.headers['Content-Type'] = 'application/json';

    // Puedes agregar más configuraciones aquí si es necesario, como API-Key
    return client.send(request).timeout(timeout).then(http.Response.fromStream);
  }

  Future<dynamic> sendRequest({
    required String method,
    required String endpoint,
    String? params,
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    http.Request request = http.Request(method, Uri.parse('$baseUrl$endpoint'));
    if (params != null) {
      request.body = params;
    }
    request.headers.addAll(headers ?? {});

    debugPrint(Uri.parse('$baseUrl$endpoint').toString());
    debugPrint("body request : ${request.body}");

    return await _handleRequest(request, timeout);
  }

  // Cerrar la conexión del cliente cuando ya no sea necesaria
  void close() {
    client.close();
  }
}
