import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_titled_container/flutter_titled_container.dart';
import 'package:surveycat_app/components/loader_component.dart';
import 'package:surveycat_app/helpers/api_helper.dart';

import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/response.dart';
import 'package:surveycat_app/models/token.dart';
import 'package:surveycat_app/models/user.dart';

class UserScreen extends StatefulWidget {
  final Token token;
  final User user;

  UserScreen({required this.token, required this.user});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
