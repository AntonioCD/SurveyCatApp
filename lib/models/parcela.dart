class Parcela {
  int id = 0;
  String codEnc = '';
  double areaEstimada = 0;
  bool presentaConflicto = false;
  String fechaEnc = '';
  int propietariosCount = 0;

  Parcela(
      {required this.id,
      required this.codEnc,
      required this.areaEstimada,
      required this.presentaConflicto,
      required this.fechaEnc,
      required this.propietariosCount});

  Parcela.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codEnc = json['codEnc'];
    areaEstimada = json['areaEstimada'];
    presentaConflicto = json['presenta_Conflicto'];
    fechaEnc = json['fecha_Enc'];
    propietariosCount = json['propietariosCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['codEnc'] = codEnc;
    data['areaEstimada'] = this.areaEstimada;
    data['presenta_Conflicto'] = this.presentaConflicto;
    data['fecha_Enc'] = this.fechaEnc;
    data['propietariosCount'] = this.propietariosCount;
    return data;
  }
}
