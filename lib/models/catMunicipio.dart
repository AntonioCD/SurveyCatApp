class CatMunicipio {
  String codMun = '';
  String municipio = '';
  String codDep = '';

  CatMunicipio(
      {
      required this.codMun,
      required this.municipio,
      required this.codDep});

  CatMunicipio.fromJson(Map<String, dynamic> json) {
    codMun = json['codMun'];
    municipio = json['municipio'];
    codDep = json['codDep'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codMun'] = this.codMun;
    data['municipio'] = this.municipio;
     data['codDep'] = this.codDep;
    return data;
  }
}