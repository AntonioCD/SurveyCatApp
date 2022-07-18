// ignore_for_file: file_names, prefer_const_constructors
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:surveycat_app/components/loader_component.dart';
import 'package:surveycat_app/helpers/api_helper.dart';
import 'package:surveycat_app/models/catDepartamento.dart';
import 'package:surveycat_app/models/catMunicipio.dart';
import 'package:surveycat_app/models/catPersonaNatural.dart';
import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/relacionConParcela.dart';
import 'package:surveycat_app/models/response.dart';
import 'package:surveycat_app/models/token.dart';

class PersonaNaturalScreen extends StatefulWidget {
  final Token token;
  final CatPersonaNatural catPersonaNatural;

  PersonaNaturalScreen({required this.token, required this.catPersonaNatural});

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

  String _primerNombre = '';
  String _primerNombreError = '';
  bool _primerNombreShowError = false;
  TextEditingController _primerNombreController = TextEditingController();

  String _segundoNombre = '';
  String _segundoNombreError = '';
  bool _segundoNombreShowError = false;
  TextEditingController _segundoNombreController = TextEditingController();

  String _primerApellido = '';
  String _primerApellidoError = '';
  bool _primerApellidoShowError = false;
  TextEditingController _primerApellidoController = TextEditingController();

  String _segundoApellido = '';
  String _segundoApellidoError = '';
  bool _segundoApellidoShowError = false;
  TextEditingController _segundoApellidoController = TextEditingController();

  String _edad = '';
  String _edadError = '';
  bool _edadShowError = false;
  TextEditingController _edadController = TextEditingController();

  String _departamentoCodDep = '0';
  String _departamentoCodDepError = '';
  bool _departamentoCodDepShowError = false;
  List<CatDepartamento> _departamentos = [];

  String _municipioCodMun = '0';
  String _municipioCodMunError = '';
  bool _municipioCodMunShowError = false;
  List<CatMunicipio> _municipios = [];

  String _direccionDomiciliar = '';
  String _direccionDomiciliarError = '';
  bool _direccionDomiciliarShowError = false;
  TextEditingController _direccionDomiciliarController =
      TextEditingController();

  int _relacionConParcelaId = 0;
  String _relacionConParcelaIdError = '';
  bool _relacionConParcelaIdShowError = false;
  List<RelacionConParcela> _relacionesConParcela = [];

  String _autorNotario = '';
  String _autorNotarioError = '';
  bool _autorNotarioShowError = false;
  TextEditingController _autorNotarioController = TextEditingController();

  late DateTime _fechaAdquisicion;
  String _fechaAdquisicionError = '';
  bool _fechaAdquisicionShowError = false;
  TextEditingController _fechaAdquisicionController = TextEditingController();

  late DateTime _fechaRegistro;
  String _fechaRegistroError = '';
  bool _fechaRegistroShowError = false;
  TextEditingController _fechaRegistroController = TextEditingController();

  String _finca = '';
  String _fincaError = '';
  bool _fincaShowError = false;
  TextEditingController _fincaController = TextEditingController();

  String _tomo = '';
  String _tomoError = '';
  bool _tomoShowError = false;
  TextEditingController _tomoController = TextEditingController();

  String _folio = '';
  String _folioError = '';
  bool _folioShowError = false;
  TextEditingController _folioController = TextEditingController();

