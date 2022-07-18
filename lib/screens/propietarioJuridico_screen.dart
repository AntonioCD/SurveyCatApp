// ignore_for_file: file_names, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:surveycat_app/helpers/database_helper.dart';
import 'package:surveycat_app/models/catDepartamento.dart';
import 'package:surveycat_app/models/catDocumentos.dart';
import 'package:surveycat_app/models/catEstadoCivil.dart';
import 'package:surveycat_app/models/catMunicipio.dart';
import 'package:surveycat_app/models/catPersonaJuridica.dart';
import 'package:surveycat_app/models/catPersonaNatural.dart';
import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/relacionConParcela.dart';
import 'package:surveycat_app/models/relacionInformanteParcela.dart';
import 'package:surveycat_app/models/stbNacionalidad.dart';
import 'package:surveycat_app/models/token.dart';

class PropietarioJuridicoScreen extends StatefulWidget {
  final Parcela parcela;
  final CatPersonaJuridica catPersonaJuridica;

  PropietarioJuridicoScreen(
      {required this.parcela, required this.catPersonaJuridica});

  @override
  State<PropietarioJuridicoScreen> createState() =>
      _PropietarioJuridicoScreenState();
}

class _PropietarioJuridicoScreenState extends State<PropietarioJuridicoScreen> {
  @override
  void initState() {
    super.initState();
    //_loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.catPersonaJuridica.codEnc == ''
              ? 'Nuevo Propietario/Poseedor Juridico'
              : widget.catPersonaJuridica.razonSocial ?? 'SD'),
          titleTextStyle: TextStyle(fontSize: 25.0),
          backgroundColor: Color.fromARGB(255, 0, 70, 136),
        ),
        backgroundColor: Color.fromARGB(255, 15, 15, 15),
        body: Stack(children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: ListView(
              padding: EdgeInsets.only(top: 10.0),
              children: <Widget>[
                _showButtons(),
              ],
            ),
          )
        ]));
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
        onPressed: () => {},
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
}
