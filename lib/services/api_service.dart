import 'dart:io';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:transportes_everest_mobile/entidades/response/http_response_data.dart';
import '../config/url.dart';

class ApiService {
  final String baseUrl;
  final HttpClient client;
  final secureStorage = const FlutterSecureStorage();

  ApiService({required this.baseUrl, required this.client});

  /*
  Future<http.StreamedResponse> _handleRequest(
    HttpClientRequest request,
    Duration timeout,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Agregar token de acceso a los encabezados si está disponible
    String? accessToken = prefs.getString('access_token');
    request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    if (accessToken != null) {
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $accessToken');
    } else {
      debugPrint('Sin token');
    }

    // Puedes agregar más configuraciones aquí si es necesario, como API-Key
    HttpClientResponse response = await request.close().timeout(timeout);

    // Convertir HttpClientResponse a http.StreamedResponse
    http.StreamedResponse streamedResponse = http.StreamedResponse(
      response.stream,
      response.statusCode,
      headers: response.headers,
      reasonPhrase: response.reasonPhrase,
      contentLength: response.contentLength,
    );

    return streamedResponse;
  }
  */

  Future<dynamic> sendRequest({
    required String method,
    required String endpoint,
    String? params,
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    Uri uri = Uri.parse(UrlConstants.baseUrl + endpoint);
    print('URI: ${uri.toString()}');
    HttpClientRequest request;

    if (method.toLowerCase().trim() == "get") {
      request = await client.get(uri.host, uri.port, uri.path);
    } else if (method.toLowerCase().trim() == "post") {
      request = await client.post(uri.host, uri.port, uri.path);
    } else {
      return null;
    }
    if (headers != null) {
      headers.forEach((key, value) {
        request.headers.set(key, value);
      });
    }
    if (method.toLowerCase().trim() == "post") {
      request.write('hola');
    }
    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      String respuesta = await response.transform(utf8.decoder).join();
      return respuesta;
    } else {
      print('statusCode : ${response.statusCode}');
    }

    return null;
  }

  Future<dynamic> get({
    required String endpoint,
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    Uri uri = Uri.parse(UrlConstants.baseUrl + endpoint);
    print('URI: ${uri.toString()}');
    HttpClientRequest request = await client.get(uri.host, uri.port, uri.path);

    if (headers != null) {
      headers.forEach((key, value) {
        request.headers.set(key, value);
      });
    }
    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      String respuesta = await response.transform(utf8.decoder).join();
      return respuesta;
    } else {
      print('statusCode : ${response.statusCode}');
    }

    return null;
  }

  Future<HttpResponseData> post({
    required String endpoint,
    dynamic body,
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    Uri uri = Uri.parse(UrlConstants.baseUrl + endpoint);
    print('URI: ${uri.toString()}');
    HttpClientRequest request = await client.postUrl(uri);

    if (headers != null) {
      headers.forEach((key, value) {
        request.headers.set(key, value);
      });
    }
    await setHeaders(request);
    print('request.headers');
    print(request.headers);
    print('body');
    print(body);
    request.write(body);
    HttpClientResponse response = await request.close();
    return (await handleResponse(response));
  }

  Future<HttpResponseData> handleResponse(HttpClientResponse response) async {
    var contentType = response.headers.contentType;
    HttpResponseData responseData = HttpResponseData(
        responseType: ResponseType.unknown, statusCode: response.statusCode);

    if (contentType != null) {
      print('Content-Type: ${contentType.mimeType}');
      if (contentType.mimeType == 'application/json') {
        var json = await response.transform(const Utf8Decoder()).join();
        responseData.setJsonResponse(json);
        print('JSON recibido: $json');
      } else if (contentType.mimeType == 'text/html') {
        var html = await response.transform(const Utf8Decoder()).join();
        responseData.setHtmlResponse(html);
        print('HTML recibido: $html');
      } else if (contentType.mimeType.startsWith('image/')) {
        var image = await response.fold<List<int>>([], (a, b) => a..addAll(b));
        responseData.setImageResponse(image);
        print('Imagen recibida con ${image.length} bytes');
      } else if (contentType.mimeType == 'multipart/form-data') {
        var boundary = contentType.parameters['boundary'];
        if (boundary != null) {
          print('Boundary detectado: $boundary');
          responseData.setMultipartResponse(
              await processMultipartResponse(response, boundary));
        } else {
          print('No se pudo encontrar el boundary en el Content-Type');
        }
      } else {
        print('Tipo de contenido no manejado: ${contentType.mimeType}');
      }
    } else {
      print('No se pudo determinar el Content-Type.');
    }
    return responseData;
  }

  Future<Map<String, dynamic>> processMultipartResponse(
      HttpClientResponse response, String boundary) async {
    var bodyBytes = await response.fold<List<int>>([], (a, b) => a..addAll(b));
    var body = utf8.decode(bodyBytes);
    var parts = body
        .split('--$boundary')
        .where((part) => part.trim().isNotEmpty)
        .toList();
    Map<String, dynamic> parsedData = {};
    // Procesar cada parte
    for (var part in parts) {
      // Dividir los encabezados del contenido (separados por dos saltos de línea)
      var splitPart = part.split('\r\n\r\n');
      if (splitPart.length < 2) {
        continue; // No es válido si no hay encabezados y contenido
      }
      var headers = splitPart[0];
      var content = splitPart[1].trim();

      // Extraer el encabezado Content-Disposition para obtener el nombre del campo
      var contentDisposition = RegExp(
              r'Content-Disposition: form-data; name="(.+?)"(; filename="(.+?)")?')
          .firstMatch(headers);

      if (contentDisposition != null) {
        var fieldName = contentDisposition.group(1);
        var fileName = contentDisposition.group(3);

        // Si es un archivo (tiene filename), guardamos el contenido como bytes
        if (fileName != null) {
          print('Archivo detectado: $fileName');
          var fileBytes =
              utf8.encode(content); // Puedes procesarlo directamente como bytes

          // Guardar el archivo en el mapa
          if (fieldName != null) {
            parsedData[fieldName] = {
              'fileName': fileName,
              'fileBytes': fileBytes,
            };
          }
        } else {
          print('Campo de formulario detectado: $fieldName');
          if (fieldName != null) {
            parsedData[fieldName] = content; // Guardamos el valor del campo
          }
        }
      }
    }
    return parsedData;
  }

  Future<void> storeLoginData(String accessToken, String tokenID, String userID,
      String clientID) async {
    await secureStorage.write(key: 'accessToken', value: accessToken);
    await secureStorage.write(key: 'tokenID', value: tokenID);
    await secureStorage.write(key: 'userID', value: userID);
    await secureStorage.write(key: 'clientID', value: clientID);
  }

  Future<String?> getAccessToken() async {
    return await getKeyStorage('accessToken');
  }

  Future<String?> getKeyStorage(String key) async {
    return await secureStorage.read(key: key);
  }

  Future<void> setHeaders(HttpClientRequest request) async {
    request.headers.set('Content-Type', 'application/json');
    String? token = await getAccessToken();
    if (token != null) {
      request.headers.set('Authorization', 'Bearer : $token');
    }
  }

  // Cerrar la conexión del cliente cuando ya no sea necesaria
  void close() {
    client.close();
  }
}
