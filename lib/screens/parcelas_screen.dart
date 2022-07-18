// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:surveycat_app/components/loader_component.dart';
import 'package:surveycat_app/helpers/api_helper.dart';
import 'package:surveycat_app/helpers/controller.dart';
import 'package:surveycat_app/helpers/databaseProvider.dart';
import 'package:surveycat_app/helpers/database_helper.dart';
import 'package:surveycat_app/helpers/syncronizationData.dart';
import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/response.dart';
import 'package:surveycat_app/models/token.dart';
import 'package:surveycat_app/models/user.dart';
import 'package:surveycat_app/screens/historialParcelas_screen.dart';
import 'package:surveycat_app/screens/informante_screen.dart';
import 'package:surveycat_app/screens/informantes_screen.dart';
import 'package:surveycat_app/screens/parcela_screen.dart';
import 'package:surveycat_app/screens/propietarios_screen.dart';

class ParcelasScreen extends StatefulWidget {
  final Token token;

  ParcelasScreen({required this.token});

  @override
  State<ParcelasScreen> createState() => _ParcelasScreenState();
}

class _ParcelasScreenState extends State<ParcelasScreen> {
  List<Parcela> _parcelas = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';
  //late User _user;

  /*  late Timer _timer;

  late List<Parcela> list;
  bool loading = true;
  Future userList() async {
    //list = await Controller().fetchData();
    list = await DatabaseProvider.parcelas();
    setState(() {
      loading = false;
    });
    //print(list);
  } */

  Future syncToSql() async {
    if (_parcelas.length > 0) {
      await SyncronizationData().synchronizeParcelas(_parcelas, widget.token);
      EasyLoading.showSuccess('Successfully save to mysql');
    }

    /* await SyncronizationData().GetLocalParcelas().then((userList) async {
      EasyLoading.show(status: 'Dont close app. we are sync...');
      await SyncronizationData().synchronizeParcelas(userList);
      EasyLoading.showSuccess('Successfully save to mysql');
    }); */
  }

  Future isInteret() async {
    await SyncronizationData.isInternet().then((connection) {
      if (connection) {
        print("Internet connection abailale");
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No Internet")));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //_user = widget.token.user;
    //_getParcelas();
    //_getUser();
    //userList();
    _getParcelas();

    //isInteret();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        // _timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
      appBar: AppBar(
        title: Text('Mis Encuestas'),
        titleTextStyle: TextStyle(fontSize: 25.0),
        backgroundColor: Color.fromARGB(255, 0, 70, 136),
        actions: <Widget>[
          _isFiltered
              ? IconButton(
                  onPressed: _removeFilter, icon: Icon(Icons.filter_alt))
              : IconButton(
                  onPressed: _showFilter, icon: Icon(Icons.filter_list)),
          IconButton(
              icon: Icon(Icons.refresh_sharp),
              onPressed: () async {
                syncToSql();
                print("Internet connection available");
                /* await SyncronizationData.isInternet().then((connection) {
                  if (connection) {
                    syncToSql();
                    print("Internet connection abailale");
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("No Internet")));
                  }
                }); */
              })
        ],
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
        backgroundColor: Color.fromARGB(255, 153, 4, 4),
        onPressed: () {
          _goAdd();
        },
      ),
    );
  }

  Future<Null> _getParcelas() async {
    setState(() {
      _showLoader = true;
    });

    List<Parcela> response = await DictionaryDataBaseHelper.parcelas();

    setState(() {
      _showLoader = false;
    });

    setState(() {
      _parcelas = response;
    });
  }

  Widget _getContent() {
    //return widget.token.user.parcelas.isEmpty ? _noContent() : _getListView();
    return _parcelas.length == 0 ? _noContent() : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFiltered
              ? 'No hay Encuestas con ese criterio de busqueda'
              : 'No hay parcelas registradas.',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _getListView() {
    return RefreshIndicator(
      //onRefresh: _getUser,
      onRefresh: _getParcelas,
      child: ListView(
        //children: _user.parcelas.map((e) {
        children: _parcelas.map((e) {
          return Card(
            child: InkWell(
              onTap: () {
                //_goEdit(e);
                _showOptions(e);
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.codEnc,
                      style: TextStyle(fontSize: 25),
                    ),
                    Icon(Icons.more_vert),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text('Filtrar Encuestas'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Escriba los primeros digitos del Código de Encuesta'),
                SizedBox(height: 10),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: 'Criterio de búsqueda',
                      labelText: 'Buscar',
                      suffixIcon: Icon(Icons.search)),
                  onChanged: (value) {
                    _search = value;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')),
              TextButton(onPressed: () => _filter(), child: Text('Filtrar'))
            ],
          );
        });
  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getUser();
  }

  void _filter() {
    if (_search.isEmpty) {
      return;
    }

    List<Parcela> filteredList = [];
    for (var parcela in _parcelas) {
      if (parcela.codEnc.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(parcela);
      }
    }

    setState(() {
      _parcelas = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  void _goAdd() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParcelaScreen(
            token: widget.token,
            user: widget.token.user,
            parcela: Parcela(
              id: 0,
              codEnc: '',
              codPar: '',
              areaEstimada: 0,
              presentaConflicto: false,
              fechaEnc: '',
              id_informante: '',
              userId: '',
            )),
      ),
    );

    if (result == 'yes') {
      _getUser();
    }
  }

  void _goEdit(Parcela parcela) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParcelaScreen(
          token: widget.token,
          user: widget.token.user,
          parcela: parcela,
        ),
      ),
    );

    if (result == 'yes') {
      _getUser();
    }
  }

  void _goInformante(Parcela parcela) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InformantesScreen(
          token: widget.token,
          parcela: parcela,
        ),
      ),
    );

    if (result == 'yes') {
      _getParcelas();
    }
  }

