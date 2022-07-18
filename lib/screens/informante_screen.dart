// ignore_for_file: file_names, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:surveycat_app/helpers/database_helper.dart';
import 'package:surveycat_app/models/catDepartamento.dart';
import 'package:surveycat_app/models/catEstadoCivil.dart';
import 'package:surveycat_app/models/catMunicipio.dart';
import 'package:surveycat_app/models/catPersonaNatural.dart';
import 'package:surveycat_app/models/relacionConParcela.dart';
import 'package:surveycat_app/models/relacionInformanteParcela.dart';
import 'package:surveycat_app/models/stbNacionalidad.dart';
import 'package:surveycat_app/models/token.dart';

class InformanteScreen extends StatefulWidget {
  final Token token;
  final CatPersonaNatural catPersonaNatural;

  InformanteScreen({required this.token, required this.catPersonaNatural});

  @override
  State<InformanteScreen> createState() => _InformanteScreenState();
}

class _InformanteScreenState extends State<InformanteScreen> {
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

  String _relacionConPropietario = '';
  String _relacionConPropietarioError = '';
  bool _relacionConPropietarioShowError = false;
  TextEditingController _relacionConPropietarioController =
      TextEditingController();

  String _relacionInformanteParcelaValue = '0';
  String _relacionInformanteParcelaValueError = '';
  bool _relacionInformanteParcelaValueShowError = false;
  List<RelacionInformanteParcela> _relacionInformanteParcelaList = [];

  String _descripcionRelacionConParcela = '';
  String _descripcionRelacionConParcelaError = '';
  bool _descripcionRelacionConParcelaShowError = false;
  TextEditingController _descripcionRelacionConParcelaController =
      TextEditingController();

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
              ? 'Nuevo Informante'
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
                _showRelacionInformanteLabel(),
                _show_RelacionInformantePropietario_RelacionInformanteParcela(),
                if (_relacionInformanteParcelaValue != '0')
                  _showDescripcionRelacionInformanteParcelaOtro(),
                SizedBox(height: 10),
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
        'DATOS DEL ENTREVISTADO',
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

  Widget _showRelacionInformanteLabel() {
    return Container(
      margin: EdgeInsets.only(top: 25.0, bottom: 10.0),
      child: Text(
        'Relacion Informante Parcela/Propietario',
        style: TextStyle(color: Colors.white, fontSize: 25.0),
      ),
    );
  }

  Widget _show_RelacionInformantePropietario_RelacionInformanteParcela() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _showRelacionInformantePropietario(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _showRelacionInformanteParcelaCombo(),
          ),
        ],
      ),
    );
  }

  Widget _showRelacionInformantePropietario() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
      child: TextField(
        controller: _relacionConPropietarioController,
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
          hintText: 'Relacion Con Propietario',
          errorText: _relacionConPropietarioShowError
              ? _relacionConPropietarioError
              : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        onChanged: (value) {
          _relacionConPropietario = value;
        },
      ),
    );
  }

  Widget _showRelacionInformanteParcelaCombo() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: _relacionInformanteParcelaList.length == 0
            ? Text('Cargando catalogo de relaciones...')
            : DropdownButtonFormField(
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                items: _getComboRelacionInformanteParcela(),
                value: _relacionInformanteParcelaValue,
                onChanged: (String? option) {
                  setState(() {
                    _relacionInformanteParcelaValue = option!;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                  ),
                  errorText: _relacionInformanteParcelaValueShowError
                      ? _relacionInformanteParcelaValueError
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<String>> _getComboRelacionInformanteParcela() {
    List<DropdownMenuItem<String>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Relacion Informante Parcela...'),
      value: '0',
    ));

    _relacionInformanteParcelaList.forEach((relacionInformanteParcela) {
      list.add(DropdownMenuItem(
        child: Text(relacionInformanteParcela.descripcion),
        value: relacionInformanteParcela.descripcion,
      ));
    });

    return list;
  }

  Widget _showDescripcionRelacionInformanteParcelaOtro() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: _descripcionRelacionConParcelaController,
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
          hintText: 'Descripcion de Relacion Con Parcela (Otro)',
          errorText: _descripcionRelacionConParcelaShowError
              ? _descripcionRelacionConParcelaError
              : null,
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        onChanged: (value) {
          _descripcionRelacionConParcela = value;
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

  Future<Null> _getRelacionesInformanteParcela() async {
    setState(() {
      _showLoader = true;
    });

    List<RelacionInformanteParcela> response =
        await DictionaryDataBaseHelper.getRelacionInformanteParcela();

    setState(() {
      _showLoader = false;
      _relacionInformanteParcelaList = response;
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

  void _loadData() async {
    await _getCatDepartamentos();
    await _getEstadosCiviles();
    await _getNacionalidades();
    await _getRelacionesInformanteParcela();
  }
}
