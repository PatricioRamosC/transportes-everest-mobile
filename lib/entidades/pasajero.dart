import 'usuario.dart';
import 'ubicacion.dart';

class Pasajero {
  int? id;
  int? viajeid;
  int? userid;
  int? ubicacionid;
  DateTime? createdat;
  DateTime? updatedat;
  Usuario? user;
  Ubicacion? ubicacion;

  Pasajero(
      {this.id,
      this.viajeid,
      this.userid,
      this.ubicacionid,
      this.createdat,
      this.updatedat,
      this.user,
      this.ubicacion});

  Pasajero.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    viajeid = json['viaje_id'];
    userid = json['user_id'];
    ubicacionid = json['ubicacion_id'];
    createdat = json['created_at'];
    updatedat = json['updated_at'];
    user = json['user'] != null ? Usuario?.fromJson(json['user']) : null;
    ubicacion = json['ubicacion'] != null
        ? Ubicacion?.fromJson(json['ubicacion'])
        : null;
  }

  // String toJson() => json.encode(toMap());

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = Map<String, dynamic>();
  //   data['id'] = id;
  //   data['viaje_id'] = viajeid;
  //   data['user_id'] = userid;
  //   data['ubicacion_id'] = ubicacionid;
  //   data['created_at'] = createdat;
  //   data['updated_at'] = updatedat;
  //   data['user'] = user!.toJson();
  //   data['ubicacion'] = ubicacion!.toJson();
  //   return data;
  // }
}
