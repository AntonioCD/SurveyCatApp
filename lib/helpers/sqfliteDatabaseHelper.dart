import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabaseHelper {
  static final SqfliteDatabaseHelper instance =
      SqfliteDatabaseHelper._internal();

  factory SqfliteDatabaseHelper() => instance;

  SqfliteDatabaseHelper._internal();

  static final parcelaTable = 'parcelaTable';
  static final _version = 1;

  static late Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'SurveyCatDbClient.db');
    print(dbPath);
    var openDb = await openDatabase(dbPath, version: _version,
        onCreate: (Database db, int version) async {
      await db.execute("""
        CREATE TABLE $parcelaTable (
          id INTEGER PRIMARY KEY, 
          codEnc TEXT, 
          codPar TEXT,
          areaEstimada REAL, 
          presenta_conflicto INTEGER, 
          fecha_Enc TEXT, 
          userId TEXT
          )""");
    }, onUpgrade: (Database db, int oldversion, int newversion) async {
      if (oldversion < newversion) {
        print("Version Upgrade");
      }
    });
    print('db initialize');
    return openDb;
  }
}
