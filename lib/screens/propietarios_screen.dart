// ignore_for_file: prefer_const_constructors, prefer_is_empty

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:surveycat_app/components/loader_component.dart';
import 'package:surveycat_app/helpers/api_helper.dart';
import 'package:surveycat_app/helpers/database_helper.dart';
import 'package:surveycat_app/models/catPersonaJuridica.dart';
import 'package:surveycat_app/models/catPersonaNatural.dart';
import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/propietario.dart';
import 'package:surveycat_app/models/response.dart';

import 'package:surveycat_app/models/token.dart';
import 'package:surveycat_app/screens/personaNatural_screen.dart';
import 'package:surveycat_app/screens/popupPersonerias_screen.dart';
import 'package:surveycat_app/screens/propietarioJuridico_screen.dart';
import 'package:surveycat_app/screens/propietarioNatural_screen.dart';

class PropietariosScreen extends StatefulWidget {
  final Token token;
  final Parcela parcela;

  PropietariosScreen({required this.token, required this.parcela});

  @override
  State<PropietariosScreen> createState() => _PropietariosScreenState();
}

class _PropietariosScreenState extends State<PropietariosScreen> {
  bool _showLoader = false;
  late Parcela _parcela;
  late List<CatPersonaNatural> _propietariosNaturalesList = [];
  late List<CatPersonaJuridica> _propietariosJuridicosList = [];

  @override
  void initState() {
    super.initState();
    _parcela = widget.parcela;

    //_getParcela();
    _getPropietariosNaturalesParcela();
    _getPropietariosJuridicosParcela();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
      appBar: AppBar(
        title: Text('Propietarios/Poseedores' + ' : ' + _parcela.codEnc),
        titleTextStyle: TextStyle(fontSize: 25.0),
        backgroundColor: Color.fromARGB(255, 0, 70, 136),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _showNaturalesTitle(),
            Container(
              child: _showLoader
                  ? LoaderComponent(
                      text: 'Por favor espere...',
                    )
                  : _getContentNaturales(),
            ),
            SizedBox(height: 20),
            _showJuridicosTitle(),
            Container(
              child: _showLoader
                  ? LoaderComponent(
                      text: 'Por favor espere...',
                    )
                  : _getContentJuridicos(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 153, 4, 4),
        onPressed: () async {
          //_goAdd();
          String? result = await showDialog<String>(
            context: context,
            builder: (context) => const PopupPersoneriasWidget(),
          );

          if (result == 'natural') {
            _goAddPersonaNatural();
          } else if (result == 'juridica') {
            _goAddPersonaJuridica();
          }
        },
      ),
    );
  }

  _getContentNaturales() {
    if (_propietariosNaturalesList.length == 0) {
      return _noContentNaturales();
    } else {
      return _getListViewNaturales();
    }
  }

  _getContentJuridicos() {
    if (_propietariosJuridicosList.length == 0) {
      return _noContentJuridicos();
    } else {
      return _getListViewJuridicos();
    }
  }

  _noContentNaturales() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Text(
        'No hay Personas Naturales registradas como Propietarios.',
        style: TextStyle(fontSize: 20, color: Colors.white),
        textAlign: TextAlign.left,
      ),
    );
  }

  _noContentJuridicos() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Text(
        'No hay Personas Juridicas registradas como Propietarios.',
        style: TextStyle(fontSize: 20, color: Colors.white),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _showNaturalesTitle() {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 5.0),
      child: Text(
        'NATURALES',
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.white, fontSize: 25.0),
      ),
    );
  }

  Widget _showJuridicosTitle() {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 5.0),
      child: Text(
        'JURIDICOS',
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.white, fontSize: 25.0),
      ),
    );
  }

  _getListViewNaturales() {
    return RefreshIndicator(
      onRefresh: _getParcela,
      child: ListView(
        shrinkWrap: true,
        children: _propietariosNaturalesList.map(
          (e) {
            return Card(
              child: InkWell(
                onTap: () {
                  _goEditPersonaNatural(e);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.nombreCompleto,
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            e.cedula,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  _getListViewJuridicos() {
    return RefreshIndicator(
      onRefresh: _getParcela,
      child: ListView(
        shrinkWrap: true,
        children: _propietariosJuridicosList.map(
          (e) {
            return Card(
              child: InkWell(
                onTap: () {
                  _goEditPersonaJuridica(e);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.razonSocial ?? 'SD',
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            e.ruc,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  Future<Null> _getParcela() async {
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

    Response response =
        await ApiHelper.getParcela(widget.token, _parcela.codEnc);

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
      _parcela = response.result;
    });
  }

  Future<Null> _getPropietariosNaturalesParcela() async {
    setState(() {
      _showLoader = true;
    });

    //Response response = await ApiHelper.getParcelas(widget.token);

    List<CatPersonaNatural> response =
        await DictionaryDataBaseHelper.getPropietariosNaturalesParcela(
            _parcela.codEnc);

    setState(() {
      _showLoader = false;
    });

    setState(() {
      //_parcelas = response.result;

      _propietariosNaturalesList = response;
    });
  }

  void _goAddPersonaNatural() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropietarioNaturalScreen(
            token: widget.token,
            catPersonaNatural: CatPersonaNatural(
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
                profesion: ''
                /* propietario: Propietario(
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
                  expVinculo: ''), */
                )),
      ),
    );

    if (result == 'yes') {
      _getPropietariosNaturalesParcela();
      _getPropietariosJuridicosParcela();
    }
  }

  void _goEditPersonaNatural(CatPersonaNatural personaNatural) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonaNaturalScreen(
          token: widget.token,
          catPersonaNatural: personaNatural,
        ),
      ),
    );

    if (result == 'yes') {
      _getParcela();
    }
  }

  void _goEditPersonaJuridica(CatPersonaJuridica personaJuridica) async {
    /*  String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonaNaturalScreen(
          token: widget.token,
          catPersonaNatural: personaNatural,
        ),
      ),
    );

    if (result == 'yes') {
      _getParcela();
    } */
  }

  Future<Null> _getPropietariosJuridicosParcela() async {
    setState(() {
      _showLoader = true;
    });

    List<CatPersonaJuridica> response =
        await DictionaryDataBaseHelper.getPropietariosJuridicosParcela(
            _parcela.codEnc);

    setState(() {
      _showLoader = false;
    });

    setState(() {
      _propietariosJuridicosList = response;
    });
  }

  void _goAddPersonaJuridica() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropietarioJuridicoScreen(
            parcela: widget.parcela,
            catPersonaJuridica: CatPersonaJuridica(
              codEnc: '',
              ruc: '',
            )),
      ),
    );

    if (result == 'yes') {
      _getPropietariosNaturalesParcela();
      _getPropietariosJuridicosParcela();
    }
  }
}
