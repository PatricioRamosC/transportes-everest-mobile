/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
class LoginOK {
  String? accessToken;
  Token? token;

  LoginOK({this.accessToken, this.token});

  LoginOK.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    token = json['token'] != null ? Token?.fromJson(json['token']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['accessToken'] = accessToken;
    data['token'] = token!.toJson();
    return data;
  }
}

class Token {
  String? id;
  int? userid;
  String? clientid;
  String? name;
  bool? revoked;
  DateTime? createdat;
  DateTime? updatedat;
  DateTime? expiresat;

  Token(
      {this.id,
      this.userid,
      this.clientid,
      this.name,
      this.revoked,
      this.createdat,
      this.updatedat,
      this.expiresat});

  Token.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['user_id'];
    clientid = json['client_id'];
    name = json['name'];
    revoked = json['revoked'];
    createdat = json['created_at'];
    updatedat = json['updated_at'];
    expiresat = json['expires_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userid;
    data['client_id'] = clientid;
    data['name'] = name;
    data['revoked'] = revoked;
    data['created_at'] = createdat;
    data['updated_at'] = updatedat;
    data['expires_at'] = expiresat;
    return data;
  }
}
