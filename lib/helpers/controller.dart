import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:surveycat_app/helpers/databaseProvider.dart';
import 'package:surveycat_app/helpers/sqfliteDatabaseHelper.dart';
import 'package:surveycat_app/models/parcela.dart';

class Controller {
  final conn = SqfliteDatabaseHelper.instance;
  //final dbProvider = DatabaseProvider.dbProvider;

  static Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await DataConnectionChecker().hasConnection) {
        print("Mobile data detected & internet connection confirmed.");
        return true;
      } else {
        print('No internet :( Reason:');
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        print("wifi data detected & internet connection confirmed.");
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

  Future<int> addData(Parcela parcela) async {
    var dbclient = await conn.db;
    late int result;
    try {
      result = await dbclient.insert(
          SqfliteDatabaseHelper.parcelaTable, parcela.toJson());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future<int> updateData(Parcela parcela) async {
    var dbclient = await conn.db;
    late int result;
    try {
      result = await dbclient.update(
          SqfliteDatabaseHelper.parcelaTable, parcela.toJson(),
          where: 'codEnc=?', whereArgs: [parcela.codEnc]);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future fetchData() async {
    var dbclient = await conn.db;
    List parcelasList = [];
    try {
      List<Map<String, dynamic>> maps = await dbclient
          .query(SqfliteDatabaseHelper.parcelaTable, orderBy: 'codEnc');
      for (var item in maps) {
        parcelasList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return parcelasList;
  }
}
