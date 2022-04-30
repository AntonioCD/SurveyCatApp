// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:surveycat_app/components/loader_component.dart';
import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/token.dart';
import '../helpers/constants.dart';

class ParcelaScreen extends StatefulWidget {
  final Token token;

  ParcelaScreen({required this.token});

  @override
  State<ParcelaScreen> createState() => _ParcelaScreenState();
}

class _ParcelaScreenState extends State<ParcelaScreen> {
  List<Parcela> _parcelas = [];
  bool _showLoader = false;

  @override
  void initState() {
    super.initState();
    _getParcelas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcelas'),
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
        onPressed: () {},
      ),
    );
  }

  void _getParcelas() async {
    setState(() {
      _showLoader = true;
    });
    var url = Uri.parse('${Constants.apiUrl}/api/Parcelas');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${widget.token.token}',
      },
    );
    setState(() {
      _showLoader = false;
    });

    var body = response.body;
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        _parcelas.add(Parcela.fromJson(item));
      }
    }

    print(_parcelas);
  }

  Widget _getContent() {
    return _parcelas.length == 0 ? _noContent() : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          'No hay Encuestas almacenadas.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _getListView() {
    return ListView(
      children: _parcelas.map((e) {
        return Card(
          child: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.codEnc,
                    style: TextStyle(fontSize: 16),
                  ),
                  Icon(Icons.arrow_circle_right),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
