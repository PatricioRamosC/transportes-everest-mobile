import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:transportes_everest_mobile/providers/screens_provider.dart';

class ApiServiceDio {
  final String baseUrl;
  final ScreensProvider requestState;
  late final Dio _dio;
  final secureStorage = const FlutterSecureStorage();
  GlobalKey<NavigatorState> navigatorKey;
  //smithalejandro822@gmail.com
  ApiServiceDio(
      {required this.baseUrl,
      required this.requestState,
      required this.navigatorKey}) {
    // const String fingerprint =
    //     'ee5ce1dfa7a53657c545c62b65802e4272878dabd65c0aadcf85783ebb0b4d5c';
    _dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 10)));
    _dio.httpClientAdapter = IOHttpClientAdapter(createHttpClient: () {
      final HttpClient client =
          HttpClient(context: SecurityContext(withTrustedRoots: false));
      client.badCertificateCallback = (cert, host, port) {
        debugPrint("Certificado autofirmado permitido para $host:$port");
        return true; // Permitir el certificado autofirmado
      };
      return client;
    });

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        //debugPrint('interceptors - onRequest');
        options.headers['Content-Type'] = 'application/json';
        String? accessToken = await getAccessToken();
        if (accessToken != null) {
          debugPrint('Fijando el accessToken');
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        requestState.setLoading(true);
        showLoadingSpinner();
        return handler.next(options);
      },
      onResponse: (response, handler) {
        //debugPrint('interceptors - onResponse');
        requestState.setLoading(false);
        hideLoadingSpinner();
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        debugPrint('interceptors - onError ${error.toString()}');
        requestState.setLoading(false);
        hideLoadingSpinner();
        return handler.next(error);
      },
    ));
  }

  void showLoadingSpinner() {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible:
          false, // Evita que el usuario lo cierre tocando fuera del Dialog
      builder: (BuildContext context) {
        return const PopScope<Object?>(
          canPop: false,
          child: Center(
            child:
                CircularProgressIndicator(), // O cualquier spinner personalizado
          ),
        );
      },
    );
  }

  void hideLoadingSpinner() {
    if (navigatorKey.currentContext != null) {
      Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();
    }
  }

  Future<Response?> get(
      String url, Map<String, dynamic>? queryParameters) async {
    try {
      return await _dio.get(baseUrl + url, queryParameters: queryParameters);
    } on Exception catch (_, ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<Response?> post(
      String url, Object? data, Map<String, dynamic>? queryParameters) async {
    try {
      debugPrint('URL $baseUrl$url');
      debugPrint('data $data');
      return await _dio.post(baseUrl + url,
          data: data, queryParameters: queryParameters);
    } on Exception catch (_, ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<Response?> put(
      String url, Object? data, Map<String, dynamic>? queryParameters) async {
    try {
      debugPrint('URL $baseUrl$url');
      debugPrint('data $data');
      return await _dio.put(baseUrl + url,
          data: data, queryParameters: queryParameters);
    } on Exception catch (_, ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<void> storeLoginData(String accessToken, String tokenID, String userID,
      String clientID) async {
    debugPrint('accessToken $accessToken');
    debugPrint('tokenID $tokenID');
    debugPrint('userID $userID');
    debugPrint('clientID $clientID');
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

  Future<dynamic> sendRequest({
    required String method,
    required String endpoint,
    String? params,
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    return null;
  }
}
