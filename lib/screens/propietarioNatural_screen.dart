// ignore_for_file: file_names, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:surveycat_app/helpers/database_helper.dart';
import 'package:surveycat_app/models/catDepartamento.dart';
import 'package:surveycat_app/models/catDocumentos.dart';
import 'package:surveycat_app/models/catEstadoCivil.dart';
import 'package:surveycat_app/models/catMunicipio.dart';
import 'package:surveycat_app/models/catPersonaNatural.dart';
import 'package:surveycat_app/models/relacionConParcela.dart';
import 'package:surveycat_app/models/relacionInformanteParcela.dart';
import 'package:surveycat_app/models/stbNacionalidad.dart';
import 'package:surveycat_app/models/token.dart';

class PropietarioNaturalScreen extends StatefulWidget {
  final Token token;
  final CatPersonaNatural catPersonaNatural;

  PropietarioNaturalScreen(
      {required this.token, required this.catPersonaNatural});

  @override
  State<PropietarioNaturalScreen> createState() =>
      _PropietarioNaturalScreenState();
}

class _PropietarioNaturalScreenState extends State<PropietarioNaturalScreen> {
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

  int _generoId = 0;
  String _generoIdError = '';
  bool _generoIdShowError = false;

  int _catEstadoCivilId = 0;
  String _catEstadoCivilIdError = '';
  bool _catEstadoCivilIdShowError = false;
  List<CatEstadoCivil> _catEstadoCivilList = [];

  int _stbNacionalidadId = 0;
  String _stbNacionalidadIdError = '';
  bool _stbNacionalidadIdShowError = false;
  List<StbNacionalidad> _stbNacionalidadList = [];

  String _profesion = '';
  String _profesionError = '';
  bool _profesionShowError = false;
  TextEditingController _profesionController = TextEditingController();

  String _departamentoCodDep = '0';
  String _departamentoCodDepError = '';
  bool _departamentoCodDepShowError = false;
  List<CatDepartamento> _departamentosList = [];

  String _municipioCodMun = '0';
  String _municipioCodMunError = '';
  bool _municipioCodMunShowError = false;
  List<CatMunicipio> _municipiosList = [];

  String _direccionDomiciliar = '';
  String _direccionDomiciliarError = '';
  bool _direccionDomiciliarShowError = false;
  TextEditingController _direccionDomiciliarController =
      TextEditingController();

  String _relacionPropietarioParcelaValue = '0';
  String _relacionPropietarioParcelaValueError = '';
  bool _relacionPropietarioParcelaValueShowError = false;
  List<RelacionConParcela> _relacionPropietarioParcelaList = [];

  String _personasDerechoSimilar = '';
  String _personasDerechoSimilarError = '';
  bool _personasDerechoSimilarShowError = false;
  TextEditingController _personasDerechoSimilarController =
      TextEditingController();

  bool _presentaDocumento = false;

  String _tipoDocumentoCodDocum = '0';
  String _tipoDocumentoCodDocumError = '';
  bool _tipoDocumentoCodDocumShowError = false;
  List<Cat_Documentos> _tiposDocumentosList = [];

