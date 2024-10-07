import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transportes_everest_mobile/config/url.dart';
import 'package:transportes_everest_mobile/providers/screens_provider.dart';
// import 'package:transportes_everest_mobile/services/api_service.dart';
import 'package:transportes_everest_mobile/utils/utils.dart';
import '../services/api_service_dio.dart';

class BaseController {
  late final ApiServiceDio apiService;
  Utils utils = Utils();
  final GlobalKey<NavigatorState> navigatorKey;

  BaseController({required this.navigatorKey}) {
    print('Inicio BaseController...');
    // _createHttpClient()
    // sslClient().then((client) {
    //   print('Dentro del createHttpClient');
    //   print(client);
    //   apiService = ApiService(baseUrl: UrlConstants.baseUrl, client: client);
    // });
    apiService = ApiServiceDio(
        baseUrl: UrlConstants.baseUrl,
        requestState: ScreensProvider(),
        navigatorKey: navigatorKey);
  }

  /*
  Future<HttpClient> _createHttpClient() async {
    SecurityContext context = SecurityContext();
    List<int> certificateData = await loadCertificate();
    context.setTrustedCertificatesBytes(certificateData);
    HttpClient client = HttpClient(context: context);
    debug('Creando el httpClient con el certificado');
    return client;
  }
  */

  Future<List<int>> loadCertificate() async {
    final data = await rootBundle.load('assets/localhost.pem');
    return data.buffer.asUint8List();
  }

  Future<HttpClient> sslClient() async {
    final sslCert = await rootBundle.load('assets/localhost.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());

    HttpClient client = HttpClient(context: securityContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    return client;
    // IOClient ioClient = IOClient(client);
    // return ioClient;
  }

  void debug(String msg) {
    debugPrint("DEBUG: $msg");
  }
}
