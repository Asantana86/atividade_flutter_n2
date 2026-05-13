import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {

    if (_database != null) return _database!;

    _database = await _initDB('serviceflow.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    debugPrint('🔄 Criando tabelas do banco de dados...');

    try {
      final String script =
          await rootBundle.loadString('assets/sql/create_tables.sql');

      final List<String> commands = script.split(';');

      for (final command in commands) {
        final trimmedCommand = command.trim();
        if (trimmedCommand.isNotEmpty) {
          try {
            await db.execute(trimmedCommand);
          } catch (e) {
            debugPrint('❌ Erro ao executar comando SQL: $trimmedCommand');
            debugPrint('❌ Erro: $e');
            rethrow;
          }
        }
      }

      debugPrint('✅ Banco de dados criado com sucesso');
    } catch (e, stackTrace) {
      debugPrint('❌ ERRO CRÍTICO ao criar tabelas: $e');
      debugPrint('📋 Stack: $stackTrace');
      rethrow;
    }
  }
}