  String _asiento = '';
  String _asientoError = '';
  bool _asientoShowError = false;
  TextEditingController _asientoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catPersonaNatural.codEnc == ''
            ? 'Nueva Persona Natural'
            : widget.catPersonaNatural.nombreCompleto),
        backgroundColor: Color.fromARGB(255, 0, 133, 138),
      ),
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
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
                _showPrimerNombreSegundoNombre(),
                _showPrimerApellidoSegundoApellido(),
                _showCedulaEdad(),
                //NacionalidadGenero
                //_showEstadoCivilHijos(),
                //_showProfesionOficio(),

                //Nacionalidad - Genero  - Edad
                //Estado Civil(combo) - Cantidad de hijos
                //Profesion u Oficio(combo)
                SizedBox(height: 20),
                _showDomicilioLabel(),
                _showDepartamentoMunicipio(),
                _showDireccionDomiciliar(),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'DATOS DE PROPIETARIO',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                _showRelacionConParcela(),
                _showAutorNotario(),
                _showFechaAdquisicionFechaRegistro(),
                _showFincaTomo(),
                _showFolioAsiento(),
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

  Widget _showPrimerNombreSegundoNombre() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showPrimerNombre(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showSegundoNombre(),
          ),
        ],
      ),
    );
  }

  Widget _showPrimerNombre() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _primerNombreController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Primer Nombre',
          errorText: _primerNombreShowError ? _primerNombreError : null,
        ),
        onChanged: (value) {
          _primerNombre = value;
        },
      ),
    );
  }

  Widget _showSegundoNombre() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _segundoNombreController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Segundo Nombre',
          errorText: _segundoNombreShowError ? _segundoNombreError : null,
        ),
        onChanged: (value) {
          _segundoNombre = value;
        },
      ),
    );
  }

  Widget _showPrimerApellidoSegundoApellido() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showPrimerApellido(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showSegundoApellido(),
          ),
        ],
      ),
    );
  }

  Widget _showPrimerApellido() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _primerApellidoController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Primer Apellido',
          errorText: _primerApellidoShowError ? _primerApellidoError : null,
        ),
        onChanged: (value) {
          _primerApellido = value;
        },
      ),
    );
  }

  Widget _showSegundoApellido() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _segundoApellidoController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Segundo Apellido',
          errorText: _segundoApellidoShowError ? _segundoApellidoError : null,
        ),
        onChanged: (value) {
          _segundoApellido = value;
        },
      ),
    );
  }

  Widget _showCedulaEdad() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showCedula(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showEdad(),
          ),
        ],
      ),
    );
  }

  Widget _showCedula() {
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
          hintText: 'Cedula',
          errorText: _cedulaShowError ? _cedulaError : null,
        ),
        inputFormatters: [maskFormatterCedula],
        onChanged: (value) {
          _cedula = value;
        },
      ),
    );
  }

  Widget _showEdad() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _edadController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Edad',
          errorText: _edadShowError ? _edadError : null,
        ),
        onChanged: (value) {
          _edad = value;
        },
      ),
    );
  }

  Widget _showDomicilioLabel() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Text(
        'Domicilio',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
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

  Widget _showDireccionDomiciliar() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _direccionDomiciliarController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Direccion Domiciliar',
          errorText:
              _direccionDomiciliarShowError ? _direccionDomiciliarError : null,
        ),
        onChanged: (value) {
          _direccionDomiciliar = value;
        },
      ),
    );
  }

  Widget _showRelacionParcelaLabel() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Text(
        'Relacion con Parcela',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    );
  }

  Widget _showRelacionConParcela() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: _relacionesConParcela.length == 0
            ? Text('Cargando relacion con parcela...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black),
                items: _getComboRelacionConParcela(),
                value: _relacionConParcelaId,
                onChanged: (option) {
                  setState(() {
                    _relacionConParcelaId = option as int;
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

  List<DropdownMenuItem<int>> _getComboRelacionConParcela() {
    List<DropdownMenuItem<int>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Seleccione Relacion con Parcela...'),
      value: 0,
    ));

    _relacionesConParcela.forEach((relacionConParcela) {
      list.add(DropdownMenuItem(
        child: Text(relacionConParcela.relacion),
        value: relacionConParcela.id,
      ));
    });

    return list;
  }

  Widget _showAutorNotario() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _autorNotarioController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Autor Notario',
          errorText: _autorNotarioShowError ? _autorNotarioError : null,
        ),
        onChanged: (value) {
          _autorNotario = value;
        },
      ),
    );
  }

  Widget _showFechaAdquisicionFechaRegistro() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showFechaAdquisicion(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showFechaRegistro(),
          ),
        ],
      ),
    );
  }

  Widget _showFechaAdquisicion() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
          controller: _fechaAdquisicionController,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintText: 'Fecha de Adquisicion',
            errorText:
                _fechaAdquisicionShowError ? _fechaAdquisicionError : null,
          ),
          onTap: () {
            _pickDate(context, 'fechaAdquisicion', _fechaAdquisicionController);
          }),
    );
  }

  Widget _showFechaRegistro() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
          controller: _fechaRegistroController,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintText: 'Fecha de Registro',
            errorText: _fechaRegistroShowError ? _fechaRegistroError : null,
          ),
          onTap: () {
            _pickDate(context, 'fechaRegistro', _fechaRegistroController);
          }),
    );
  }

  Widget _showFincaTomo() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showFinca(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showTomo(),
          ),
        ],
      ),
    );
  }

  Widget _showFinca() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _fincaController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Finca',
          errorText: _fincaShowError ? _fincaError : null,
        ),
        onChanged: (value) {
          _finca = value;
        },
      ),
    );
  }

  Widget _showTomo() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _tomoController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Tomo',
          errorText: _tomoShowError ? _tomoError : null,
        ),
        onChanged: (value) {
          _tomo = value;
        },
      ),
    );
  }

  Widget _showFolioAsiento() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showFolio(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showAsiento(),
          ),
        ],
      ),
    );
  }

  Widget _showFolio() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _folioController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Folio',
          errorText: _folioShowError ? _folioError : null,
        ),
        onChanged: (value) {
          _folio = value;
        },
      ),
    );
  }

  Widget _showAsiento() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _asientoController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Asiento',
          errorText: _asientoShowError ? _asientoError : null,
        ),
        onChanged: (value) {
          _asiento = value;
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

    if (this.mounted) {
      setState(() {
        _showLoader = false;
      });
    }

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

    if (this.mounted) {
      setState(() {
        _departamentos = response.result;
      });
    }
  }

  Future<Null> _getRelacionConParcela() async {
    if (this.mounted) {
      setState(() {
        _showLoader = true;
      });
    }

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

    Response response = await ApiHelper.getRelacionesParcela(widget.token);

    if (this.mounted) {
      setState(() {
        _showLoader = false;
      });
    }

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
    if (this.mounted) {
      setState(() {
        _relacionesConParcela = response.result;
      });
    }
  }

  void _loadData() async {
    await _getDepartamentos();
    await _getRelacionConParcela();
    //_loadFieldValues();
  }

  String getTextFromDate(String tipoFecha) {
    if (tipoFecha == 'fechaAdquisicion' && _fechaAdquisicion != null) {
      return '${_fechaAdquisicion.day}/${_fechaAdquisicion.month}/${_fechaAdquisicion.year}';
    }

    if (tipoFecha == 'fechaRegistro' && _fechaRegistro != null) {
      return '${_fechaRegistro.day}/${_fechaRegistro.month}/${_fechaRegistro.year}';
    }

    return 'Seleccionar fecha';
  }

  Future _pickDate(BuildContext context, String tipoFecha,
      TextEditingController textEditingController) async {
    final initialDate = DateTime.now();
    final pickedDate = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate == null) return;

    setState(() {
      if (tipoFecha == 'fechaAdquisicion') {
        _fechaAdquisicion = pickedDate;
        textEditingController.text = getTextFromDate(tipoFecha);
      }

      if (tipoFecha == 'fechaRegistro') {
        _fechaRegistro = pickedDate;
        textEditingController.text = getTextFromDate(tipoFecha);
      }
    });
  }

  bool _validateFields() {
    bool isValid = true;

    /*  if (_vehicleTypeId == 0) {
      isValid = false;
      _vehicleTypeIdShowError = true;
      _vehicleTypeIdError = 'Debes seleccionar un tipo de vehículo.';
    } else {
      _vehicleTypeIdShowError = false;
    }

    if (_brandId == 0) {
      isValid = false;
      _brandIdShowError = true;
      _brandIdError = 'Debes seleccionar una marca.';
    } else {
      _brandIdShowError = false;
    } */

    if (_primerNombre.isEmpty) {
      isValid = false;
      _primerNombreShowError = true;
      _primerNombreError = 'Debes ingresar un color.';
    } else {
      _primerNombreShowError = false;
    }

    if (_primerApellido.isEmpty) {
      isValid = false;
      _primerApellidoShowError = true;
      _primerApellidoError = 'Debes ingresar una línea.';
    } else {
      _primerApellidoShowError = false;
    }

    if (_cedula.isEmpty) {
      isValid = false;
      _cedulaShowError = true;
      _cedulaError = 'Debes ingresar una línea.';
    } else {
      _cedulaShowError = false;
    }

    setState(() {});
    return isValid;
  }

  void _save() {
    if (!_validateFields()) {
      return;
    }

    widget.catPersonaNatural.codEnc.isEmpty ? _addRecord() : _saveRecord();
  }

  void _addRecord() async {
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

    Map<String, dynamic> request = {
      'codPar': widget.catPersonaNatural.codEnc,
      'codEnc': widget.catPersonaNatural.codEnc,
      'nombre1': _primerNombre,
      'nombre2': _segundoNombre,
      'apellido1': _primerApellido,
      'apellido2': _segundoApellido,
      'cedula': _cedula,
    };

    Response response = await ApiHelper.post(
        '/api/CatPersonasNaturales/Create', request, widget.token);

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

  void _saveRecord() async {
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

    Map<String, dynamic> request = {
      'codPar': widget.catPersonaNatural.codEnc,
      'codEnc': widget.catPersonaNatural.codEnc,
      'nombre1': _primerNombre,
      'nombre2': _segundoNombre,
      'apellido1': _primerApellido,
      'apellido2': _segundoApellido,
      'cedula': _cedula,
    };

    Response response = await ApiHelper.put('/api/CatPersonasNaturales/Edit/',
        widget.catPersonaNatural.codEnc.toString(), request, widget.token);

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
}
