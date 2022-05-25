// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_titled_container/flutter_titled_container.dart';
import 'package:surveycat_app/components/loader_component.dart';
import 'package:surveycat_app/helpers/api_helper.dart';

import 'package:surveycat_app/models/catDepartamento.dart';
import 'package:surveycat_app/models/catMunicipio.dart';
import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/response.dart';
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

  String _municipioCodMun = '0';
  String _municipioCodMunError = '';
  bool _municipioCodMunShowError = false;
  List<CatDepartamento> _municipios = [];

  String _sector = '';
  String _sectorError = '';
  bool _sectorShowError = false;
  TextEditingController _sectorController = TextEditingController();

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

  String _descripcion = '';
  String _descripcionError = '';
  bool _descripcionShowError = false;
  TextEditingController _descripcionController = TextEditingController();

  String _areaEstimada = '';
  String _areaEstimadaError = '';
  bool _areaEstimadaShowError = false;
  TextEditingController _areaEstimadaController = TextEditingController();

  String _encuestador = '';
  String _encuestadorError = '';
  bool _encuestadorShowError = false;
  TextEditingController _encuestadorController = TextEditingController();

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
        title: Text(
            widget.parcela.id == 0 ? 'Nueva Encuesta' : widget.parcela.codEnc),
        backgroundColor: Color.fromARGB(255, 0, 133, 138),
      ),
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: ListView(
              padding: EdgeInsets.only(top: 10.0),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'DATOS GENERALES DE LA ENCUESTA',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                _showDepartamentoMunicipio(),
                _showSectorEncuesta(),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'DATOS DEL INMUEBLE',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                _showTipoEncuestaChk(),
                _showNombreFinca(),
                _showUbicacionLabel(),
                _showComarca(),
                _showBarrioCaserio(),
                _showManzanaLote(),
                _showTipoUsoLabel(),
                _showTipoUsoChk(),
                _showDescripcion(),
                _showAreaEstimada(),
                _showOrigenTierraLabel(),
                _showOrigenTierraChk(),
                _showDatosEntrevistadoTitle(),
                SizedBox(height: 20),
                _showButtons(),
              ],
            ),
          ),
          _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
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
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: _departamentos.length == 0
            ? Text('Cargando departamentos...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black),
                items: _getComboDepartamentos(),
                value: _departamentoCodDep,
                onChanged: (option) {
                  setState(() {
                    _departamentoCodDep = option as String;
                    _municipioCodMun = '0';
                  });
                },
                decoration: InputDecoration(
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

    _departamentos.forEach((catDepartamento) {
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
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: _departamentos.length == 0
            ? Text('Cargando municipios...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black),
                items: _getComboMunicipios(_departamentoCodDep),
                value: _municipioCodMun,
                onChanged: (option) {
                  setState(() {
                    _municipioCodMun = option as String;
                  });
                },
                decoration: InputDecoration(
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

    _departamentos.forEach((catDepartamento) {
      catDepartamento.municipios
          .where((x) => x.codDep == _codDep)
          .forEach((catMunicipio) {
        list.add(DropdownMenuItem(
          child: Text(catMunicipio.municipio),
          value: catMunicipio.codMun,
        ));
      });
    });

    return list;
  }

  Widget _showSectorEncuesta() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showSector(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showCodEnc(),
          ),
        ],
      ),
    );
  }

  Widget _showSector() {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: TextField(
        controller: _sectorController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Sector',
          errorText: _sectorShowError ? _sectorError : null,
        ),
        onChanged: (value) {
          _sector = value;
        },
      ),
    );
  }

  Widget _showCodEnc() {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: TextField(
        autofocus: true,
        controller: _codencController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Código de Encuesta',
          errorText: _codencShowError ? _codencError : null,
        ),
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showTipoEncuestaChk() {
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

  Widget _showNombreFinca() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        controller: _nombreFincaController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Nombre de la Finca',
          errorText: _nombreFincaShowError ? _nombreFincaError : null,
        ),
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
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Comarca',
          errorText: _comarcaShowError ? _comarcaError : null,
        ),
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
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Barrio o Caserio',
          errorText: _barrioCaserioShowError ? _barrioCaserioError : null,
        ),
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
      padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: TextField(
        controller: _manzanaController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Manzana',
          errorText: _manzanaShowError ? _manzanaError : null,
        ),
        onChanged: (value) {
          _manzana = value;
        },
      ),
    );
  }

  Widget _showLote() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: TextField(
        controller: _loteController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Lote',
          errorText: _loteShowError ? _loteError : null,
        ),
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

  Widget _showDescripcion() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        controller: _descripcionController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Descripcion',
          errorText: _descripcionShowError ? _descripcionError : null,
        ),
        onChanged: (value) {
          _descripcion = value;
        },
      ),
    );
  }

  Widget _showAreaEstimada() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextField(
        keyboardType:
            TextInputType.numberWithOptions(decimal: true, signed: false),
        controller: _areaEstimadaController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Area Estimada',
          errorText: _areaEstimadaShowError ? _areaEstimadaError : null,
        ),
        onChanged: (value) {
          _areaEstimada = value;
        },
      ),
    );
  }

  Widget _showOrigenTierraLabel() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Text(
        'Origen de la Tierra',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
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

  Widget _showAreaProtegidaChk() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 0.0),
      child: CheckboxListTile(
          activeColor: Colors.green,
          title: Text(
            'Areas Protegidas',
            style: TextStyle(color: Colors.black),
          ),
          value: _areaProtegida,
          onChanged: (value) {
            setState(() {
              _areaProtegida = value!;
            });
          }),
    );
  }

  Widget _showDatosEntrevistadoTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Text(
        'DATOS DEL ENTREVISTADO',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    );
  }

  Widget _showFechaEncuesta() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextField(
        //controller: _encuestadorController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Fecha de Encuesta',
          //errorText: _codencShowError ? _codencError : null,
        ),
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showEncuestador() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: _encuestadorController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Encuestador',
          //errorText: _codencShowError ? _codencError : null,
        ),
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
        controller: _encuestadorController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Cordinador de Brigada',
          //errorText: _codencShowError ? _codencError : null,
        ),
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
        controller: _encuestadorController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Tecnico Catastral',
          //errorText: _codencShowError ? _codencError : null,
        ),
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showInformantePrimerNombre() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: TextField(
        //controller: _encuestadorController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Primer Nombre',
          //errorText: _codencShowError ? _codencError : null,
        ),
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showInformanteSegundoNombre() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: TextField(
        //controller: _encuestadorController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Segundo Nombre',
          //errorText: _codencShowError ? _codencError : null,
        ),
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showInformantePrimerApellido() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextField(
        //controller: _encuestadorController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Primer Apellido',
          //errorText: _codencShowError ? _codencError : null,
        ),
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showInformanteSegundoApellido() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextField(
        //controller: _encuestadorController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Segundo Apellido',
          //errorText: _codencShowError ? _codencError : null,
        ),
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
          primary: Color.fromARGB(255, 0, 133, 138),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () => _save(),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            "Guardar",
            style: TextStyle(color: Colors.grey[100]),
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_validateFields()) {
      return;
    }

    widget.parcela.id == 0 ? _addRecord() : _saveRecord();
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

  _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'codEnc': _codenc,
      'areaEstimada': double.parse(_areaEstimada),
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
      'areaEstimada': double.parse(_areaEstimada),
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

  void _loadData() async {
    await _getDepartamentos();

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
