class StbNacionalidad {
  int stbNacionalidadID = 0;
  String singularNac = '';

  StbNacionalidad({required this.stbNacionalidadID, required this.singularNac});

  StbNacionalidad.fromJson(Map<String, dynamic> json) {
    stbNacionalidadID = json['stbNacionalidadID'];
    singularNac = json['descripcion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stbNacionalidadID'] = this.stbNacionalidadID;
    data['singularNac'] = this.singularNac;
    return data;
  }
}
