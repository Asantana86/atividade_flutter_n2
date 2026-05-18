import 'package:sqflite/sqflite.dart';
import 'base_model.dart';
import '../helpers/database_helper.dart';

abstract class BaseRepository<E extends BaseModel> {
  final _dbHelper = DatabaseHelper.instance;

  String get tableName;

  Future<Database> getConnection() async {
    return await _dbHelper.database;
  }

  Future<int> insert(E model) async {
    final db = await _dbHelper.database;
    return await db.insert(tableName, model.toMap());
  }

  Future<int> update(E model) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<List<E>> findAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      orderBy: 'id DESC',
    );

    return result.map((map) => fromMap(map)).toList();
  }

  Future<List<E>> findAllActive() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'ativo = ?',
      whereArgs: [1],
      orderBy: 'id DESC',
    );

    return result.map((map) => fromMap(map)).toList();
  }

  Future<List<E>> findAllInactive() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'ativo = ?',
      whereArgs: [0],
      orderBy: 'id DESC',
    );

    return result.map((map) => fromMap(map)).toList();
  }

  Future<E?> findById(dynamic id) async {
    final db = await _dbHelper.database;
    final result = await db.query(tableName, where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return fromMap(result.first);
    }
    return null;
  }

  Future<List<E>> findNotSynced() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      tableName,
      where: 'is_sync = ?',
      whereArgs: [0],
      orderBy: 'created_at ASC',
    );

    return result.map((map) => fromMap(map)).toList();
  }

  Future<void> markAsSynced(dynamic id) async {
    final db = await _dbHelper.database;
    await db.update(
      tableName,
      {'is_sync': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<E>> findAllPendingSync() async {
    final db = await getConnection();
    final result = await db.query(
      tableName,
      where: 'is_sync = ?',
      whereArgs: [0],
    );
    return result.map((map) => fromMap(map)).toList();
  }

  Future<int> delete(dynamic id) async {
    final db = await _dbHelper.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> softDelete(dynamic id) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableName,
      {'ativo': 0, 'is_sync': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> reactivate(int id) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableName,
      {'ativo': 1, 'is_sync': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> exists(String whereClause, List<dynamic> whereArgs) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      tableName,
      columns: ['COUNT(*) as count'],
      where: whereClause,
      whereArgs: whereArgs,
    );

    final count = result.first['count'] as int;
    return count > 0;
  }

  E fromMap(Map<String, dynamic> map);
}
