class TipoDeUso {
  int id = 0;
  String tipoDeUso = '';

  TipoDeUso({required this.id, required this.tipoDeUso});

  TipoDeUso.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tipoDeUso = json['tipoDeUso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tipoDeUso'] = this.tipoDeUso;
    return data;
  }
}
