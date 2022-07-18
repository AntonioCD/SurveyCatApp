// ignore_for_file: prefer_const_constructors, prefer_is_empty

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:surveycat_app/components/loader_component.dart';
import 'package:surveycat_app/helpers/api_helper.dart';
import 'package:surveycat_app/helpers/database_helper.dart';
import 'package:surveycat_app/models/catPersonaNatural.dart';
import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/propietario.dart';
import 'package:surveycat_app/models/response.dart';

import 'package:surveycat_app/models/token.dart';
import 'package:surveycat_app/screens/informante_screen.dart';

class InformantesScreen extends StatefulWidget {
  final Token token;
  final Parcela parcela;

  InformantesScreen({required this.token, required this.parcela});

  @override
  State<InformantesScreen> createState() => _InformantesScreenState();
}

class _InformantesScreenState extends State<InformantesScreen> {
  bool _showLoader = false;
  late Parcela _parcela;
  late List<CatPersonaNatural> _informante;

  @override
  void initState() {
    super.initState();
    _parcela = widget.parcela;

    _getInformantes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
      appBar: AppBar(
        title: Text('Informantes' + ' : ' + _parcela.codEnc),
        titleTextStyle: TextStyle(fontSize: 25.0),
        backgroundColor: Color.fromARGB(255, 0, 70, 136),
      ),
      body: Column(
        children: [
          Center(
            child: _showLoader
                ? LoaderComponent(
                    text: 'Por favor espere...',
                  )
                : _getContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 153, 4, 4),
        onPressed: () async {
          //_goAdd();

          return;
        },
      ),
    );
  }

  _getContent() {
    if (_informante == null) {
      return _noContent();
    } else {
      return _getListView();
    }
  }

  _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          'No hay Informante registrado para esta parcela.',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  _getListView() {
    return RefreshIndicator(
      onRefresh: _getInformantes,
      child: ListView(
        shrinkWrap: true,
        children: _informante.map((e) {
          return Card(
            child: InkWell(
              onTap: () {
                _goEditInformante(e);
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
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
        }).toList(),
      ),
    );
  }

  Future<Null> _getInformantes() async {
    setState(() {
      _showLoader = true;
    });

    List<CatPersonaNatural> response =
        await DictionaryDataBaseHelper.getInformante(
            _parcela.codEnc, _parcela.id_informante);

    setState(() {
      _showLoader = false;
      _informante = response;
    });
  }

  void _goAddPersonaNatural() async {
    /* 
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonaNaturalScreen(
            token: widget.token,
            catPersonaNatural: CatPersonaNatural(
              id: 0,
              codPar: _parcela.codEnc,
              codEnc: _parcela.codEnc,
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
              profesion: '',
              propietario: Propietario(
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
                  expVinculo: ''),
            )),
      ), */
    /* );

    if (result == 'yes') {
      _getParcela();
    } */
  }

  void _goEditInformante(CatPersonaNatural personaNatural) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InformanteScreen(
          token: widget.token,
          catPersonaNatural: personaNatural,
        ),
      ),
    );

    if (result == 'yes') {
      _getInformantes();
    }
  }
}
