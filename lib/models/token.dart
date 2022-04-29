import 'package:surveycat_app/models/user.dart';

class Token {
  String token = '';
  String expiration = '';
  User user = User(
      nombres: '',
      apellidos: '',
      identificacion: '',
      countryCode: '',
      imageId: '',
      imageFullPath: '',
      userType: 0,
      fullName: '',
      parcelasCount: 0,
      id: '',
      userName: '',
      email: '',
      phoneNumber: '');

  Token({required this.token, required this.expiration, required this.user});

  Token.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiration = json['expiration'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = token;
    data['expiration'] = expiration;
    data['user'] = user.toJson();

    return data;
  }
}
