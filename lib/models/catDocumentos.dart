class Cat_Documentos {
  String codDocum = '';
  String documento = '';
  bool inscribible = false;

  Cat_Documentos(
      {required this.codDocum,
      required this.documento,
      required this.inscribible});

  Cat_Documentos.fromJson(Map<String, dynamic> json) {
    codDocum = json['codDocum'];
    documento = json['documento'];
    inscribible = json['inscribible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codDocum'] = this.codDocum;
    data['documento'] = this.documento;
    data['inscribible'] = this.inscribible;
    return data;
  }
}
