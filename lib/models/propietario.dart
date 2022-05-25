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
      required this.expVinculo});

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
    return data;
  }
}
