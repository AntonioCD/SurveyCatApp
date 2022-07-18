// ignore_for_file: non_constant_identifier_names

class HistorialParcela {
  int? id = 0;
  String codPar = '';
  String codEnc = '';
  String? sucesor = '';
  String? anterior = '';
  String? tipoTrans = '';
  String? docTrans = '';
  DateTime? fechaTransaccion = DateTime.now();
  String? anio_Transaccion = '';

  HistorialParcela(
      {this.id,
      required this.codPar,
      required this.codEnc,
      this.sucesor,
      this.anterior,
      this.tipoTrans,
      this.docTrans,
      this.fechaTransaccion,
      this.anio_Transaccion});

  HistorialParcela.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codPar = json['codPar'];
    codEnc = json['codEnc'];
    sucesor = json['sucesor'];
    anterior = json['anterior'];
    tipoTrans = json['tipoTrans'];
    docTrans = json['docTrans'];
    fechaTransaccion = json['fechaTransaccion'];
    anio_Transaccion = json['anio_Transaccion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['codPar'] = codPar;
    data['codEnc'] = codEnc;
    data['sucesor'] = sucesor;
    data['anterior'] = anterior;
    data['tipoTrans'] = tipoTrans;
    data['docTrans'] = docTrans;
    data['fechaTransaccion'] = fechaTransaccion;
    data['anio_Transaccion'] = anio_Transaccion;
    return data;
  }
}
