import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:surveycat_app/helpers/databaseHelper.dart';
import 'package:surveycat_app/models/catDepartamento.dart';
import 'package:surveycat_app/models/catDocumentos.dart';
import 'package:surveycat_app/models/catEstadoCivil.dart';
import 'package:surveycat_app/models/catMunicipio.dart';
import 'package:surveycat_app/models/catPersonaJuridica.dart';
import 'package:surveycat_app/models/catPersonaNatural.dart';
import 'package:surveycat_app/models/catServidumbre.dart';
import 'package:surveycat_app/models/catUniMed.dart';
import 'package:surveycat_app/models/historialParcela.dart';
import 'package:surveycat_app/models/origenTierra.dart';
import 'dart:io' as io;

import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/relacionConParcela.dart';
import 'package:surveycat_app/models/relacionInformanteParcela.dart';
import 'package:surveycat_app/models/stbNacionalidad.dart';
import 'package:surveycat_app/models/stbSectores.dart';
import 'package:surveycat_app/models/tipoDeUso.dart';
import 'package:surveycat_app/models/tipoTransaccion.dart';

class DictionaryDataBaseHelper {
  static late Database _db;

  static Future<Database> _openDB() async {
    io.Directory applicationDirectory =
        await getApplicationDocumentsDirectory();

    String dbPath =
        path.join(applicationDirectory.path, "SurveyCatDbClient.db");

    return openDatabase(dbPath);
  }

  static Future<void> init() async {
    io.Directory applicationDirectory =
        await getApplicationDocumentsDirectory();

    String dbPath =
        path.join(applicationDirectory.path, "SurveyCatDbClient.db");

    bool dbExists = await io.File(dbPath).exists();

    if (!dbExists) {
      // Copy from asset
      ByteData data =
          await rootBundle.load(path.join("assets/db", "SurveyCatDbClient.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await io.File(dbPath).writeAsBytes(bytes, flush: true);
    }
    _db = await openDatabase(dbPath);
  }

  static Future<List<Parcela>> parcelas() async {
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> parcelasMap =
        await database.query("Parcela");

    return List.generate(
        parcelasMap.length,
        (i) => Parcela(
            id: parcelasMap[i]['Id'],
            codEnc: parcelasMap[i]['CodEnc'],
            codPar: parcelasMap[i]['CodPar'],
            areaEstimada: parcelasMap[i]['AreaEstimada'],
            presentaConflicto: false,
            fechaEnc: parcelasMap[i]['Fecha_Enc'],
            id_informante: parcelasMap[i]['Id_Informante'],
            userId: parcelasMap[i]['UserId']));
  }

  static Future<List<CatDepartamento>> getCatDepartamentos() async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> catDepartamentoMap =
        await database.query("Cat_Departamento");

    return List.generate(
        catDepartamentoMap.length,
        (i) => CatDepartamento(
            codDep: catDepartamentoMap[i]['CodDep'],
            departamento: catDepartamentoMap[i]['Departamento'],
            municipios: []));
  }

  static Future<List<CatMunicipio>> getCatMunicipios(
      String codDeparmento) async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> catMunicipioMap = await database.rawQuery(
        "SELECT CodDep, CodMun, Municipio FROM Cat_Municipios WHERE CodDep=?",
        [codDeparmento]);

    return List.generate(
        catMunicipioMap.length,
        (i) => CatMunicipio(
            codDep: catMunicipioMap[i]['CodDep'],
            codMun: catMunicipioMap[i]['CodMun'],
            municipio: catMunicipioMap[i]['Municipio']));
  }

  static Future<List<StbSector>> getStbSectores(String codMunicipio) async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> stbSectoresMap = await database.rawQuery(
        "SELECT stbSectoresID, num_sector FROM stbSectores WHERE  substr(SectorxMun,4,4)=?",
        [codMunicipio]);

