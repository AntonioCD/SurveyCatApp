// ignore_for_file: prefer_const_constructors, prefer_is_empty

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:surveycat_app/components/loader_component.dart';
import 'package:surveycat_app/helpers/api_helper.dart';
import 'package:surveycat_app/helpers/database_helper.dart';
import 'package:surveycat_app/models/catPersonaNatural.dart';
import 'package:surveycat_app/models/historialParcela.dart';
import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/propietario.dart';
import 'package:surveycat_app/models/response.dart';

import 'package:surveycat_app/models/token.dart';
import 'package:surveycat_app/screens/historialParcela_screen.dart';
import 'package:surveycat_app/screens/informante_screen.dart';

class HistorialParcelasScreen extends StatefulWidget {
  final Token token;
  final Parcela parcela;

  HistorialParcelasScreen({required this.token, required this.parcela});

  @override
  State<HistorialParcelasScreen> createState() =>
      _HistorialParcelasScreenState();
}

class _HistorialParcelasScreenState extends State<HistorialParcelasScreen> {
  bool _showLoader = false;
  late Parcela _parcela;
  late List<HistorialParcela> _historialParcelaList;

  @override
  void initState() {
    super.initState();
    _parcela = widget.parcela;

    _getHistorialParcelaList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
      appBar: AppBar(
        title: Text('Reseña Historica Parcela' + ' : ' + _parcela.codEnc),
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
          _goAdd();

          return;
        },
      ),
    );
  }

  _getContent() {
    if (_historialParcelaList == null) {
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
          'No hay historial registrado para esta parcela.',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  _getListView() {
    return RefreshIndicator(
      onRefresh: _getHistorialParcelaList,
      child: ListView(
        shrinkWrap: true,
        children: _historialParcelaList.map((e) {
          return Card(
            child: InkWell(
              onTap: () {
                _goEditHistorialParcela(e);
              },
              child: Container(
                margin: EdgeInsets.all(10),
                //padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Anterior: ' + (e.anterior ?? 'SD'),
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Sucesor: ' + (e.sucesor ?? 'SD'),
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Transaccion :' + (e.tipoTrans ?? 'SD'),
                          style: TextStyle(fontSize: 25),
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

  void _goAdd() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistorialParcelaScreen(
            parcela: _parcela,
            historialParcela: HistorialParcela(
              id: 0,
              codPar: '',
              codEnc: '',
              sucesor: '',
              anterior: '',
              tipoTrans: '',
              docTrans: '',
              fechaTransaccion: null,
              anio_Transaccion: '',
            )),
      ),
    );

    if (result == 'yes') {
      _getHistorialParcelaList();
    }
  }

  Future<Null> _getHistorialParcelaList() async {
    setState(() {
      _showLoader = true;
    });

    List<HistorialParcela> response =
        await DictionaryDataBaseHelper.getHistorialParcelaPorCodEnc(
            _parcela.codEnc);

    setState(() {
      _showLoader = false;
      _historialParcelaList = response;
    });
  }

  void _goEditHistorialParcela(HistorialParcela historialParcela) async {
/*     String? result = await Navigator.push(
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
    } */
  }
}
