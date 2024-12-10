import '../../../../shared/database/database_tables_enum.dart';
import '../../../../shared/database/i_database_operations.dart';
import '../../models/finalizar_coleta.dart';

abstract interface class IFinalizarColetaLocalDatasource {
  Future<void> saveFinalizarColeta({required FinalizarColeta coleta});

  Future<List<FinalizarColeta>> getColetasFinalizadas();

  Future<void> reset();
}

final class FinalizarColetaLocalDatasource
    implements IFinalizarColetaLocalDatasource {
  final IDatabaseOperations _database;

  FinalizarColetaLocalDatasource({required IDatabaseOperations database})
      : _database = database;

  @override
  Future<List<FinalizarColeta>> getColetasFinalizadas() async {
    try {
      final result = await _database.read(
        query: "SELECT * FROM ${DatabaseTablesEnum.coletaFinalizada.table}",
      );
      if (result.isNotEmpty) {
        return result.map((e) => FinalizarColeta.fromMap(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveFinalizarColeta({required FinalizarColeta coleta}) async {
    try {
      await _database.insertOrUpdate(
          tableEnum: DatabaseTablesEnum.coletaFinalizada, elements: [coleta]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> reset() async {
    try {
      await Future.wait([
        _database.delete(tableEnum: DatabaseTablesEnum.coletaFinalizada),
      ]);
    } catch (e) {
      rethrow;
    }
  }
}
