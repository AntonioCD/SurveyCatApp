// ignore_for_file: prefer_const_constructors
import 'dart:ui';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_titled_container/flutter_titled_container.dart';
import 'package:surveycat_app/components/loader_component.dart';
import 'package:surveycat_app/helpers/api_helper.dart';
import 'package:surveycat_app/helpers/clientProvider.dart';
import 'package:surveycat_app/helpers/controller.dart';
import 'package:surveycat_app/helpers/databaseProvider.dart';
import 'package:surveycat_app/helpers/database_helper.dart';

import 'package:surveycat_app/models/catDepartamento.dart';
import 'package:surveycat_app/models/catMunicipio.dart';
import 'package:surveycat_app/models/catServidumbre.dart';
import 'package:surveycat_app/models/catUniMed.dart';
import 'package:surveycat_app/models/origenTierra.dart';
import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/response.dart';
import 'package:surveycat_app/models/stbSectores.dart';
import 'package:surveycat_app/models/tipoDeUso.dart';
import 'package:surveycat_app/models/token.dart';
import 'package:surveycat_app/models/user.dart';

class ParcelaScreen extends StatefulWidget {
  final Token token;
  final User user;
  final Parcela parcela;

  ParcelaScreen(
      {required this.token, required this.user, required this.parcela});

  @override
  State<ParcelaScreen> createState() => _ParcelaScreenState();
}

class _ParcelaScreenState extends State<ParcelaScreen> {
  bool _showLoader = false;

  String _departamentoCodDep = '0';
  String _departamentoCodDepError = '';
  bool _departamentoCodDepShowError = false;
  List<CatDepartamento> _departamentos = [];
  List<CatDepartamento> _departamentosList = [];

  String _municipioCodMun = '0';
  String _municipioCodMunError = '';
  bool _municipioCodMunShowError = false;
  List<CatMunicipio> _municipios = [];
  List<CatMunicipio> _municipiosList = [];

  int _stbSectorId = 0;
  String _stbSectorIdError = '';
  bool _stbSectorIdShowError = false;
  List<StbSector> _stbSectoresList = [];

  String _sector = '';
  String _sectorError = '';
  bool _sectorShowError = false;
  TextEditingController _sectorController = TextEditingController();

  late DateTime _fechaEncuesta;
  String _fechaEncuestaError = '';
  bool _fechaEncuestaShowError = false;
  TextEditingController _fechaEncuestaController = TextEditingController();

  String _codenc = '';
  String _codencError = '';
  bool _codencShowError = false;
  TextEditingController _codencController = TextEditingController();

  String _nombreFinca = '';
  String _nombreFincaError = '';
  bool _nombreFincaShowError = false;
  TextEditingController _nombreFincaController = TextEditingController();

  String _comarca = '';
  String _comarcaError = '';
  bool _comarcaShowError = false;
  TextEditingController _comarcaController = TextEditingController();

  String _barrioCaserio = '';
  String _barrioCaserioError = '';
  bool _barrioCaserioShowError = false;
  TextEditingController _barrioCaserioController = TextEditingController();

  String _manzana = '';
  String _manzanaError = '';
  bool _manzanaShowError = false;
  TextEditingController _manzanaController = TextEditingController();

  String _lote = '';
  String _loteError = '';
  bool _loteShowError = false;
  TextEditingController _loteController = TextEditingController();

  int _tipoDeUsoId = 0;
  String _tipoDeUsoIdError = '';
  bool _tipoDeUsoIdShowError = false;
  List<TipoDeUso> _tiposDeUso = [];

  String _descripcionUso = '';
  String _descripcionUsoError = '';
  bool _descripcionUsoShowError = false;
  TextEditingController _descripcionUsoController = TextEditingController();

  String _areaEstimada = '';
  String _areaEstimadaError = '';
  bool _areaEstimadaShowError = false;
  TextEditingController _areaEstimadaController = TextEditingController();

