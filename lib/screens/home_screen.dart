// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:surveycat_app/models/token.dart';
import 'package:surveycat_app/screens/login_screen.dart';
import 'package:surveycat_app/screens/parcela_screen.dart';

class HomeScreen extends StatefulWidget {
  final Token token;

  HomeScreen({required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SurveyCat')),
      body: _getBody(),
      drawer: widget.token.user.userType == 0
          ? _getAdminMenu()
          : _getEncuestadorMenu(),
    );
  }

  Widget _getBody() {
    return Center(
      child: Text('Bienvenido ${widget.token.user.fullName}'),
    );
  }

  Widget _getAdminMenu() {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          child: Image(
            image: AssetImage('assets/gpsLogo.png'),
          ),
        ),
        ListTile(
          leading: Icon(Icons.other_houses),
          title: Text('Inicio'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.edit_note),
          title: Text('Usuarios'),
          onTap: () {},
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(
            color: Colors.black,
            height: 2,
          ),
        ),
        ListTile(
          leading: Icon(Icons.transit_enterexit),
          title: Text('Cerrar Sesión'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
          },
        ),
      ]),
    );
  }

  Widget _getEncuestadorMenu() {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          child: Image(
            image: AssetImage('assets/gpsLogo.png'),
          ),
        ),
        ListTile(
          leading: Icon(Icons.other_houses),
          title: Text('Inicio'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.edit_note),
          title: Text('Mis Encuestas'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ParcelaScreen(
                  token: widget.token,
                ),
              ),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(
            color: Colors.black,
            height: 2,
          ),
        ),
        ListTile(
          leading: Icon(Icons.transit_enterexit),
          title: Text('Cerrar Sesión'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
          },
        ),
      ]),
    );
  }
}
