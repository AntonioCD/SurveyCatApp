// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_titled_container/flutter_titled_container.dart';

import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/token.dart';

class ParcelaScreen extends StatefulWidget {
  final Token token;
  final Parcela parcela;

  ParcelaScreen({required this.token, required this.parcela});

  @override
  State<ParcelaScreen> createState() => _ParcelaScreenState();
}

class _ParcelaScreenState extends State<ParcelaScreen> {
  String _codenc = '';
  String _codencError = '';
  bool _codencShowError = false;
  TextEditingController _codencController = TextEditingController();

  String _encuestador = '';
  String _encuestadorError = '';
  bool _encuestadorShowError = false;
  TextEditingController _encuestadorController = TextEditingController();

  String _areaEstimada = '';
  String _areaEstimadaError = '';
  bool _areaEstimadaShowError = false;
  TextEditingController _areaEstimadaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _codenc = widget.parcela.codEnc;
    _codencController.text = _codenc;
    _areaEstimada = widget.parcela.areaEstimada.toString();
    _areaEstimadaController.text = _areaEstimada;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 15, 15, 15),
        appBar: AppBar(
          title: Text(
              widget.parcela.id == 0 ? 'Nueva Parcela' : widget.parcela.codEnc),
          backgroundColor: Color.fromARGB(255, 11, 131, 0),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: ListView(
            padding: EdgeInsets.only(top: 15.0),
            children: <Widget>[
              TitledContainer(
                titleColor: Colors.white,
                title: 'Generales Encuesta',
                textAlign: TextAlignTitledContainer.Left,
                fontSize: 20.0,
                backgroundColor: Color.fromARGB(255, 15, 15, 15),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _showDepartamento(),
                        _showMunicipio(),
                        _showCodEnc(),
                      ]),
                ),
              ),
              SizedBox(height: 20),
              TitledContainer(
                titleColor: Colors.white,
                title: 'Datos del Inmueble',
                textAlign: TextAlignTitledContainer.Left,
                fontSize: 20.0,
                backgroundColor: Color.fromARGB(255, 15, 15, 15),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _showNombreFinca(),
                        _showAreaEstimada(),
                      ]),
                ),
              ),
              SizedBox(height: 20),
              TitledContainer(
                titleColor: Colors.white,
                title: 'Datos del Entrevistado',
                textAlign: TextAlignTitledContainer.Left,
                fontSize: 20.0,
                backgroundColor: Color.fromARGB(255, 15, 15, 15),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
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
                        Row(
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
                      ]),
                ),
              ),
              _showButtons(),
            ],
          ),
        ));
  }

  Widget _showDepartamento() {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: TextField(
        controller: _encuestadorController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Departamento',
          errorText: _codencShowError ? _codencError : null,
        ),
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showMunicipio() {
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
          hintText: 'Municipio',
          errorText: _codencShowError ? _codencError : null,
        ),
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showCodEnc() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
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

  Widget _showNombreFinca() {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: TextField(
        controller: _encuestadorController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Nombre de la Finca',
          errorText: _codencShowError ? _codencError : null,
        ),
        onChanged: (value) {
          _codenc = value;
        },
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
          errorText: _codencShowError ? _codencError : null,
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
          errorText: _codencShowError ? _codencError : null,
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
          errorText: _codencShowError ? _codencError : null,
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
          errorText: _codencShowError ? _codencError : null,
        ),
        onChanged: (value) {
          _codenc = value;
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
          errorText: _codencShowError ? _codencError : null,
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
          errorText: _codencShowError ? _codencError : null,
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
          errorText: _codencShowError ? _codencError : null,
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
          errorText: _codencShowError ? _codencError : null,
        ),
        onChanged: (value) {
          _codenc = value;
        },
      ),
    );
  }

  Widget _showButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
          primary: Color.fromARGB(255, 11, 131, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {},
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
}
