// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:surveycat_app/components/loader_component.dart';
import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/token.dart';

class PersonaNaturalScreen extends StatefulWidget {
  final Token token;
  final Parcela parcela;

  PersonaNaturalScreen({required this.token, required this.parcela});

  @override
  State<PersonaNaturalScreen> createState() => _PersonaNaturalScreenState();
}

class _PersonaNaturalScreenState extends State<PersonaNaturalScreen> {
  bool _showLoader = false;

  final maskFormatterCedula = MaskTextInputFormatter(mask: '###-######-####A');

  String _cedula = '';
  String _cedulaError = '';
  bool _cedulaShowError = false;
  TextEditingController _cedulaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.parcela.id == 0
            ? 'Nueva Persona Natural'
            : widget.parcela.codEnc),
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
                    'DATOS GENERALES',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                showCedula(),
                //Primer Nombre - Segundo Nombre
                //Primer Apellido - Segundo Apellido
                //Nacionalidad - Genero  - Edad
                //Estado Civil(combo) - Cantidad de hijos
                //Profesion u Oficio(combo)
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'DOMICILIO',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),

                  //Departamento (combo)- Municipio (combo)
                  //Barrio/Comarca (combo)
                  //Direccion
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'RELACIÓN CON LA PARCELA',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),

                  //Relacion con Parcela(combo)
                ),

                SizedBox(height: 20),
                //_showButtons(),
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

  Widget showCedula() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        controller: _cedulaController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Nombre de la Finca',
          errorText: _cedulaShowError ? _cedulaError : null,
        ),
        inputFormatters: [maskFormatterCedula],
        onChanged: (value) {
          _cedula = value;
        },
      ),
    );
  }
}
