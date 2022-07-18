import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:surveycat_app/helpers/api_helper.dart';
import 'package:surveycat_app/helpers/sqfliteDatabaseHelper.dart';
import 'package:surveycat_app/models/parcela.dart';
import 'package:surveycat_app/models/response.dart';
import 'package:surveycat_app/models/token.dart';

class SyncronizationData {
  static Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await DataConnectionChecker().hasConnection) {
        print("Mobile Data detected & internet connection confirmed.");
        return true;
      } else {
        print('No internet :( Reason:');
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        print("WiFi Data detected & internet connection confirmed.");
        return true;
      } else {
        print('No internet :( Reason:');
        return false;
      }
    } else {
      print(
          "Neither mobile data or WIFI detected, not internet connection found.");
      return false;
    }
  }

/*   final conn = SqfliteDatabaseHelper.instance;

  Future<List<Parcela>> GetLocalParcelas() async {
    final dbClient = await conn.db;
    List<Parcela> parcelasList = [];
    try {
      final maps = await dbClient.query(SqfliteDatabaseHelper.parcelaTable);
      for (var item in maps) {
        parcelasList.add(Parcela.fromJson(item));
      }
    } catch (e) {
      print(e.toString());
    }
    return parcelasList;
  } */

  Future synchronizeParcelas(List<Parcela> parcelaList, Token token) async {
    for (var i = 0; i < parcelaList.length; i++) {
      Map<String, dynamic> request = {
        'codEnc': parcelaList[i].codEnc,
        'codPar': parcelaList[i].codPar,
        'areaEstimada': parcelaList[i].areaEstimada,
        'userId': parcelaList[i].userId
      };

      // var widget;
      Response response =
          await ApiHelper.post('/api/Parcelas/', request, token);

      if (response.isSuccess) {
        print("Saving Data ");
      } else {
        /*  await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]); */
        return;
      }
    }
  }
}
