import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transportes_everest_mobile/config/url.dart';
import 'package:transportes_everest_mobile/services/api_service.dart';
import 'package:transportes_everest_mobile/utils/utils.dart';

class BaseController {
  final ApiService apiService = ApiService(
    baseUrl: UrlConstants.baseUrl,
    client: http.Client(),
  );
  Utils utils = Utils();

  void debug(String msg) {
    debugPrint("DEBUG: $msg");
  }
}
