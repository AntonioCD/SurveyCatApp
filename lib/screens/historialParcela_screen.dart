// ignore_for_file: file_names, prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:surveycat_app/helpers/database_helper.dart';
import 'package:surveycat_app/models/catDepartamento.dart';
import 'package:surveycat_app/models/catDocumentos.dart';
import 'package:surveycat_app/models/catEstadoCivil.dart';
import 'package:surveycat_app/models/catMunicipio.dart';
import 'package:surveycat_app/models/catPersonaNatural.dart';
import 'package:surveycat_app/models/historialParcela.dart';
import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/relacionConParcela.dart';
import 'package:surveycat_app/models/relacionInformanteParcela.dart';
import 'package:surveycat_app/models/stbNacionalidad.dart';
import 'package:surveycat_app/models/tipoTransaccion.dart';
import 'package:surveycat_app/models/token.dart';

class HistorialParcelaScreen extends StatefulWidget {
  final Parcela parcela;
  final HistorialParcela historialParcela;

  HistorialParcelaScreen(
      {required this.parcela, required this.historialParcela});

  @override
  State<HistorialParcelaScreen> createState() => _HistorialParcelaScreenState();
}

class _HistorialParcelaScreenState extends State<HistorialParcelaScreen> {
  bool _showLoader = false;
  final maskFormatterAnio = MaskTextInputFormatter(mask: '####');

  String _anterior = '';
  String _anteriorError = '';
  bool _anteriorShowError = false;
  TextEditingController _anteriorController = TextEditingController();

  String _sucesor = '';
  String _sucesorError = '';
  bool _sucesorShowError = false;
  TextEditingController _sucesorController = TextEditingController();

  int _tipoTransaccionId = 0;
  String _tipoTransaccionIdError = '';
  bool _tipoTransaccionIdShowError = false;
  List<TipoTransaccion> _tiposTransaccionList = [];

  String _tipoDocumentoCodDocum = '0';
  String _tipoDocumentoCodDocumError = '';
  bool _tipoDocumentoCodDocumShowError = false;
  List<Cat_Documentos> _tiposDocumentosList = [];

  String _descripcionDocumento = '';
  String _descripcionDocumentoError = '';
  bool _descripcionDocumentoShowError = false;
  TextEditingController _descripcionDocumentoController =
      TextEditingController();

  DateTime? _fechaTransaccion = null;
  String _fechaTransaccionError = '';
  bool _fechaTransaccionShowError = false;
  TextEditingController _fechaTransaccionController = TextEditingController();

