import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:surveycat_app/models/parcela.dart';

class DatabaseProvider {
  static Future<Database> _openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'SurveyCatDbClient.db'),
      onCreate: (db, version) {
        // Ejecuta la sentencia CREATE TABLE en la base de datos
        return db.execute(
          "CREATE TABLE parcelas(id INTEGER PRIMARY KEY, codEnc TEXT, codPar TEXT, "
          "areaEstimada REAL, presenta_conflicto INTEGER, fecha_Enc TEXT, userId TEXT)",
        );
      },
      // Establece la versión. Esto ejecuta la función onCreate y proporciona una
      // ruta para realizar actualizacones y defradaciones en la base de datos.
      version: 1,
    );
  }

  static Future<int> insert(Parcela parcela) async {
    Database database = await _openDB();

    return database.insert("parcelas", parcela.toMap());
  }

  static Future<int> delete(Parcela parcela) async {
    Database database = await _openDB();

    return database
        .delete("parcelas", where: 'codEnc = ?', whereArgs: [parcela.codEnc]);
  }

  static Future<int> update(Parcela parcela) async {
    Database database = await _openDB();

    return database.update("parcelas", parcela.toMap(),
        where: 'codEnc = ?', whereArgs: [parcela.codEnc]);
  }

  static Future<List<Parcela>> parcelas() async {
    Database database = await _openDB();

    final List<Map<String, dynamic>> parcelasMap =
        await database.query("parcelas");

    return List.generate(
        parcelasMap.length,
        (i) => Parcela(
            id: parcelasMap[i]['id'],
            codEnc: parcelasMap[i]['codEnc'],
            codPar: parcelasMap[i]['codPar'],
            areaEstimada: parcelasMap[i]['areaEstimada'],
            presentaConflicto: parcelasMap[i]['presentaConflicto'],
            fechaEnc: parcelasMap[i]['fechaEnc'],
            id_informante: parcelasMap[i]['id_informante'],
            userId: parcelasMap[i]['userId']));
  }
}
