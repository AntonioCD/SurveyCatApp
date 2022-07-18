import 'dart:convert';

import 'package:surveycat_app/models/catPersonaNatural.dart';
import 'package:surveycat_app/models/propietario.dart';

class Parcela {
  int id = 0;
  String codEnc = '';
  String codPar = '';
  double areaEstimada = 0;
  bool? presentaConflicto = false;
  String fechaEnc = '';
  String id_informante = '';
  //List<CatPersonaNatural>? catPersonasNaturales;
  String userId = '';

  Parcela({
    required this.id,
    required this.codEnc,
    required this.codPar,
    required this.areaEstimada,
    required this.presentaConflicto,
    required this.fechaEnc,
    required this.id_informante,
    //required this.catPersonasNaturales,
    required this.userId,
  });

  String toRawJson() => json.encode(toJson());

  Parcela.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codEnc = json['codEnc'];
    codPar = json['codEnc'];
    areaEstimada = _checkDouble(json['areaEstimada']);
    presentaConflicto = json['presenta_Conflicto'];
    fechaEnc = json['fecha_Enc'];
    id_informante = json['id_informante'];
    /*  if (json['catPersonasNaturales'] != null) {
      catPersonasNaturales = [];
      json['catPersonasNaturales'].forEach((v) {
        catPersonasNaturales?.add(new CatPersonaNatural.fromJson(v));
      });
    } */
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['codEnc'] = codEnc;
    data['codPar'] = codEnc;
    data['areaEstimada'] = this.areaEstimada;
    data['presenta_Conflicto'] = this.presentaConflicto;
    data['fecha_Enc'] = this.fechaEnc;
    data['id_informante'] = this.id_informante;
    /*  data['catPersonasNaturales'] =
        catPersonasNaturales?.map((v) => v.toJson()).toList(); */
    data['userId'] = this.userId;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codEnc': codEnc,
      'codPar': codPar,
      'areaEstimada': areaEstimada,
      'presenta_conflicto': presentaConflicto,
      'fecha_Enc': fechaEnc,
      'id_informante': id_informante,
      'userId': userId
    };
  }

  static double _checkDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else {
      return value;
    }
  }
}
