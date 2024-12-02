import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:transportes_everest_mobile/config/constants.dart';
import 'package:transportes_everest_mobile/controllers/base_controller.dart';
import 'package:transportes_everest_mobile/entidades/login/login.dart';
import '../config/url.dart';

class LoginController extends BaseController {
  LoginController({required super.navigatorKey});

  Future<bool> login(String userCode, String password) async {
    try {
      var body = json.encode({"email": userCode, "password": password});
      // HttpResponseData response =
      //     await apiService.post(endpoint: UrlConstants.loginUrl, body: body);
      Response? response =
          await apiService.post(UrlConstants.loginUrl, body, null);

      debugPrint('statusCode');
      debugPrint(response?.statusCode.toString());
      // debugPrint(response?.extra.toString());
      // debugPrint(response?.data);
      if (response?.statusCode == 200) {
        Login login = Login.fromJson(response?.data ?? '{}');
        debugPrint(login.toString());
        apiService.storeLoginData(
            login.payload?.accessToken ?? '',
            login.payload?.accessToken ?? '',
            login.payload?.userId.toString() ?? '',
            login.payload?.clientId ?? '');
        apiService.setKeyValue('login', userCode);
        return true;
      } else if (response?.statusCode == 204) {
        utils.toastInfo(Constants.mensajeNotFound);
      } else if (response != null) {
        utils.toastErrorJson(response.data ?? '');
      } else {
        utils.toastError('Falla en el Login');
      }
    } on DioException catch (e) {
      debugPrint('Login DioException');
      debugPrint(e.toString());
      utils.toastError(e.message ?? '');
    }
    return false;
  }

  Future<String?> getLogin() async {
    return await apiService.getKeyStorage('login');
  }

}
