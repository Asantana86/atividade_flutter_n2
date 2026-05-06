import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {

    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'serviceflow.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {

    String script = await rootBundle.loadString('assets/sql/create_tables.sql');
    
    List<String> comandos = script.split(';');

    for (String comando in comandos) {
      if (comando.trim().isNotEmpty) {
        await db.execute(comando);
      }
    }
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}