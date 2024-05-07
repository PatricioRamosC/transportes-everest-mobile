import 'dart:convert';

import '../viaje.dart';

class ViajesPendientes {
  String? message;
  List<Viaje>? payload;

  ViajesPendientes({this.message, this.payload});

  @override
  String toString() {
    return 'ViajesPendientes(message: $message, payload: $payload)';
  }

  factory ViajesPendientes.fromMap(Map<String, dynamic> data) {
    return ViajesPendientes(
      message: data['message'] as String?,
      payload: (data['payload'] as List<dynamic>?)
          ?.map((e) => Viaje.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'message': message,
        'payload': payload?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ViajesPendientes].
  factory ViajesPendientes.fromJson(String data) {
    return ViajesPendientes.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ViajesPendientes] to a JSON string.
  String toJson() => json.encode(toMap());

  ViajesPendientes copyWith({
    String? message,
    List<Viaje>? payload,
  }) {
    return ViajesPendientes(
      message: message ?? this.message,
      payload: payload ?? this.payload,
    );
  }
}
