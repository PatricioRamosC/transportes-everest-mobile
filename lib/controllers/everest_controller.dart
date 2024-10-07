import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:transportes_everest_mobile/config/url.dart';
import 'package:transportes_everest_mobile/controllers/base_controller.dart';
import 'package:transportes_everest_mobile/entidades/menu_option.dart';
import 'package:transportes_everest_mobile/screens/everest.dart';
import 'package:transportes_everest_mobile/screens/vale.dart';

class EverestController extends BaseController {
  EverestController({required super.navigatorKey});

  Future<List<MenuOptionPayload?>?> fetchMenuOptions() async {
    List<MenuOptionPayload?>? options = List.empty();
    Response? response =
        await apiService.get("${UrlConstants.menuItemUrl}/mobile", null);
    if (response != null) {
      print(response.data);
      options = MenuOption.fromJson(response.data).payload;
    }
    return options;
  }

  // Método para seleccionar el widget adecuado basado en el widgetId
  Widget getWidgetById(String widgetId) {
    switch (widgetId) {
      case 'map':
      //return MapScreen(super.navigatorKey);
      case 'settings':
        return Vale(navigatorKey: super.navigatorKey);
      case 'profile':
        return Vale(navigatorKey: super.navigatorKey);
      default:
        return Everest(navigatorKey: super.navigatorKey); // Widget por defecto
    }
  }
}
