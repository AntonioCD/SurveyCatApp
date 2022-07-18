class CatUnidadDeMedida {
  int id = 0;
  String uniMed = '';
  String descripcion = '';

  CatUnidadDeMedida({
    required this.id, 
    required this.uniMed,
    required this.descripcion  
    });

  CatUnidadDeMedida.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uniMed = json['uniMed'];
    descripcion = json['descripcion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uniMed'] = this.uniMed;
    data['descripcion'] = this.descripcion;
    return data;
  }
}