    return List.generate(
        stbSectoresMap.length,
        (i) => StbSector(
            stbSectoresID: stbSectoresMap[i]['stbSectoresID'],
            num_sector: stbSectoresMap[i]['num_sector']));
  }

  static Future<List<TipoDeUso>> getTiposDeUso() async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> tiposDeUsoMap =
        await database.query("TipoDeUso");

    return List.generate(
        tiposDeUsoMap.length,
        (i) => TipoDeUso(
            id: tiposDeUsoMap[i]['Id'],
            tipoDeUso: tiposDeUsoMap[i]['TipoDeUso']));
  }

  static Future<List<CatUnidadDeMedida>> getCatUnidadesDeMedida() async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> catUnidadesDeMedidaMap =
        await database.query("Cat_UniMed");

    return List.generate(
        catUnidadesDeMedidaMap.length,
        (i) => CatUnidadDeMedida(
            id: catUnidadesDeMedidaMap[i]['Id'],
            uniMed: catUnidadesDeMedidaMap[i]['UniMed'],
            descripcion: catUnidadesDeMedidaMap[i]['Descripcion']));
  }

  static Future<List<OrigenTierra>> getOrigenTierra() async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> origenTierraMap =
        await database.query("CatOrigenTierra");

    return List.generate(
        origenTierraMap.length,
        (i) => OrigenTierra(
            id: origenTierraMap[i]['Id'],
            descripcion: origenTierraMap[i]['Descripcion']));
  }

  static Future<List<CatServidumbre>> getCatServidumbre() async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> catServidumbreMap =
        await database.query("CatServidumbre");

    return List.generate(
        catServidumbreMap.length,
        (i) => CatServidumbre(
            id: catServidumbreMap[i]['Id'],
            descripcion: catServidumbreMap[i]['Descripcion']));
  }

  static Future<List<CatEstadoCivil>> getEstadoCivil() async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> estadoCivilMap =
        await database.query("CatEstadoCivil");

    return List.generate(
        estadoCivilMap.length,
        (i) => CatEstadoCivil(
            id: estadoCivilMap[i]['Id'],
            descripcion: estadoCivilMap[i]['Descripcion']));
  }

  static Future<List<StbNacionalidad>> getNacionalidad() async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> nacionalidadesMap =
        await database.query("stbNacionalidad");

    return List.generate(
        nacionalidadesMap.length,
        (i) => StbNacionalidad(
            stbNacionalidadID: nacionalidadesMap[i]['stbNacionalidadID'],
            singularNac: nacionalidadesMap[i]['SingularNac']));
  }

  static Future<List<RelacionInformanteParcela>>
      getRelacionInformanteParcela() async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> relacionesInformantesParcelaMap =
        await database.query("RelacionInformanteParcela");

    return List.generate(
        relacionesInformantesParcelaMap.length,
        (i) => RelacionInformanteParcela(
            id: relacionesInformantesParcelaMap[i]['Id'],
            descripcion: relacionesInformantesParcelaMap[i]['Descripcion']));
  }

  static Future<List<CatPersonaNatural>> getInformante(
      String codEnc, String cedula) async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> informantesMap = await database.rawQuery(
        "SELECT * FROM Cat_Personas_Naturales WHERE CodEnc=? and Cedula=?",
        [codEnc, cedula]);

    return List.generate(
        informantesMap.length,
        (i) => CatPersonaNatural(
            id: informantesMap[i]['Id'],
            codPar: informantesMap[i]['CodPar'],
            codEnc: informantesMap[i]['CodEnc'],
            nombre1: informantesMap[i]['Nombre1'],
            nombre2: informantesMap[i]['Nombre2'],
            apellido1: informantesMap[i]['Apellido1'],
            apellido2: informantesMap[i]['Apellido2'],
            genero: informantesMap[i]['Genero'],
            cedula: informantesMap[i]['Cedula'],
            edad: informantesMap[i]['Edad'],
            codDep: informantesMap[i]['Cod_Dep'],
            codMun: informantesMap[i]['Cod_Mun'],
            codBar: informantesMap[i]['Cod_Bar'],
            domicilio: informantesMap[i]['Domicilio'],
            nombreCompleto: (((informantesMap[i]['Nombre1']!) != null
                    ? informantesMap[i]['Nombre1'] + ' '
                    : '') +
                ((informantesMap[i]['Nombre2']) != null
                    ? informantesMap[i]['Nombre2'] + ' '
                    : '') +
                ((informantesMap[i]['Apellido1']) != null
                    ? informantesMap[i]['Apellido1'] + ' '
                    : '') +
                ((informantesMap[i]['Apellido2']) != null
                    ? informantesMap[i]['Apellido2']
                    : '')),
            desmovilizado: informantesMap[i]['Desmovilizado'],
            descSectorReformado: informantesMap[i]['DescSectorReformado'],
            retirado: informantesMap[i]['Retirado'],
            campesinoTradicional: informantesMap[i]['CampesinoTradicional'],
            otros: informantesMap[i]['Otros'],
            idColectivo: informantesMap[i]['IDColectivo'],
            objNacionalidadID: informantesMap[i]['objNacionalidadID'],
            estadoCivil: informantesMap[i]['EstadoCivil'],
            objProfesionID: informantesMap[i]['objProfesionID'],
            esPareja: informantesMap[i]['EsPareja'],
            indicadorPareja: informantesMap[i]['IndicadorPareja'],
            cantHijosF: informantesMap[i]['CantHijosF'],
            cantHijosM: informantesMap[i]['CantHijosM'],
            codCaserio: informantesMap[i]['codCaserio'],
            barrio: informantesMap[i]['barrio'],
            comarca: informantesMap[i]['comarca'],
            caserio: informantesMap[i]['caserio'],
            profesion: informantesMap[i]['profesion']));
  }

  static Future<List<CatPersonaNatural>> getPropietariosNaturalesParcela(
      String codEnc) async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<
        Map<String,
            dynamic>> propietariosNaturalesMap = await database.rawQuery(
        "SELECT * FROM Cat_Personas_Naturales N inner join Propietarios P on N.CodEnc = P.CodEnc and N.Cedula = P.CEDULA WHERE N.CodEnc=?",
        [codEnc]);

    return List.generate(
        propietariosNaturalesMap.length,
        (i) => CatPersonaNatural(
            id: propietariosNaturalesMap[i]['Id'],
            codPar: propietariosNaturalesMap[i]['CodPar'],
            codEnc: propietariosNaturalesMap[i]['CodEnc'],
            nombre1: propietariosNaturalesMap[i]['Nombre1'],
            nombre2: propietariosNaturalesMap[i]['Nombre2'],
            apellido1: propietariosNaturalesMap[i]['Apellido1'],
            apellido2: propietariosNaturalesMap[i]['Apellido2'],
            genero: propietariosNaturalesMap[i]['Genero'],
            cedula: propietariosNaturalesMap[i]['Cedula'],
            edad: propietariosNaturalesMap[i]['Edad'],
            codDep: propietariosNaturalesMap[i]['Cod_Dep'],
            codMun: propietariosNaturalesMap[i]['Cod_Mun'],
            codBar: propietariosNaturalesMap[i]['Cod_Bar'],
            domicilio: propietariosNaturalesMap[i]['Domicilio'],
            nombreCompleto: (((propietariosNaturalesMap[i]['Nombre1']!) != null
                    ? propietariosNaturalesMap[i]['Nombre1'] + ' '
                    : '') +
                ((propietariosNaturalesMap[i]['Nombre2']) != null
                    ? propietariosNaturalesMap[i]['Nombre2'] + ' '
                    : '') +
                ((propietariosNaturalesMap[i]['Apellido1']) != null
                    ? propietariosNaturalesMap[i]['Apellido1'] + ' '
                    : '') +
                ((propietariosNaturalesMap[i]['Apellido2']) != null
                    ? propietariosNaturalesMap[i]['Apellido2']
                    : '')),
            desmovilizado: propietariosNaturalesMap[i]['Desmovilizado'],
            descSectorReformado: propietariosNaturalesMap[i]
                ['DescSectorReformado'],
            retirado: propietariosNaturalesMap[i]['Retirado'],
            campesinoTradicional: propietariosNaturalesMap[i]
                ['CampesinoTradicional'],
            otros: propietariosNaturalesMap[i]['Otros'],
            idColectivo: propietariosNaturalesMap[i]['IDColectivo'],
            objNacionalidadID: propietariosNaturalesMap[i]['objNacionalidadID'],
            estadoCivil: propietariosNaturalesMap[i]['EstadoCivil'],
            objProfesionID: propietariosNaturalesMap[i]['objProfesionID'],
            esPareja: propietariosNaturalesMap[i]['EsPareja'],
            indicadorPareja: propietariosNaturalesMap[i]['IndicadorPareja'],
            cantHijosF: propietariosNaturalesMap[i]['CantHijosF'],
            cantHijosM: propietariosNaturalesMap[i]['CantHijosM'],
            codCaserio: propietariosNaturalesMap[i]['codCaserio'],
            barrio: propietariosNaturalesMap[i]['barrio'],
            comarca: propietariosNaturalesMap[i]['comarca'],
            caserio: propietariosNaturalesMap[i]['caserio'],
            profesion: propietariosNaturalesMap[i]['profesion']));
  }

  static Future<List<CatPersonaJuridica>> getPropietariosJuridicosParcela(
      String codEnc) async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<
        Map<String,
            dynamic>> propietariosJuridicosMap = await database.rawQuery(
        "SELECT * FROM Cat_PersonasJuridicas J inner join Propietarios P on J.CodEnc = P.CodEnc and J.RUC = P.RUC WHERE J.CodEnc=?",
        [codEnc]);

    return List.generate(
        propietariosJuridicosMap.length,
        (i) => CatPersonaJuridica(
              codPar: propietariosJuridicosMap[i]['CodPar'],
              codEnc: propietariosJuridicosMap[i]['CodEnc'],
              razonSocial: propietariosJuridicosMap[i]['RazonSocial'],
              tipoPersJurid: propietariosJuridicosMap[i]['TipoPersJurid'],
              numSocios: propietariosJuridicosMap[i]['NumSocios'],
              numSocias: propietariosJuridicosMap[i]['NumSocias'],
              ruc: propietariosJuridicosMap[i]['RUC'],
              lugardeRegistro: propietariosJuridicosMap[i]['LugardeRegistro'],
              fechaRegistro: propietariosJuridicosMap[i]['FechaRegistro'],
              codDep: propietariosJuridicosMap[i]['CodDep'],
              codMun: propietariosJuridicosMap[i]['CodMun'],
              codBarrio: propietariosJuridicosMap[i]['CodBarrio'],
              direccion: propietariosJuridicosMap[i]['Direccion'],
              objNacionalidadID: propietariosJuridicosMap[i]
                  ['objNacionalidadID'],
            ));
  }

  static Future<List<RelacionConParcela>>
      getRelacionPropietarioParcela() async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> relacionesPropietarioParcelaMap =
        await database.query("RelacionConParcela");

    return List.generate(
        relacionesPropietarioParcelaMap.length,
        (i) => RelacionConParcela(
            id: relacionesPropietarioParcelaMap[i]['Id'],
            relacion: relacionesPropietarioParcelaMap[i]['Relacion']));
  }

  static Future<List<Cat_Documentos>> getTiposDocumentos() async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> catDocumentosMap =
        await database.query("Cat_Documentos");

    return List.generate(
        catDocumentosMap.length,
        (i) => Cat_Documentos(
              codDocum: catDocumentosMap[i]['CodDocum'],
              documento: catDocumentosMap[i]['Documento'],
              inscribible: catDocumentosMap[i]['Incribible'],
            ));
  }

  static Future<Cat_Documentos?> getCatDocumentoPorCodDocum(
      String codDocum) async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> catDocumentosMap = await database
        .rawQuery("SELECT * FROM Cat_Documentos WHERE CodDocum=?", [codDocum]);

    if (catDocumentosMap.isEmpty) {
      return null;
    }

    var objDocumento = catDocumentosMap.first;

    Cat_Documentos result = Cat_Documentos(
        codDocum: objDocumento['CodDocum'],
        documento: objDocumento['Documento'],
        inscribible: objDocumento['Incribible']);

    return result;
  }

  static Future<List<HistorialParcela>> getHistorialParcelaPorCodEnc(
      String codEnc) async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> historialParcelaMap = await database
        .rawQuery("SELECT * FROM Historial_Parcela WHERE CodEnc=? ORDER BY Id",
            [codEnc]);

    return List.generate(
        historialParcelaMap.length,
        (i) => HistorialParcela(
              id: historialParcelaMap[i]['Id'],
              codPar: historialParcelaMap[i]['CodPar'],
              codEnc: historialParcelaMap[i]['CodEnc'],
              sucesor: historialParcelaMap[i]['Sucesor'],
              anterior: historialParcelaMap[i]['Anterior'],
              tipoTrans: historialParcelaMap[i]['TipoTrans'],
              docTrans: historialParcelaMap[i]['DocTrans'],
              fechaTransaccion: historialParcelaMap[i]['FechaTransaccion'],
              anio_Transaccion: historialParcelaMap[i]['Anio_Transaccion'],
            ));
  }

  static Future<List<TipoTransaccion>> getTiposTransacciones() async {
    //Database database = await _openDB();
    Database database = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> tiposTransaccionesMap =
        await database.query("Tipo_Transaccion", orderBy: "Descripcion ASC");

    return List.generate(
        tiposTransaccionesMap.length,
        (i) => TipoTransaccion(
              idTipoTransaccion: tiposTransaccionesMap[i]['Id_TipoTransaccion'],
              descripcion: tiposTransaccionesMap[i]['Descripcion'],
            ));
  }
}
