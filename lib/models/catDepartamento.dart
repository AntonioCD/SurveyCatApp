import 'package:surveycat_app/models/catMunicipio.dart';

class CatDepartamento {
  String codDep = '';
  String departamento = '';
  List<CatMunicipio> municipios = [];

  CatDepartamento(
      {required this.codDep,
      required this.departamento,
      required this.municipios});

  CatDepartamento.fromJson(Map<String, dynamic> json) {
    codDep = json['codDep'];
    departamento = json['departamento'];
    if (json['municipios'] != null) {
      municipios = [];
      json['municipios'].forEach((v) {
        municipios.add(new CatMunicipio.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codDep'] = this.codDep;
    data['departamento'] = this.departamento;
    data['municipios'] = this.municipios;
    return data;
  }
}
