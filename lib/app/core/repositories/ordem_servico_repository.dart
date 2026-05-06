import '../models/service_order_model.dart';
import 'base_repository.dart';
import '../services/database_helper.dart';

class OrdemServicoRepository extends BaseRepository<ServiceOrderModel> {

  OrdemServicoRepository() : super('ordens_servico');

  @override
  ServiceOrderModel fromMap(Map<String, dynamic> map) {
    return ServiceOrderModel.fromMap(map);
  }

  /// Busca no SQLite apenas as OSs que foram criadas offline e 
  /// ainda não subiram para o Supabase (is_sync = 0)
  Future<List<ServiceOrderModel>> getUnsyncedOrders() async {
    final db = await DatabaseHelper().database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'is_sync = ?',
      whereArgs: [0],
    );
    
    return maps.map((map) => fromMap(map)).toList();
  }
}