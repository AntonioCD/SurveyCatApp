// ignore_for_file: prefer_const_constructors
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

import 'package:surveycat_app/components/loader_component.dart';
import 'package:surveycat_app/helpers/api_helper.dart';
import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/response.dart';
import 'package:surveycat_app/models/token.dart';
import 'package:surveycat_app/screens/parcela_screen.dart';

class ParcelasScreen extends StatefulWidget {
  final Token token;

  ParcelasScreen({required this.token});

  @override
  State<ParcelasScreen> createState() => _ParcelasScreenState();
}

class _ParcelasScreenState extends State<ParcelasScreen> {
  List<Parcela> _parcelas = [];
  bool _showLoader = false;

  @override
  void initState() {
    super.initState();
    _getParcelas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
      appBar: AppBar(
        title: Text('Parcelas'),
        backgroundColor: Color.fromARGB(255, 11, 131, 0),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ParcelaScreen(
                  token: widget.token,
                  parcela: Parcela(
                      id: 0,
                      codEnc: '',
                      areaEstimada: 0,
                      presentaConflicto: false,
                      fechaEnc: '',
                      propietariosCount: 0)),
            ),
          );
        },
      ),
    );
  }

  void _getParcelas() async {
    setState(() {
      _showLoader = true;
    });

    Response response = await ApiHelper.getParcelas(widget.token.token);

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
      _parcelas = response.result;
    });
  }

  Widget _getContent() {
    return _parcelas.length == 0 ? _noContent() : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          'No hay parcelas almacenadas.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _getListView() {
    return ListView(
      children: _parcelas.map((e) {
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParcelaScreen(
                    token: widget.token,
                    parcela: e,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.codEnc,
                    style: TextStyle(fontSize: 20),
                  ),
                  Icon(Icons.arrow_circle_right),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
