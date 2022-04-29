// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

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
  String _email = 'cd.oscar@gmail.com';
  String _emailError = '';
  bool _emailShowError = false;

  String _password = '123456';
  String _passwordError = '';
  bool _passwordShowError = false;

  bool _visibilityPassword = false;
  bool _rememberme = true;

  bool _showLoader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 14, 67),
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
                /*   _showRememberme(), */
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
      image: AssetImage('assets/gpsLogo.png'),
      width: 300,
    );
  }

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          suffixIcon: Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: TextField(
        obscureText: !_visibilityPassword,
        decoration: InputDecoration(
          fillColor: Colors.white,
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
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

  Widget _showRememberme() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: CheckboxListTile(
          title: Text(
            'Recordarme',
            style: TextStyle(color: Colors.white),
          ),
          value: _rememberme,
          onChanged: (value) {
            setState(() {
              _rememberme = value!;
            });
          }),
    );
  }

  Widget _showButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
            primary: Colors.deepPurple[700]),
        onPressed: () => _login(),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text("Iniciar Sesión"),
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
      _emailShowError = false;
    }

    setState(() {});
    return isValid;
  }
}