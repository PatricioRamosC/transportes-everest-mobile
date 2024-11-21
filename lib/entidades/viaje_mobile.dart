/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/ 
class ViajeMobilePayload {
    int? id;
    String? fechahorasolicitud;
    int? proximoDestinoId;
    String? proximoDestino;
    String? comunaProximoDestino;
    String? pasajero;
    String? destino;
    String? destinoComuna;
    String? phone;
    String? latitud;
    String? longitud;
    String? destinoLatitud;
    String? destinoLongitud;
    String? destinoRegion;
    String? region;

    ViajeMobilePayload({this.id, this.fechahorasolicitud, this.proximoDestinoId, this.proximoDestino, this.comunaProximoDestino, 
                      this.pasajero, this.destino, this.destinoComuna, this.phone,
                      this.latitud, this.longitud, this.destinoLatitud, this.destinoLongitud, this.destinoRegion, this.region}); 

    ViajeMobilePayload.fromJson(Map<String, dynamic> json) {
        id = json['id'];
        fechahorasolicitud = json['fecha_hora_solicitud'];
        proximoDestinoId = json['proximoDestinoId'];
        proximoDestino = json['proximoDestino'];
        comunaProximoDestino = json['comunaProximoDestino'];
        pasajero = json['pasajero'];
        destino = json['destino'];
        destinoComuna = json['destinoComuna'];
        phone = json['phone'];
        latitud = json['latitud'];
        longitud = json['longitud'];
        destinoLatitud = json['destinoLatitud'];
        destinoLongitud = json['destinoLongitud'];
        destinoRegion = json['destinoRegion'];
        region = json['region'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = {
          'id' : id,
          'fecha_hora_solicitud' : fechahorasolicitud,
          'proximoDestinoId' : proximoDestinoId,
          'proximoDestino' : proximoDestino,
          'comunaProximoDestino' : comunaProximoDestino,
          'pasajero' : pasajero,
          'destino' : destino,
          'destinoComuna' : destinoComuna,
          'phone' : phone,
          'latitud' : latitud,
          'longitud' : longitud,
          'region' : region,
          'destinoLatitud' : destinoLatitud,
          'destinoLongitud' : destinoLongitud,
          'destinoRegion' : destinoRegion,
        };
        return data;
    }
}

class ViajeMobile {
    String? message;
    int? errorcode;
    List<ViajeMobilePayload?>? payload;

    ViajeMobile({this.message, this.errorcode, this.payload}); 

    ViajeMobile.fromJson(Map<String, dynamic> json) {
        message = json['message'];
        errorcode = json['error_code'];
        if (json['payload'] != null) {
         payload = <ViajeMobilePayload>[];
         json['payload'].forEach((v) {
         payload!.add(ViajeMobilePayload.fromJson(v));
        });
      }
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = {
          'message' : message,
          'error_code' : errorcode,
          'payload' : payload?.map((v) => v?.toJson()).toList(),
        };
        return data;
    }
}