  void _goPropietarios(Parcela parcela) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropietariosScreen(
          token: widget.token,
          parcela: parcela,
        ),
      ),
    );

    if (result == 'yes') {
      _getParcelas();
    }
  }

  void _goHistorialParcela(Parcela parcela) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistorialParcelasScreen(
          token: widget.token,
          parcela: parcela,
        ),
      ),
    );

    if (result == 'yes') {
      _getParcelas();
    }
  }

  Future<Null> _getUser() async {
    setState(() {
      _showLoader = true;
    });

    /*  var connectivityResult = await Connectivity().checkConnectivity();
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
    } */

    //Response response = await ApiHelper.getUser(widget.token, _user.id);

    //List<Parcela> response = await DatabaseProvider.parcelas(_user.id);

    setState(() {
      _showLoader = false;
    });

    /*   if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    } */

    /* setState(() {
      _user = response.result;
    }); */
  }

  _showOptions(Parcela parcela) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.layers),
                title: Text(
                  'Editar Parcela',
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () {
                  _goEdit(parcela);
                },
              ),
              ListTile(
                leading: Icon(Icons.face),
                title: Text(
                  'Datos del Informante',
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () {
                  _goInformante(parcela);
                },
              ),
              ListTile(
                leading: Icon(Icons.group),
                title: Text(
                  'Datos de Propietarios/Poseedores',
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () {
                  _goPropietarios(parcela);
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  'Reseña Historica de la Parcela',
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () {
                  _goHistorialParcela(parcela);
                },
              ),
              /* ListTile(
                leading: Icon(Icons.apps),
                title: Text(
                  'Acta de Conformidad de Linderos',
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () {
                  _goPropietarios(parcela);
                },
              ), */
            ],
          );
        });
  }

  /* Future sincronizar() async {
    await SyncronizationData().GetLocalParcelas().then((userList) async {
      EasyLoading.show(
          status: 'No cerrar la aplicación. Estamos sincronizando...');
      await SyncronizationData().synchronizeParcelas(userList);
      EasyLoading.showSuccess('Datos guardados correctamente!');
    });
  } */
}
