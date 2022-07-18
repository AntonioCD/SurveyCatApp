class OrigenTierra {
  int id = 0;
  String descripcion = '';

  OrigenTierra({required this.id, required this.descripcion});

  OrigenTierra.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descripcion = json['descripcion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descripcion'] = this.descripcion;
    return data;
  }
}
