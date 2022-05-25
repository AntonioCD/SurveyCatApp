import 'package:surveycat_app/models/catPersonaNatural.dart';
import 'package:surveycat_app/models/propietario.dart';

class Parcela {
  int id = 0;
  String codEnc = '';
  double areaEstimada = 0;
  bool presentaConflicto = false;
  String fechaEnc = '';
  List<CatPersonaNatural> catPersonasNaturales = [];

  Parcela(
      {required this.id,
      required this.codEnc,
      required this.areaEstimada,
      required this.presentaConflicto,
      required this.fechaEnc,
      required this.catPersonasNaturales});

  Parcela.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codEnc = json['codEnc'];
    areaEstimada = _checkDouble(json['areaEstimada']);
    presentaConflicto = json['presenta_Conflicto'];
    fechaEnc = json['fecha_Enc'];
    if (json['catPersonasNaturales'] != null) {
      catPersonasNaturales = [];
      json['catPersonasNaturales'].forEach((v) {
        catPersonasNaturales.add(new CatPersonaNatural.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['codEnc'] = codEnc;
    data['areaEstimada'] = this.areaEstimada;
    data['presenta_Conflicto'] = this.presentaConflicto;
    data['fecha_Enc'] = this.fechaEnc;
    data['catPersonasNaturales'] =
        this.catPersonasNaturales.map((v) => v.toJson()).toList();
    return data;
  }

  static double _checkDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else {
      return value;
    }
  }
}
