// ignore: file_names
class CatPersonaJuridica {
  String? codPar;
  String codEnc = '';
  String? razonSocial;
  String? tipoPersJurid;
  int? numSocios;
  int? numSocias;
  String ruc = '';
  String? lugardeRegistro;
  DateTime? fechaRegistro;
  String? codDep;
  String? codMun;
  String? codBarrio;
  String? direccion;
  int? objNacionalidadID;
  int? codCaserio;
  String? barrio;
  String? comarca;
  String? caserio;

  CatPersonaJuridica(
      {this.codPar,
      required this.codEnc,
      this.razonSocial,
      this.tipoPersJurid,
      this.numSocios,
      this.numSocias,
      required this.ruc,
      this.lugardeRegistro,
      this.fechaRegistro,
      this.codDep,
      this.codMun,
      this.codBarrio,
      this.direccion,
      this.objNacionalidadID,
      this.codCaserio,
      this.barrio,
      this.comarca,
      this.caserio});

  CatPersonaJuridica.fromJson(Map<String, dynamic> json) {
    codPar = json['codPar'];
    codEnc = json['codEnc'];
    razonSocial = json['razonSocial'];
    tipoPersJurid = json['tipoPersJurid'];
    numSocios = json['numSocios'];
    numSocias = json['numSocias'];
    ruc = json['ruc'];
    lugardeRegistro = json['lugardeRegistro'];
    fechaRegistro = json['fechaRegistro'];
    codDep = json['codDep'];
    codMun = json['codMun'];
    codBarrio = json['codBarrio'];
    direccion = json['direccion'];
    objNacionalidadID = json['objNacionalidadID'];
    codCaserio = json['codCaserio'];
    barrio = json['barrio'];
    comarca = json['comarca'];
    caserio = json['caserio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codPar'] = codPar;
    data['codEnc'] = codEnc;
    data['razonSocial'] = razonSocial;
    data['tipoPersJurid'] = tipoPersJurid;
    data['numSocios'] = numSocios;
    data['numSocias'] = numSocias;
    data['ruc'] = ruc;
    data['lugardeRegistro'] = lugardeRegistro;
    data['fechaRegistro'] = fechaRegistro;
    data['codDep'] = codDep;
    data['codMun'] = codMun;
    data['codBarrio'] = codBarrio;
    data['direccion'] = direccion;
    data['objNacionalidadID'] = objNacionalidadID;
    data['codCaserio'] = codCaserio;
    data['barrio'] = barrio;
    data['comarca'] = comarca;
    data['caserio'] = caserio;

    return data;
  }
}
