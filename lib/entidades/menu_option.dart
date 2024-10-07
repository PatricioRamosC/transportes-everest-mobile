import 'package:flutter/material.dart';

/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
class MenuOptionPayload {
  int? id;
  String? optionName;
  String? widgetName;
  String? iconName;

  MenuOptionPayload({this.id, this.optionName, this.widgetName, this.iconName});

  MenuOptionPayload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    optionName = json['option_name'];
    widgetName = json['route_name'];
    iconName = json['icon_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'option_name': optionName,
      'route_name': widgetName,
      'icon_name': iconName
    };
    return data;
  }

  // Método para obtener el ícono dinámicamente basado en el nombre
  IconData getIconData() {
    switch (iconName) {
      case 'home':
        return Icons.home;
      case 'settings':
        return Icons.settings;
      case 'account_circle':
        return Icons.account_circle;
      case 'directions_car':
        return Icons.directions_car;
      default:
        return Icons.help; // Ícono por defecto
    }
  }
}

class MenuOption {
  String? message;
  int? errorCode;
  List<MenuOptionPayload?>? payload;

  MenuOption({this.message, this.errorCode, this.payload});

  MenuOption.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    errorCode = json['error_code'];
    if (json['payload'] != null) {
      payload = <MenuOptionPayload>[];
      json['payload'].forEach((v) {
        payload!.add(MenuOptionPayload.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'message': message,
      'error_code': errorCode,
      'payload': (payload?.map((v) => v?.toJson()).toList())
    };
    return data;
  }
}
