import 'package:flutter/material.dart';

import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/token.dart';

class ParcelaScreen extends StatefulWidget {
  final Token token;
  final Parcela parcela;

  ParcelaScreen({required this.token, required this.parcela});

  @override
  State<ParcelaScreen> createState() => _ParcelaScreenState();
}

class _ParcelaScreenState extends State<ParcelaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.parcela.id == 0 ? 'Nueva Parcela' : widget.parcela.codEnc),
      ),
      body: Center(
        child: Text(
            widget.parcela.id == 0 ? 'Nueva Parcela' : widget.parcela.codEnc),
      ),
    );
  }
}