  int _catUnidadDeMedidaId = 0;
  String _catUnidadDeMedidaIdError = '';
  bool _catUnidadDeMedidaIdShowError = false;
  List<CatUnidadDeMedida> _catUnidadDeMedidaList = [];

  int _origenTierraId = 0;
  String _origenTierraIdError = '';
  bool _origenTierraIdShowError = false;
  List<OrigenTierra> _origenTierraList = [];

  int _catServidumbreAguaId = 0;
  String _catServidumbreAguaIdError = '';
  bool _catServidumbreAguaIdShowError = false;

  int _catServidumbrePaseId = 0;
  String _catServidumbrePaseIdError = '';
  bool _catServidumbrePaseIdShowError = false;

  int _catServidumbreOtroId = 0;
  String _catServidumbreOtroIdError = '';
  bool _catServidumbreOtroIdShowError = false;

  List<CatServidumbre> _catServidumbreList = [];

  String _tecnicoLegal = '';
  String _tecnicoLegalError = '';
  bool _tecnicoLegalShowError = false;
  TextEditingController _tecnicoLegalController = TextEditingController();

  bool _areaProtegida = false;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
      appBar: AppBar(
        title: Text(widget.parcela.id == 0
            ? 'Nueva Encuesta'
            : 'Editar Parcela : ' + widget.parcela.codEnc),
        titleTextStyle: TextStyle(fontSize: 25.0),
        backgroundColor: Color.fromARGB(255, 0, 70, 136),
      ),
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: ListView(
              //padding: EdgeInsets.only(top: 10.0),
              children: <Widget>[
                _showDatosGeneralesTitle(),
                _showDepartamentoMunicipio(),
                _showSectorFechaEncuesta(),
                _showTecnicoLegal(),
                _showTecnicoCatastral(),
                _showCoordinadorBrigada(),
                _showCodEnc(),
                _showDatosDelInmuebleTitle(),
                _showNombreFinca(),
                _showUbicacionLabel(),
                //_showComarca(),
                //_showBarrioCaserio(),
                _showManzanaLote(),
                _showTipoUsoLabel(),
                _showTipoDeUsoDescripcion(),
                _showOrigenTierraLabel(),
                _showAreaEstimada_UnidadDeMedida(),
                //_showOrigenTierraChk(),
                _showOrigenTierra_AreaProtegida(),
                _showServidumbreTitle(),
                _showServidumbreChk_ServidumbreAgua(),
                _showServidumbrePase_ServidumbreOtro(),
                //_showDatosConflictoTitle(),
                //_showPrimerNombreSegundoNombreInformante(),
                //_showPrimerApellidoSegundoApellidoInformante(),
                SizedBox(height: 10),
                _showButtons(),
              ],
            ),
          ),
          /*  _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(), */
        ],
      ),
    );
  }

  Widget _showDatosGeneralesTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Text(
        'DATOS GENERALES',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 25.0),
      ),
    );
  }

  Widget _showDepartamentoMunicipio() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showDepartamentos(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showMunicipios(),
          ),
        ],
      ),
    );
  }

  Widget _showDepartamentos() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _departamentosList.length == 0
            ? Text('Cargando departamentos...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboDepartamentos(),
                value: _departamentoCodDep,
                onChanged: (option) {
                  setState(() {
                    _departamentoCodDep = option as String;
                    _municipioCodMun = '0';
                    _stbSectorId = 0;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText: _departamentoCodDepShowError
                      ? _departamentoCodDepError
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<String>> _getComboDepartamentos() {
    List<DropdownMenuItem<String>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Seleccione el departamento...'),
      value: '0',
    ));

    _departamentosList.forEach((catDepartamento) {
      list.add(DropdownMenuItem(
        child: Text(catDepartamento.departamento),
        value: catDepartamento.codDep,
      ));
    });

    return list;
  }

  Widget _showMunicipios() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _departamentosList.length == 0
            ? Text('Cargando municipios...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboMunicipios(_departamentoCodDep),
                value: _municipioCodMun,
                onChanged: (option) {
                  setState(() {
                    _municipioCodMun = option as String;
                    _stbSectorId = 0;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText:
                      _municipioCodMunShowError ? _municipioCodMunError : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<String>> _getComboMunicipios(String _codDep) {
    List<DropdownMenuItem<String>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Seleccione el municipio...'),
      value: '0',
    ));

    _getMunicipios(_codDep);

    _municipiosList.forEach((catMunicipio) {
      list.add(DropdownMenuItem(
        child: Text(catMunicipio.municipio),
        value: catMunicipio.codMun,
      ));
    });

    /* _departamentosList.forEach((catDepartamento) {
      catDepartamento.municipios
          .where((x) => x.codDep == _codDep)
          .forEach((catMunicipio) {
        list.add(DropdownMenuItem(
          child: Text(catMunicipio.municipio),
          value: catMunicipio.codMun,
        ));
      });
    });
 */
    return list;
  }

  Widget _showSectorFechaEncuesta() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showSectores(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showFechaEncuesta(),
          ),
        ],
      ),
    );
  }

  Widget _showSector() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        controller: _barrioCaserioController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Sector',
          errorText: _sectorShowError ? _sectorError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _sector = value;
        },
      ),
    );
  }

  Widget _showSectores() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _departamentosList.length == 0
            ? Text('Cargando sectores...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboSectores(_municipioCodMun),
                value: _stbSectorId,
                onChanged: (option) {
                  setState(() {
                    _stbSectorId = option as int;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText: _stbSectorIdShowError ? _stbSectorIdError : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<int>> _getComboSectores(String _codMun) {
    List<DropdownMenuItem<int>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Seleccione el sector...'),
      value: 0,
    ));

    _getSectores(_codMun);

    _stbSectoresList.forEach((stbSector) {
      list.add(DropdownMenuItem(
        child: Text(stbSector.num_sector),
        value: stbSector.stbSectoresID,
      ));
    });

    return list;
  }

  Widget _showFechaEncuesta() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
          controller: _fechaEncuestaController,
          readOnly: true,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              hintText: 'Fecha de la Encuesta',
              errorText: _fechaEncuestaShowError ? _fechaEncuestaError : null,
              suffixIcon: Icon(Icons.calendar_today)),
          style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
          onTap: () {
            _pickDate(context, 'fechaEncuesta', _fechaEncuestaController);
          }),
    );
  }

  Widget _showTecnicoLegal() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: _tecnicoLegalController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Tecnico Legal',
          //errorText: _codencShowError ? _codencError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showTecnicoCatastral() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: _tecnicoLegalController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Tecnico Catastral',
          //errorText: _codencShowError ? _codencError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showCoordinadorBrigada() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: _tecnicoLegalController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Cordinador de Brigada',
          //errorText: _codencShowError ? _codencError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showCodEnc() {
    return Container(
      margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        autofocus: true,
        controller: _codencController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Código de Encuesta',
          errorText: _codencShowError ? _codencError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showDatosDelInmuebleTitle() {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Text(
        'DATOS DEL INMUEBLE',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 25.0),
      ),
    );
  }

  /*  Widget _showTipoEncuestaChk() {
    return Container(
      margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showAreaProtegidaChk(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showAreaProtegidaChk(),
          ),
        ],
      ),
    );
  } */

  Widget _showNombreFinca() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        controller: _nombreFincaController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Nombre de la Finca',
          errorText: _nombreFincaShowError ? _nombreFincaError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _nombreFinca = value;
        },
      ),
    );
  }

  Widget _showUbicacionLabel() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Text(
        'Ubicación',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    );
  }

  Widget _showComarca() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        controller: _comarcaController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Comarca',
          errorText: _comarcaShowError ? _comarcaError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _comarca = value;
        },
      ),
    );
  }

  Widget _showBarrioCaserio() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        controller: _barrioCaserioController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Barrio o Caserio',
          errorText: _barrioCaserioShowError ? _barrioCaserioError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _barrioCaserio = value;
        },
      ),
    );
  }

  Widget _showManzanaLote() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showManzana(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showLote(),
          ),
        ],
      ),
    );
  }

  Widget _showManzana() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        controller: _manzanaController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Manzana',
          errorText: _manzanaShowError ? _manzanaError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _manzana = value;
        },
      ),
    );
  }

  Widget _showLote() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        controller: _loteController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Lote',
          errorText: _loteShowError ? _loteError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _lote = value;
        },
      ),
    );
  }

  Widget _showTipoUsoLabel() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Text(
        'Tipo de Uso',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    );
  }

  Widget _showTipoDeUsoDescripcion() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showTipoDeUsoCombo(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showDescripcionUso(),
          ),
        ],
      ),
    );
  }

  Widget _showTipoDeUsoCombo() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _tiposDeUso.length == 0
            ? Text('Cargando Tipos de Uso...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboTiposDeUso(),
                value: _tipoDeUsoId,
                onChanged: (option) {
                  setState(() {
                    _tipoDeUsoId = option as int;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText: _tipoDeUsoIdShowError ? _tipoDeUsoIdError : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<int>> _getComboTiposDeUso() {
    List<DropdownMenuItem<int>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Seleccione el Tipo de Uso...'),
      value: 0,
    ));

    _tiposDeUso.forEach((tipoDeUso) {
      list.add(DropdownMenuItem(
        child: Text(tipoDeUso.tipoDeUso),
        value: tipoDeUso.id,
      ));
    });

    return list;
  }

  Widget _showDescripcionUso() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        controller: _descripcionUsoController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Descripción de Uso',
          errorText: _descripcionUsoShowError ? _descripcionUsoError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _descripcionUso = value;
        },
      ),
    );
  }

  Widget _showTipoUsoChk() {
    return Container(
      margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showAreaProtegidaChk(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showAreaProtegidaChk(),
          ),
        ],
      ),
    );
  }

  Widget _showOrigenTierraLabel() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Text(
        'Area y Origen de la Tierra',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    );
  }

  Widget _showAreaEstimada_UnidadDeMedida() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showAreaEstimada(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showUnidadDeMedidaCombo(),
          ),
        ],
      ),
    );
  }

  Widget _showAreaEstimada() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        keyboardType:
            TextInputType.numberWithOptions(decimal: true, signed: false),
        controller: _areaEstimadaController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Area Estimada',
          errorText: _areaEstimadaShowError ? _areaEstimadaError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _areaEstimada = value;
        },
      ),
    );
  }

  Widget _showUnidadDeMedidaCombo() {
    return Container(
        margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _catUnidadDeMedidaList.length == 0
            ? Text('Cargando Unidades de Medida...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboUnidadesDeMedida(),
                value: _catUnidadDeMedidaId,
                onChanged: (option) {
                  setState(() {
                    _catUnidadDeMedidaId = option as int;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText: _catUnidadDeMedidaIdShowError
                      ? _catUnidadDeMedidaIdError
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<int>> _getComboUnidadesDeMedida() {
    List<DropdownMenuItem<int>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Seleccione la Unidad de Medida...'),
      value: 0,
    ));

    _catUnidadDeMedidaList.forEach((unidadDeMedida) {
      list.add(DropdownMenuItem(
        child: Text(unidadDeMedida.uniMed),
        value: unidadDeMedida.id,
      ));
    });

    return list;
  }

  Widget _showOrigenTierra_AreaProtegida() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showOrigenTierraCombo(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showAreaProtegidaChk(),
          ),
        ],
      ),
    );
  }

  Widget _showOrigenTierraCombo() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _origenTierraList.length == 0
            ? Text('Cargando origen de la tierra...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboOrigenTierra(),
                value: _origenTierraId,
                onChanged: (option) {
                  setState(() {
                    _origenTierraId = option as int;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText:
                      _origenTierraIdShowError ? _origenTierraIdError : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<int>> _getComboOrigenTierra() {
    List<DropdownMenuItem<int>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Seleccione el origen de la tierra...'),
      value: 0,
    ));

    _origenTierraList.forEach((origenTierra) {
      list.add(DropdownMenuItem(
        child: Text(origenTierra.descripcion),
        value: origenTierra.id,
      ));
    });

    return list;
  }

  Widget _showAreaProtegidaChk() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
      height: 60.0,
      margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: CheckboxListTile(
          activeColor: Colors.green,
          title: Text(
            '¿Area Protegida?',
            style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
            textAlign: TextAlign.start,
          ),
          value: _areaProtegida,
          onChanged: (value) {
            setState(() {
              _areaProtegida = value!;
            });
          }),
    );
  }

  Widget _showOrigenTierraChk() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: _showAreaProtegidaChk(),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _showAreaProtegidaChk(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: _showAreaProtegidaChk(),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _showAreaProtegidaChk(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: _showAreaProtegidaChk(),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _showAreaProtegidaChk(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: _showAreaProtegidaChk(),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _showAreaProtegidaChk(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: _showAreaProtegidaChk(),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _showAreaProtegidaChk(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _showServidumbreTitle() {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Text(
        'TIPO DE SERVIDUMBRE',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 25.0),
      ),
    );
  }

  Widget _showServidumbreChk_ServidumbreAgua() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showServidumbreChk(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showServidumbreAguaCombo(),
          ),
        ],
      ),
    );
  }

  Widget _showServidumbreChk() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
      height: 60.0,
      margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: CheckboxListTile(
          activeColor: Colors.green,
          title: Text(
            '¿Posee Servidumbre?',
            style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
            textAlign: TextAlign.start,
          ),
          value: _areaProtegida,
          onChanged: (value) {
            setState(() {
              _areaProtegida = value!;
            });
          }),
    );
  }

  Widget _showServidumbreAguaCombo() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _catServidumbreList.length == 0
            ? Text('Cargando catalogo de servidumbre...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboCatServidumbreAgua(),
                value: _catServidumbreAguaId,
                onChanged: (option) {
                  setState(() {
                    _catServidumbreAguaId = option as int;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText: _catServidumbreAguaIdShowError
                      ? _catServidumbreAguaIdError
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<int>> _getComboCatServidumbreAgua() {
    List<DropdownMenuItem<int>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Agua...'),
      value: 0,
    ));

    _catServidumbreList.forEach((catServidumbre) {
      list.add(DropdownMenuItem(
        child: Text(catServidumbre.descripcion),
        value: catServidumbre.id,
      ));
    });

    return list;
  }

  Widget _showServidumbrePase_ServidumbreOtro() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showServidumbrePaseCombo(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showServidumbreOtroCombo(),
          ),
        ],
      ),
    );
  }

  Widget _showServidumbrePaseCombo() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _catServidumbreList.length == 0
            ? Text('Cargando catalogo de servidumbre...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboCatServidumbrePase(),
                value: _catServidumbrePaseId,
                onChanged: (option) {
                  setState(() {
                    _catServidumbrePaseId = option as int;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText: _catServidumbrePaseIdShowError
                      ? _catServidumbrePaseIdError
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<int>> _getComboCatServidumbrePase() {
    List<DropdownMenuItem<int>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Pase...'),
      value: 0,
    ));

    _catServidumbreList.forEach((catServidumbre) {
      list.add(DropdownMenuItem(
        child: Text(catServidumbre.descripcion),
        value: catServidumbre.id,
      ));
    });

    return list;
  }

  Widget _showServidumbreOtroCombo() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _catServidumbreList.length == 0
            ? Text('Cargando catalogo de servidumbre...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboCatServidumbreOtro(),
                value: _catServidumbreOtroId,
                onChanged: (option) {
                  setState(() {
                    _catServidumbreOtroId = option as int;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText: _catServidumbreOtroIdShowError
                      ? _catServidumbreOtroIdError
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<int>> _getComboCatServidumbreOtro() {
    List<DropdownMenuItem<int>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Otro...'),
      value: 0,
    ));

    _catServidumbreList.forEach((catServidumbre) {
      list.add(DropdownMenuItem(
        child: Text(catServidumbre.descripcion),
        value: catServidumbre.id,
      ));
    });

    return list;
  }

  Widget _showDatosConflictoTitle() {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Text(
        'DATOS CONFLICTO(S)',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 25.0),
      ),
    );
  }

  Widget _showPrimerNombreSegundoNombreInformante() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showInformantePrimerNombre(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showInformanteSegundoNombre(),
          ),
        ],
      ),
    );
  }

  Widget _showInformantePrimerNombre() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        //controller: _encuestadorController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Primer Nombre',
          //errorText: _codencShowError ? _codencError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showInformanteSegundoNombre() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        //controller: _encuestadorController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Segundo Nombre',
          //errorText: _codencShowError ? _codencError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showPrimerApellidoSegundoApellidoInformante() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showInformantePrimerApellido(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showInformanteSegundoApellido(),
          ),
        ],
      ),
    );
  }

  Widget _showInformantePrimerApellido() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        //controller: _encuestadorController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Primer Apellido',
          //errorText: _codencShowError ? _codencError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showInformanteSegundoApellido() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        //controller: _encuestadorController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Segundo Apellido',
          //errorText: _codencShowError ? _codencError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showButtons() {
    return Align(
      alignment: Alignment.centerRight,
      //padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
          primary: Color.fromARGB(255, 153, 4, 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () => _save(),
        child: //const Text('Guardar'),
            Container(
          height: 50,
          width: 150,
          alignment: Alignment.center,
          child: Text(
            "Guardar",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_validateFields()) {
      return;
    }

    widget.parcela.id == 0 ? _addLocalRecord() : _saveRecord();
    //widget.parcela.id == 0 ? _addRecord() : _saveRecord();
  }

  bool _validateFields() {
    bool isValid = true;

    if (_codenc.isEmpty) {
      isValid = false;
      _codencShowError = true;
      _codencError = 'Debes ingresar el Código de Encuesta';
    } else {
      _codencShowError = false;
    }

    if (_codenc.isEmpty) {
      isValid = false;
      _areaEstimadaShowError = true;
      _areaEstimadaError = 'Debes un area mayor o igual a 0';
    } else {
      double areaEstimada = double.parse(_areaEstimada);
      if (areaEstimada < 0) {
        isValid = false;
        _areaEstimadaShowError = true;
        _areaEstimadaError = 'Debes un area mayor o igual a 0';
      } else {
        _areaEstimadaShowError = false;
      }
    }

    setState(() {});
    return isValid;
  }

  _addLocalRecord() async {
    setState(() {
      _showLoader = true;
    });

    Parcela parcela = Parcela(
        id: 0,
        codEnc: _codenc,
        codPar: _codenc,
        areaEstimada: double.parse(_areaEstimada),
        presentaConflicto: false,
        fechaEnc: '',
        id_informante: '',
        userId: widget.user.id);

    await DatabaseProvider.insert(parcela);

    /*   .then((value) {
      if (value > 0) {
        print("Success");
      } else {
        print("faild");
        return;
      }
    }); */

    /* await Controller().addData(parcela).then((value) {
      if (value > 0) {
        print("Success");
      } else {
        print("faild");
        return;
      }
    });
 */
    setState(() {
      _showLoader = false;
    });

    /*  if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    } */

    Navigator.pop(context, 'yes');
  }

  _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'codEnc': _codenc,
      'codPar': _codenc,
      'areaEstimada': double.parse(_areaEstimada),
      'userId': widget.user.id,
    };

    Response response =
        await ApiHelper.post('/api/Parcelas/', request, widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Navigator.pop(context, 'yes');
  }

  _saveRecord() async {
    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'id': widget.parcela.id,
      'codEnc': _codenc,
      'codPar': _codenc,
      'areaEstimada': double.parse(_areaEstimada),
      'userId': widget.user.id,
    };

    Response response = await ApiHelper.put(
        '/api/Parcelas/', widget.parcela.id.toString(), request, widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Navigator.pop(context, 'yes');
  }

  Future<Null> _getDepartamentos() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = await ApiHelper.getDepartamentos(widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _departamentos = response.result;
    });
  }

  Future<Null> _getCatDepartamentos() async {
    setState(() {
      _showLoader = true;
    });

    List<CatDepartamento> response =
        await DictionaryDataBaseHelper.getCatDepartamentos();

    setState(() {
      _showLoader = false;
      _departamentosList = response;
    });
  }

  Future<Null> _getMunicipios(String codDepartamento) async {
    setState(() {
      _showLoader = true;
    });

    List<CatMunicipio> response =
        await DictionaryDataBaseHelper.getCatMunicipios(codDepartamento);

    setState(() {
      _showLoader = false;
      _municipiosList = response;
    });
  }

  Future<Null> _getSectores(String codMunicipio) async {
    setState(() {
      _showLoader = true;
    });

    if (codMunicipio != '0') {
      return;
    }

    List<StbSector> response =
        await DictionaryDataBaseHelper.getStbSectores(codMunicipio);

    setState(() {
      _showLoader = false;
      _stbSectoresList = response;
    });
  }

  Future<Null> _getTiposDeUso() async {
    setState(() {
      _showLoader = true;
    });

    List<TipoDeUso> response = await DictionaryDataBaseHelper.getTiposDeUso();

    setState(() {
      _showLoader = false;
      _tiposDeUso = response;
    });
  }

  Future<Null> _getUnidadesDeMedida() async {
    setState(() {
      _showLoader = true;
    });

    List<CatUnidadDeMedida> response =
        await DictionaryDataBaseHelper.getCatUnidadesDeMedida();

    setState(() {
      _showLoader = false;
      _catUnidadDeMedidaList = response;
    });
  }

  Future<Null> _getOrigenTierra() async {
    setState(() {
      _showLoader = true;
    });

    List<OrigenTierra> response =
        await DictionaryDataBaseHelper.getOrigenTierra();

    setState(() {
      _showLoader = false;
      _origenTierraList = response;
    });
  }

  Future<Null> _getCatServidumbre() async {
    setState(() {
      _showLoader = true;
    });

    List<CatServidumbre> response =
        await DictionaryDataBaseHelper.getCatServidumbre();

    setState(() {
      _showLoader = false;
      _catServidumbreList = response;
    });
  }

  Future _pickDate(BuildContext context, String tipoFecha,
      TextEditingController textEditingController) async {
    final initialDate = DateTime.now();
    final pickedDate = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate == null) return;

    setState(() {
      if (tipoFecha == 'fechaEncuesta') {
        _fechaEncuesta = pickedDate;
        textEditingController.text = getTextFromDate(tipoFecha);
      }
    });
  }

  String getTextFromDate(String tipoFecha) {
    if (tipoFecha == 'fechaEncuesta') {
      return '${_fechaEncuesta.day}/${_fechaEncuesta.month}/${_fechaEncuesta.year}';
    }

    return 'Seleccionar fecha';
  }

  void _loadData() async {
    //await _getDepartamentos();
    await _getCatDepartamentos();
    await _getTiposDeUso();
    await _getUnidadesDeMedida();
    await _getOrigenTierra();
    await _getCatServidumbre();

    _loadFieldValues();
  }

  void _loadFieldValues() {
    /*  _vehicleTypeId = widget.vehicle.vehicleType.id;
    _brandId = widget.vehicle.brand.id; */

    _codenc = widget.parcela.codEnc;
    _codencController.text = _codenc;

    _areaEstimada = widget.parcela.areaEstimada.toString();
    _areaEstimadaController.text = _areaEstimada;
  }
}
