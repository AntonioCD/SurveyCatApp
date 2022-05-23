import 'package:surveycat_app/models/parcela.dart';

class User {
  String? nombres = '';
  String? apellidos = '';
  String? identificacion = '';
  String? countryCode = '';
  String? imageId = '';
  String? imageFullPath = '';
  int? userType = 0;
  String? fullName = '';
  List<Parcela> parcelas = [];
  int? parcelasCount = 0;
  String id = '';
  String? userName = '';
  String? email = '';
  String? phoneNumber = '';

  User({
    required this.nombres,
    required this.apellidos,
    required this.identificacion,
    required this.countryCode,
    required this.imageId,
    required this.imageFullPath,
    required this.userType,
    required this.fullName,
    required this.parcelas,
    required this.parcelasCount,
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
  });

  User.fromJson(Map<String, dynamic> json) {
    nombres = json['nombres'];
    apellidos = json['apellidos'];
    identificacion = json['identificacion'];
    countryCode = json['countryCode'];
    imageId = json['imageId'];
    imageFullPath = json['imageFullPath'];
    userType = json['userType'];
    fullName = json['fullName'];
    if (json['parcelas'] != null) {
      parcelas = [];
      json['parcelas'].forEach((v) {
        parcelas.add(new Parcela.fromJson(v));
      });
    }
    parcelasCount = json['parcelasCount'];
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombres'] = nombres;
    data['apellidos'] = apellidos;
    data['identificacion'] = identificacion;
    data['countryCode'] = this.countryCode;
    data['imageId'] = this.imageId;
    data['imageFullPath'] = this.imageFullPath;
    data['userType'] = this.userType;
    data['fullName'] = this.fullName;
    data['parcelas'] = this.parcelas.map((v) => v.toJson()).toList();
    data['parcelasCount'] = this.parcelasCount;
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