  String _descripcionDocumento = '';
  String _descripcionDocumentoError = '';
  bool _descripcionDocumentoShowError = false;
  TextEditingController _descripcionDocumentoController =
      TextEditingController();

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
              ? 'Nuevo Propietario/Poseedor'
              : widget.catPersonaNatural.nombreCompleto),
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
                _showDatosDelEntrevistadoTitle(),
                _showPrimerNombreSegundoNombre(),
                _showPrimerApellidoSegundoApellido(),
                _show_Cedula_Edad(),
                _show_Genero_EstadoCivil(),
                //_show_Nacionalidad_Profesion(),
                _showNacionalidadCombo(),
                _showProfesion(),
                _showDomicilioLabel(),
                _showDepartamentoMunicipio(),
                _showDireccionDomiciliar(),
                _showDatosLegalesTitle(),
                _show_RelacionConParcela_CantPersonasMismoDerecho(),
                _show_PresentaDocumentoChk_TipoDocumentoCbo(),
                _showDescripcionTipoDocumento(),
                _showAutorNotario(),
                _showDatosRegistralesLabel(),
                _show_FechaAdquisicion_FechaRegistro(),
                _show_Finca_Tomo(),
                _show_Folio_Asiento(),
                _showButtons(),
              ],
            ),
          )
        ]));
  }

  Widget _showDatosDelEntrevistadoTitle() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Text(
        'DATOS GENERALES',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 25.0),
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
          hintText: 'Primer Nombre',
          errorText: _primerNombreShowError ? _primerNombreError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
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
          hintText: 'Segundo Nombre',
          errorText: _segundoNombreShowError ? _segundoNombreError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
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
          hintText: 'Primer Apellido',
          errorText: _primerApellidoShowError ? _primerApellidoError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
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
          hintText: 'Segundo Apellido',
          errorText: _segundoApellidoShowError ? _segundoApellidoError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        onChanged: (value) {
          _segundoApellido = value;
        },
      ),
    );
  }

  Widget _show_Cedula_Edad() {
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
          hintText: 'Cedula',
          errorText: _cedulaShowError ? _cedulaError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
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
          hintText: 'Edad',
          errorText: _edadShowError ? _edadError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        onChanged: (value) {
          _edad = value;
        },
      ),
    );
  }

  Widget _show_Genero_EstadoCivil() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showGeneroCombo(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showEstadoCivilCombo(),
          ),
        ],
      ),
    );
  }

  Widget _showGeneroCombo() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: getDropdownItemsGenero.length == 0
            ? Text('Cargando catalogo de genero...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: getDropdownItemsGenero,
                value: _generoId,
                onChanged: (option) {
                  setState(() {
                    _generoId = option as int;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText: _generoIdShowError ? _generoIdError : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<int>> get getDropdownItemsGenero {
    List<DropdownMenuItem<int>> menuItems = [
      DropdownMenuItem(child: Text("Genero..."), value: 0),
      DropdownMenuItem(child: Text("M"), value: 1),
      DropdownMenuItem(child: Text("F"), value: 2),
    ];
    return menuItems;
  }

  Widget _showEstadoCivilCombo() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _catEstadoCivilList.length == 0
            ? Text('Cargando catalogo de servidumbre...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboEstadoCivil(),
                value: _catEstadoCivilId,
                onChanged: (option) {
                  setState(() {
                    _catEstadoCivilId = option as int;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText: _catEstadoCivilIdShowError
                      ? _catEstadoCivilIdError
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<int>> _getComboEstadoCivil() {
    List<DropdownMenuItem<int>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Estado Civil...'),
      value: 0,
    ));

    _catEstadoCivilList.forEach((catEstadoCivil) {
      list.add(DropdownMenuItem(
        child: Text(catEstadoCivil.descripcion),
        value: catEstadoCivil.id,
      ));
    });

    return list;
  }

  Widget _show_Nacionalidad_Profesion() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showNacionalidadCombo(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showProfesion(),
          ),
        ],
      ),
    );
  }

  Widget _showNacionalidadCombo() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _stbNacionalidadList.length == 0
            ? Text('Cargando catalogo de servidumbre...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboNacionalidad(),
                value: _stbNacionalidadId,
                onChanged: (option) {
                  setState(() {
                    _stbNacionalidadId = option as int;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText: _stbNacionalidadIdShowError
                      ? _stbNacionalidadIdError
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<int>> _getComboNacionalidad() {
    List<DropdownMenuItem<int>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Nacionalidad...'),
      value: 0,
    ));

    _stbNacionalidadList.forEach((stbNacionalidad) {
      list.add(DropdownMenuItem(
        child: Text(stbNacionalidad.singularNac),
        value: stbNacionalidad.stbNacionalidadID,
      ));
    });

    return list;
  }

  Widget _showProfesion() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _profesionController,
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
          hintText: 'Profesion',
          errorText: _profesionShowError ? _profesionError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        onChanged: (value) {
          _profesion = value;
        },
      ),
    );
  }

  Widget _showDomicilioLabel() {
    return Container(
      margin: EdgeInsets.only(top: 25.0, bottom: 10.0),
      child: Text(
        'Domicilio',
        style: TextStyle(color: Colors.white, fontSize: 25.0),
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
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _departamentosList.length == 0
            ? Text('Cargando departamentos...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboDepartamentos(),
                value: _departamentoCodDep,
                onChanged: (option) {
                  setState(() {
                    _departamentoCodDep = option as String;
                    _municipioCodMun = '0';
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
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

    _departamentosList.forEach((catDepartamento) {
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
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _departamentosList.length == 0
            ? Text('Cargando municipios...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboMunicipios(_departamentoCodDep),
                value: _municipioCodMun,
                onChanged: (option) {
                  setState(() {
                    _municipioCodMun = option as String;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
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

    _getMunicipios(_codDep);

    _municipiosList.forEach((catMunicipio) {
      list.add(DropdownMenuItem(
        child: Text(catMunicipio.municipio),
        value: catMunicipio.codMun,
      ));
    });

    return list;
  }

  Widget _showDireccionDomiciliar() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _direccionDomiciliarController,
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
          hintText: 'Direccion Domiciliar',
          errorText:
              _direccionDomiciliarShowError ? _direccionDomiciliarError : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        onChanged: (value) {
          _direccionDomiciliar = value;
        },
      ),
    );
  }

  Widget _showDatosLegalesTitle() {
    return Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
      child: Text(
        'DATOS LEGALES',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 25.0),
      ),
    );
  }

  Widget _show_RelacionConParcela_CantPersonasMismoDerecho() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showRelacionPropietarioParcelaCombo(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showCantidadPersonasMismoDerecho(),
          ),
        ],
      ),
    );
  }

  Widget _showRelacionPropietarioParcelaCombo() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _relacionPropietarioParcelaList.length == 0
            ? Text('Cargando catalogo de relaciones...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboRelacionPropietarioParcela(),
                value: _relacionPropietarioParcelaValue,
                onChanged: (String? option) {
                  setState(() {
                    _relacionPropietarioParcelaValue = option!;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText: _relacionPropietarioParcelaValueShowError
                      ? _relacionPropietarioParcelaValueError
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<String>> _getComboRelacionPropietarioParcela() {
    List<DropdownMenuItem<String>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Relacion Propietario Parcela...'),
      value: '0',
    ));

    _relacionPropietarioParcelaList.forEach((relacionConParcela) {
      list.add(DropdownMenuItem(
        child: Text(relacionConParcela.relacion),
        value: relacionConParcela.relacion,
      ));
    });

    return list;
  }

  Widget _showCantidadPersonasMismoDerecho() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _personasDerechoSimilarController,
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
          hintText: '# Personas con derecho similar',
          errorText: _personasDerechoSimilarShowError
              ? _personasDerechoSimilarError
              : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        onChanged: (value) {
          _personasDerechoSimilar = value;
        },
      ),
    );
  }

  Widget _show_PresentaDocumentoChk_TipoDocumentoCbo() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showPresentaDocumentoChk(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showTipoDeDocumentoCombo(),
          ),
        ],
      ),
    );
  }

  Widget _showPresentaDocumentoChk() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
      height: 60.0,
      margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: CheckboxListTile(
          activeColor: Colors.green,
          title: Text(
            '¿Presenta Documento?',
            style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
            textAlign: TextAlign.start,
          ),
          value: _presentaDocumento,
          onChanged: (value) {
            setState(() {
              _presentaDocumento = value!;
            });
          }),
    );
  }

  Widget _showTipoDeDocumentoCombo() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _presentaDocumento
            ? _tiposDocumentosList.length == 0
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
                            color: Color.fromARGB(255, 1, 166, 172),
                            width: 2.5),
                      ),
                      errorText: _tipoDocumentoCodDocumShowError
                          ? _tipoDocumentoCodDocumError
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
            : new Container());
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
      child: _presentaDocumento
          ? TextField(
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
              style: TextStyle(
                  fontSize: 20.0, height: 1.0, color: Colors.grey[900]),
              onChanged: (value) {
                _descripcionDocumento = value;
              },
            )
          : new Container(),
    );
  }

  Widget _showAutorNotario() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: _presentaDocumento
          ? TextField(
              controller: _autorNotarioController,
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
                hintText: 'Autor/Notario',
                errorText: _autorNotarioShowError ? _autorNotarioError : null,
              ),
              enabled: _presentaDocumento,
              style:
                  TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
              onChanged: (value) {
                _autorNotario = value;
              },
            )
          : new Container(),
    );
  }

  Widget _showDatosRegistralesLabel() {
    return Container(
      margin: _presentaDocumento
          ? EdgeInsets.only(top: 25.0, bottom: 10.0)
          : EdgeInsets.all(0.0),
      child: _presentaDocumento
          ? Text(
              'Datos Registrales',
              style: TextStyle(color: Colors.white, fontSize: 25.0),
            )
          : new Container(),
    );
  }

  Widget _show_FechaAdquisicion_FechaRegistro() {
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
      child: _presentaDocumento
          ? TextField(
              controller: _fechaAdquisicionController,
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
                hintText: 'Fecha de Adquisicion',
                errorText:
                    _fechaAdquisicionShowError ? _fechaAdquisicionError : null,
              ),
              style:
                  TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
              onTap: () {
                _pickDate(
                    context, 'fechaAdquisicion', _fechaAdquisicionController);
              })
          : new Container(),
    );
  }

  Widget _showFechaRegistro() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: _presentaDocumento
          ? TextField(
              controller: _fechaRegistroController,
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
                hintText: 'Fecha de Registro',
                errorText: _fechaRegistroShowError ? _fechaRegistroError : null,
              ),
              style:
                  TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
              onTap: () {
                _pickDate(context, 'fechaRegistro', _fechaRegistroController);
              })
          : new Container(),
    );
  }

  Widget _show_Finca_Tomo() {
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
      child: _presentaDocumento
          ? TextField(
              controller: _fincaController,
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
                hintText: 'Finca',
                errorText: _fincaShowError ? _fincaError : null,
              ),
              style:
                  TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
              onChanged: (value) {
                _finca = value;
              },
            )
          : new Container(),
    );
  }

  Widget _showTomo() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: _presentaDocumento
          ? TextField(
              controller: _tomoController,
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
                hintText: 'Tomo',
                errorText: _tomoShowError ? _tomoError : null,
              ),
              style:
                  TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
              onChanged: (value) {
                _tomo = value;
              },
            )
          : Container(),
    );
  }

  Widget _show_Folio_Asiento() {
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
      child: _presentaDocumento
          ? TextField(
              controller: _folioController,
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
                hintText: 'Folio',
                errorText: _folioShowError ? _folioError : null,
              ),
              style:
                  TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
              onChanged: (value) {
                _folio = value;
              },
            )
          : Container(),
    );
  }

  Widget _showAsiento() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: _presentaDocumento
          ? TextField(
              controller: _asientoController,
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
                hintText: 'Asiento',
                errorText: _asientoShowError ? _asientoError : null,
              ),
              style:
                  TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
              onChanged: (value) {
                _asiento = value;
              },
            )
          : Container(),
    );
  }

  Widget _showButtons() {
    return Align(
      alignment: _presentaDocumento ? Alignment.centerRight : Alignment.center,
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

  Future<Null> _getCatDepartamentos() async {
    setState(() {
      _showLoader = true;
    });

    List<CatDepartamento> response =
        await DictionaryDataBaseHelper.getCatDepartamentos();

    setState(() {
      _showLoader = false;
      _departamentosList = response;
    });
  }

  Future<Null> _getMunicipios(String codDepartamento) async {
    setState(() {
      _showLoader = true;
    });

    List<CatMunicipio> response =
        await DictionaryDataBaseHelper.getCatMunicipios(codDepartamento);

    setState(() {
      _showLoader = false;
      _municipiosList = response;
    });
  }

  Future<Null> _getEstadosCiviles() async {
    setState(() {
      _showLoader = true;
    });

    List<CatEstadoCivil> response =
        await DictionaryDataBaseHelper.getEstadoCivil();

    setState(() {
      _showLoader = false;
      _catEstadoCivilList = response;
    });
  }

  Future<Null> _getNacionalidades() async {
    setState(() {
      _showLoader = true;
    });

    List<StbNacionalidad> response =
        await DictionaryDataBaseHelper.getNacionalidad();

    setState(() {
      _showLoader = false;
      _stbNacionalidadList = response;
    });
  }

  Future<Null> _getRelacionesPropietarioParcela() async {
    setState(() {
      _showLoader = true;
    });

    List<RelacionConParcela> response =
        await DictionaryDataBaseHelper.getRelacionPropietarioParcela();

    setState(() {
      _showLoader = false;
      _relacionPropietarioParcelaList = response;
    });
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

  String getTextFromDate(String tipoFecha) {
    if (tipoFecha == 'fechaAdquisicion' && _fechaAdquisicion != null) {
      return '${_fechaAdquisicion.day}/${_fechaAdquisicion.month}/${_fechaAdquisicion.year}';
    }

    if (tipoFecha == 'fechaRegistro' && _fechaRegistro != null) {
      return '${_fechaRegistro.day}/${_fechaRegistro.month}/${_fechaRegistro.year}';
    }

    return 'Seleccionar fecha';
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

  void _loadData() async {
    await _getTiposDeDocumentos();
    await _getCatDepartamentos();
    await _getEstadosCiviles();
    await _getNacionalidades();
    await _getRelacionesPropietarioParcela();
  }
}