  String _anioTransaccion = '';
  String _anioTransaccionError = '';
  bool _anioTransaccionShowError = false;
  TextEditingController _anioTransaccionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.historialParcela.id == 0
              ? 'Nueva Reseña Historica'
              : widget.historialParcela.codEnc),
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
                _showAnterior(),
                _showSucesor(),
                _show_TipoTransaccionCbo_TipoDocumentoCbo(),
                _showDescripcionTipoDocumento(),
                _show_FechaTransaccion_AnioTransaccion(),
                _showButtons(),
              ],
            ),
          )
        ]));
  }

  Widget _showAnterior() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _anteriorController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Anterior',
          errorText: _anteriorShowError ? _anteriorError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        onChanged: (value) {
          _anterior = value;
        },
      ),
    );
  }

  Widget _showSucesor() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _sucesorController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Sucesor',
          errorText: _sucesorShowError ? _sucesorError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        onChanged: (value) {
          _sucesor = value;
        },
      ),
    );
  }

  Widget _show_TipoTransaccionCbo_TipoDocumentoCbo() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showTipoDeTransaccionCombo(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showTipoDeDocumentoCombo(),
          ),
        ],
      ),
    );
  }

  Widget _showTipoDeTransaccionCombo() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _tiposTransaccionList.length == 0
            ? Text('Cargando catalogo de tipos...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboTipoDeTransaccion(),
                isExpanded: true,
                value: _tipoTransaccionId,
                onChanged: (option) {
                  setState(() {
                    _tipoTransaccionId = option as int;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText: _tipoTransaccionIdShowError
                      ? _tipoTransaccionIdError
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<int>> _getComboTipoDeTransaccion() {
    List<DropdownMenuItem<int>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Tipos de transaccion...'),
      value: 0,
    ));

    _tiposTransaccionList.forEach((tipoTransaccion) {
      list.add(DropdownMenuItem(
        child: Text(tipoTransaccion.descripcion),
        value: tipoTransaccion.idTipoTransaccion,
      ));
    });

    return list;
  }

  Widget _showTipoDeDocumentoCombo() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _tiposDocumentosList.length == 0
            ? Text('Cargando catalogo de tipos...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboTipoDeDocumento(),
                value: _tipoDocumentoCodDocum,
                onChanged: (String? option) {
                  setState(() {
                    _tipoDocumentoCodDocum = option!;
                    _getDescripcionDocumento(_tipoDocumentoCodDocum);
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText: _tipoDocumentoCodDocumShowError
                      ? _tipoDocumentoCodDocumError
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<String>> _getComboTipoDeDocumento() {
    List<DropdownMenuItem<String>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Tipos de documentos...'),
      value: '0',
    ));

    _tiposDocumentosList.forEach((tipoDocumento) {
      list.add(DropdownMenuItem(
        child: Text(tipoDocumento.codDocum),
        value: tipoDocumento.codDocum,
      ));
    });

    return list;
  }

  Widget _showDescripcionTipoDocumento() {
    return Container(
        padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
        child: TextField(
          controller: _descripcionDocumentoController,
          decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
            ),
            filled: true,
            fillColor: Colors.yellow[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintText: 'Descripcion de Tipo de Documento',
            errorText: _descripcionDocumentoShowError
                ? _descripcionDocumentoError
                : null,
          ),
          enabled: false,
          maxLines: null,
          style:
              TextStyle(fontSize: 20.0, height: 1.0, color: Colors.grey[900]),
          onChanged: (value) {
            _descripcionDocumento = value;
          },
        ));
  }

  Widget _show_FechaTransaccion_AnioTransaccion() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showFechaTransaccion(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showAnioTransaccion(),
          ),
        ],
      ),
    );
  }

  Widget _showFechaTransaccion() {
    return Container(
        padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
        child: TextField(
            controller: _fechaTransaccionController,
            readOnly: true,
            decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Fecha de la Transacción',
                errorText:
                    _fechaTransaccionShowError ? _fechaTransaccionError : null,
                suffixIcon: Icon(Icons.calendar_month)),
            style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
            onTap: () {
              _pickDateFechaTransaccion();
            }));
  }

  Widget _showAnioTransaccion() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: TextField(
        controller: _anioTransaccionController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Año de la Transaccion',
          errorText: _anioTransaccionShowError ? _anioTransaccionError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        inputFormatters: [maskFormatterAnio],
        onChanged: (value) {
          _anioTransaccion = value;
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

  Future<Null> _getTiposDeTransacciones() async {
    setState(() {
      _showLoader = true;
    });

    List<TipoTransaccion> response =
        await DictionaryDataBaseHelper.getTiposTransacciones();

    setState(() {
      _showLoader = false;
      _tiposTransaccionList = response;
    });
  }

  Future<Null> _getTiposDeDocumentos() async {
    setState(() {
      _showLoader = true;
    });

    List<Cat_Documentos> response =
        await DictionaryDataBaseHelper.getTiposDocumentos();

    setState(() {
      _showLoader = false;
      _tiposDocumentosList = response;
    });
  }

  Future<Null> _getDescripcionDocumento(String codDocum) async {
    setState(() {
      _showLoader = true;
    });

    Cat_Documentos? documento =
        await DictionaryDataBaseHelper.getCatDocumentoPorCodDocum(codDocum);

    setState(() {
      _showLoader = false;
      if (documento != null) {
        _descripcionDocumento = documento.documento;
        _descripcionDocumentoController.text = documento.documento;
      } else {
        _descripcionDocumento = '';
        _descripcionDocumentoController.text = '';
      }
    });
  }

  void _loadData() async {
    await _getTiposDeTransacciones();
    await _getTiposDeDocumentos();
  }

  void _pickDateFechaTransaccion() {
    //DateTime? pickeddate;

    DatePicker.showDatePicker(context,
        theme: DatePickerTheme(
            containerHeight: 210.0,
            itemHeight: 50.0,
            itemStyle: TextStyle(fontSize: 25.0)),
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime.now(), onConfirm: (date) {
      setState(() {
        if (date != null) {
          _fechaTransaccion = date;
          _fechaTransaccionController.text =
              "${date.day}/${date.month}/${date.year}";
        }
      });
    }, currentTime: DateTime.now(), locale: LocaleType.es);
  }
}
