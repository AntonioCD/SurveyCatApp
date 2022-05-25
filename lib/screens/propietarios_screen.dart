// ignore_for_file: prefer_const_constructors, prefer_is_empty

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:surveycat_app/components/loader_component.dart';
import 'package:surveycat_app/helpers/api_helper.dart';
import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/response.dart';

import 'package:surveycat_app/models/token.dart';

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

  @override
  void initState() {
    super.initState();
    _parcela = widget.parcela;

    _getParcela();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
      appBar: AppBar(
        title: Text('Propietarios'),
        backgroundColor: Color.fromARGB(255, 0, 133, 138),
      ),
      body: Center(
        child: _showLoader
            ? LoaderComponent(
                text: 'Por favor espere...',
              )
            : _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow[800],
        onPressed: () {
          //_goAdd();
        },
      ),
    );
  }

  _getContent() {
    return _parcela.catPersonasNaturales.isEmpty
        ? _noContent()
        : _getListView();
  }

  _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          'No hay Personas Naturales registradas como Propietarios.',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  _getListView() {
    return RefreshIndicator(
      onRefresh: _getParcela,
      child: ListView(
        children: _parcela.catPersonasNaturales.map((e) {
          return Card(
            child: InkWell(
              onTap: () {
                //_goEdit(e);
                //_showOptions(e);
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.nombreCompleto,
                      style: TextStyle(fontSize: 20),
                    ),
                    //Icon(Icons.more_vert),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
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
}
