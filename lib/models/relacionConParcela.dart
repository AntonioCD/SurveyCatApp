class RelacionConParcela {
  int id = 0;
  String relacion = '';

  RelacionConParcela({required this.id, required this.relacion});

  RelacionConParcela.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relacion = json['relacion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['relacion'] = this.relacion;
    return data;
  }
}
