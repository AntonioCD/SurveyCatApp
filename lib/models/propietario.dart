import 'dart:ffi';

import 'CatPersonaNatural.dart';

class Propietario {
  int id = 0;
  String codPar = '';
  String codEnc = '';
  String ruc = '';
  String relaxParcelas = '';
  double numComDerecho = 0.0;
  bool presentaDocum = false;
  String codDocum = '';
  String autorNotario = '';
  DateTime fechaDocum = DateTime.now();
  double areaTitulada = 0.0;
  String uniMed = '';
  String aFavorDe = '';
  String relaxPoseedor = '';
  DateTime fechaAdquisicion = DateTime.now();
  DateTime registroFecha = DateTime.now();
  String registroNumFinca = '';
  String registroTomo = '';
  String registroFolio = '';
  String registroAsiento = '';
  String cedula = '';
  double difAreasRP = 0.0;
  double difAreasDocLegal = 0.0;
  String expVinculo = '';
  CatPersonaNatural catPersonaNatural = CatPersonaNatural(
      id: 0,
      codPar: '',
      codEnc: '',
      nombre1: '',
      nombre2: '',
      apellido1: '',
      apellido2: '',
      genero: '',
      cedula: '',
      edad: 0,
      codDep: '',
      codMun: '',
      codBar: '',
      domicilio: '',
      nombreCompleto: '',
      desmovilizado: 0,
      descSectorReformado: '',
      retirado: 0,
      campesinoTradicional: 0,
      otros: 0,
      idColectivo: 0,
      objNacionalidadID: 0,
      estadoCivil: '',
      objProfesionID: 0,
      esPareja: false,
      indicadorPareja: 0,
      cantHijosF: 0,
      cantHijosM: 0,
      codCaserio: 0,
      barrio: '',
      comarca: '',
      caserio: '',
      profesion: '');

  Propietario(
      {required this.id,
      required this.codPar,
      required this.codEnc,
      required this.ruc,
      required this.relaxParcelas,
      required this.numComDerecho,
      required this.presentaDocum,
      required this.codDocum,
      required this.autorNotario,
      required this.fechaDocum,
      required this.areaTitulada,
      required this.uniMed,
      required this.aFavorDe,
      required this.relaxPoseedor,
      required this.fechaAdquisicion,
      required this.registroFecha,
      required this.registroNumFinca,
      required this.registroTomo,
      required this.registroFolio,
      required this.registroAsiento,
      required this.cedula,
      required this.difAreasRP,
      required this.difAreasDocLegal,
      required this.expVinculo,
      required this.catPersonaNatural});

  Propietario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codPar = json['codPar'];
    codEnc = json['codEnc'];
    ruc = json['ruc'];
    relaxParcelas = json['relax_Parcelas'];
    numComDerecho = json['numComDerecho'];
    presentaDocum = json['presentaDocum'];
    codDocum = json['codDocum'];
    autorNotario = json['autorNotario'];
    fechaDocum = json['fechaDocum'];
    areaTitulada = json['areaTitulada'];
    uniMed = json['uniMed'];
    aFavorDe = json['aFavorDe'];
    relaxPoseedor = json['relax_Poseedor'];
    fechaAdquisicion = json['fechaAdquisicion'];
    registroFecha = json['registroFecha'];
    registroNumFinca = json['registroNumFinca'];
    registroTomo = json['registroTomo'];
    registroFolio = json['registroFolio'];
    registroAsiento = json['registroAsiento'];
    cedula = json['cedula'];
    difAreasRP = json['difAreasRP'];
    difAreasDocLegal = json['difAreasDocLegal'];
    expVinculo = json['expVinculo'];
    catPersonaNatural = CatPersonaNatural.fromJson(json['catPersonaNatural']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['codPar'] = this.codPar;
    data['codEnc'] = this.codEnc;
    data['ruc'] = this.ruc;
    data['relax_Parcelas'] = this.relaxParcelas;
    data['numComDerecho'] = this.numComDerecho;
    data['presentaDocum'] = this.presentaDocum;
    data['codDocum'] = this.codDocum;
    data['autorNotario'] = this.autorNotario;
    data['fechaDocum'] = this.fechaDocum;
    data['areaTitulada'] = this.areaTitulada;
    data['uniMed'] = this.uniMed;
    data['aFavorDe'] = this.aFavorDe;
    data['relax_Poseedor'] = this.relaxPoseedor;
    data['fechaAdquisicion'] = this.fechaAdquisicion;
    data['registroFecha'] = this.registroFecha;
    data['registroNumFinca'] = this.registroNumFinca;
    data['registroTomo'] = this.registroTomo;
    data['registroFolio'] = this.registroFolio;
    data['registroAsiento'] = this.registroAsiento;
    data['cedula'] = this.cedula;
    data['difAreasRP'] = this.difAreasRP;
    data['difAreasDocLegal'] = this.difAreasDocLegal;
    data['expVinculo'] = this.expVinculo;
    data['catPersonaNatural'] = this.catPersonaNatural.toJson();
    return data;
  }
}
