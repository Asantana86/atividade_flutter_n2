import 'package:sqflite/sqflite.dart';
import '../models/base_model.dart';
import '../services/database_helper.dart';

abstract class BaseRepository<T extends BaseModel> {

  final String tableName;

  BaseRepository(this.tableName);

  T fromMap(Map<String, dynamic> map);

  Future<Database> get _db async => await DatabaseHelper().database;

  Future<int> insert(T item) async {
    final db = await _db;

    return await db.insert(
      tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update(T item) async {
    final db = await _db;
    return await db.update(
      tableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _db;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<T>> getAll() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    
    return maps.map((map) => fromMap(map)).toList();
  }

  Future<T?> getById(int id) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return fromMap(maps.first);
    }
    return null;
  }
}