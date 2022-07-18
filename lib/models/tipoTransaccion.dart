class TipoTransaccion {
  int idTipoTransaccion = 0;
  String descripcion = '';

  TipoTransaccion({required this.idTipoTransaccion, required this.descripcion});

  TipoTransaccion.fromJson(Map<String, dynamic> json) {
    idTipoTransaccion = json['idTipoTransaccion'];
    descripcion = json['descripcion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idTipoTransaccion'] = idTipoTransaccion;
    data['descripcion'] = descripcion;
    return data;
  }
}
