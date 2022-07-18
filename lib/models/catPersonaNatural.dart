import 'package:surveycat_app/models/propietario.dart';

class CatPersonaNatural {
  int id = 0;
  String codPar = '';
  String codEnc = '';
  String nombre1 = '';
  String nombre2 = '';
  String apellido1 = '';
  String apellido2 = '';
  String genero = '';
  String cedula = '';
  int edad = 0;
  String codDep = '';
  String codMun = '';
  String codBar = '';
  String domicilio = '';
  String nombreCompleto = '';
  int desmovilizado = 0;
  String descSectorReformado = '';
  int retirado = 0;
  int campesinoTradicional = 0;
  int otros = 0;
  int idColectivo = 0;
  int objNacionalidadID = 0;
  String estadoCivil = '';
  int objProfesionID = 0;
  bool esPareja = false;
  int indicadorPareja = 0;
  int cantHijosF = 0;
  int cantHijosM = 0;
  int codCaserio = 0;
  String barrio = '';
  String comarca = '';
  String caserio = '';
  String profesion = '';

  /*  Propietario propietario = Propietario(
      id: 0,
      codPar: '',
      codEnc: '',
      ruc: '',
      relaxParcelas: '',
      numComDerecho: 0.0,
      presentaDocum: false,
      codDocum: '',
      autorNotario: '',
      fechaDocum: DateTime.now(),
      areaTitulada: 0.0,
      uniMed: '',
      aFavorDe: '',
      relaxPoseedor: '',
      fechaAdquisicion: DateTime.now(),
      registroFecha: DateTime.now(),
      registroNumFinca: '',
      registroTomo: '',
      registroFolio: '',
      registroAsiento: '',
      cedula: '',
      difAreasRP: 0.0,
      difAreasDocLegal: 0.0,
      expVinculo: ''); */

  CatPersonaNatural(
      {required this.id,
      required this.codPar,
      required this.codEnc,
      required this.nombre1,
      required this.nombre2,
      required this.apellido1,
      required this.apellido2,
      required this.genero,
      required this.cedula,
      required this.edad,
      required this.codDep,
      required this.codMun,
      required this.codBar,
      required this.domicilio,
      required this.nombreCompleto,
      required this.desmovilizado,
      required this.descSectorReformado,
      required this.retirado,
      required this.campesinoTradicional,
      required this.otros,
      required this.idColectivo,
      required this.objNacionalidadID,
      required this.estadoCivil,
      required this.objProfesionID,
      required this.esPareja,
      required this.indicadorPareja,
      required this.cantHijosF,
      required this.cantHijosM,
      required this.codCaserio,
      required this.barrio,
      required this.comarca,
      required this.caserio,
      required this.profesion});

  CatPersonaNatural.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codPar = json['codPar'];
    codEnc = json['codEnc'];
    nombre1 = json['nombre1'];
    nombre2 = json['nombre2'];
    apellido1 = json['apellido1'];
    apellido2 = json['apellido2'];
    genero = json['genero'];
    cedula = json['cedula'];
    edad = json['edad'];
    codDep = json['cod_Dep'];
    codMun = json['cod_Mun'];
    codBar = json['cod_Bar'];
    domicilio = json['domicilio'];
    nombreCompleto = json['nombreCompleto'];
    desmovilizado = json['desmovilizado'];
    descSectorReformado = json['descSectorReformado'];
    retirado = json['retirado'];
    campesinoTradicional = json['campesinoTradicional'];
    otros = json['otros'];
    idColectivo = json['idColectivo'];
    objNacionalidadID = json['objNacionalidadID'];
    estadoCivil = json['estadoCivil'];
    objProfesionID = json['objProfesionID'];
    esPareja = json['esPareja'];
    indicadorPareja = json['indicadorPareja'];
    cantHijosF = json['cantHijosF'];
    cantHijosM = json['cantHijosM'];
    codCaserio = json['codCaserio'];
    barrio = json['barrio'];
    comarca = json['comarca'];
    caserio = json['caserio'];
    profesion = json['profesion'];
    //propietario = Propietario.fromJson(json['propietario']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['codPar'] = this.codPar;
    data['codEnc'] = this.codEnc;
    data['nombre1'] = this.nombre1;
    data['nombre2'] = this.nombre2;
    data['apellido1'] = this.apellido1;
    data['apellido2'] = this.apellido2;
    data['genero'] = this.genero;
    data['cedula'] = this.cedula;
    data['edad'] = this.edad;
    data['cod_Dep'] = this.codDep;
    data['cod_Mun'] = this.codMun;
    data['cod_Bar'] = this.codBar;
    data['domicilio'] = this.domicilio;
    data['nombreCompleto'] = this.nombreCompleto;
    data['desmovilizado'] = this.desmovilizado;
    data['descSectorReformado'] = this.descSectorReformado;
    data['retirado'] = this.retirado;
    data['campesinoTradicional'] = this.campesinoTradicional;
    data['otros'] = this.otros;
    data['idColectivo'] = this.idColectivo;
    data['objNacionalidadID'] = this.objNacionalidadID;
    data['estadoCivil'] = this.estadoCivil;
    data['objProfesionID'] = this.objProfesionID;
    data['esPareja'] = this.esPareja;
    data['indicadorPareja'] = this.indicadorPareja;
    data['cantHijosF'] = this.cantHijosF;
    data['cantHijosM'] = this.cantHijosM;
    data['codCaserio'] = this.codCaserio;
    data['barrio'] = this.barrio;
    data['comarca'] = this.comarca;
    data['caserio'] = this.caserio;
    data['profesion'] = this.profesion;
    //data['propietario'] = this.propietario.toJson();
    return data;
  }
}
