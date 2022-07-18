// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:surveycat_app/components/loader_component.dart';
import 'package:surveycat_app/helpers/constants.dart';
import 'package:surveycat_app/models/token.dart';
import 'package:surveycat_app/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;

  String _password = '';
  String _passwordError = '';
  bool _passwordShowError = false;

  int _baseDatosId = 0;
  String _baseDatosIdError = '';
  bool _baseDatosIdShowError = false;

  bool _visibilityPassword = false;
  bool _rememberme = true;

  bool _showLoader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _showLogo(),
                /*    Text('SurveyCat',
                      style: TextStyle(fontSize: 35, color: Colors.white)), */
                _showEmail(),
                _showPassword(),
                _showBaseDatosCombo(),
                _showRememberme(),
                SizedBox(height: 10),
                _showButtons(),
              ],
            ),
            _showLoader
                ? LoaderComponent(
                    text: 'Por favor espere...',
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _showLogo() {
    return Image(
      image: AssetImage('assets/gpslogo.png'),
      width: 300,
    );
  }

  Widget _showEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          fillColor: Colors.grey[300],
          filled: true,
          hintText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          suffixIcon: Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: TextField(
        obscureText: !_visibilityPassword,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
          ),
          fillColor: Colors.grey[300],
          filled: true,
          hintText: 'Password',
          errorText: _passwordShowError ? _passwordError : null,
          suffixIcon: IconButton(
            icon: _visibilityPassword
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _visibilityPassword = !_visibilityPassword;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

  Widget _showBaseDatosCombo() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: getDropdownItemsGenero.length == 0
            ? Text('Cargando Bases de Datos...')
            : Container(
                child: DropdownButtonFormField(
                  dropdownColor: Colors.white,
                  style: TextStyle(color: Colors.grey[800], fontSize: 20.0),
                  items: getDropdownItemsGenero,
                  value: _baseDatosId,
                  onChanged: (option) {
                    setState(() {
                      _baseDatosId = option as int;
                    });
                  },
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 1, 166, 172), width: 2.5),
                    ),
                    errorText: _baseDatosIdShowError ? _baseDatosIdError : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<int>> get getDropdownItemsGenero {
    List<DropdownMenuItem<int>> menuItems = [
      DropdownMenuItem(child: Text("Seleccione la Base de Datos..."), value: 0),
      DropdownMenuItem(child: Text("Barrido Tradicional"), value: 1),
      //DropdownMenuItem(child: Text("Titulacion Temprana"), value: 2),
    ];
    return menuItems;
  }

  Widget _showRememberme() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 0.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.grey,
        ),
        child: CheckboxListTile(
            activeColor: Colors.blue,
            title: Text(
              'Recordarme',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            value: _rememberme,
            onChanged: (value) {
              setState(() {
                _rememberme = value!;
              });
            }),
      ),
    );
  }

  Widget _showButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
          primary: Color.fromARGB(255, 0, 70, 136),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () => _login(),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            "Iniciar Sesión",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _visibilityPassword = false;
    });

    if (!validarCampos()) {
      return;
    }

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
          message: 'Verifica tu conexión a Internet.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);

      return;
    }

    Map<String, dynamic> request = {
      'Username': _email,
      'Password': _password,
    };

    var url = Uri.parse('${Constants.apiUrl}/api/Account/CreateToken');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    setState(() {
      _showLoader = false;
    });

    if (response.statusCode >= 400) {
      setState(() {
        _passwordShowError = true;
        _passwordError = 'Email o Contraseña incorrectos!';
      });
      return;
    }

    var body = response.body;

    if (_rememberme) {
      _storeUser(body);
    }

    var decodedJson = jsonDecode(body);
    var token = Token.fromJson(decodedJson);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          token: token,
        ),
      ),
    );
  }

  bool validarCampos() {
    bool isValid = true;

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu Email';
    } else if (!EmailValidator.validate(_email)) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un Email valido';
    } else {
      _emailShowError = false;
    }

    if (_password.isEmpty) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'Debes ingresar tu Contraseña';
    } else {
      _passwordShowError = false;
    }

    if (_baseDatosId == 0) {
      isValid = false;
      //_baseDatosIdShowError = true;
      //_baseDatosIdError = '';
    } /* else {
      //_baseDatosIdShowError = false;
    }
  */
    setState(() {});
    return isValid;
  }

  void _storeUser(String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', true);
    await prefs.setString('userBody', body);
  }
}
