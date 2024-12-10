import 'package:rt_flash/app/infra/coleta/models/coleta.dart';

import '../../../../shared/database/database_tables_enum.dart';
import '../../../../shared/database/i_database_operations.dart';

abstract interface class IColetaLocalDatasource {
  Future<void> saveColeta({required ColetaModel coleta});

  Future<List<ColetaModel>> getcoleta();

  Future<void> deleteColeta({required ColetaModel coleta});

  Future<void> reset();
}

final class ColetaLocalDatasource implements IColetaLocalDatasource {
  final IDatabaseOperations _database;

  ColetaLocalDatasource({required IDatabaseOperations database})
      : _database = database;

  @override
  Future<List<ColetaModel>> getcoleta() async {
    try {
      final result = await _database.read(
        query: "SELECT * FROM ${DatabaseTablesEnum.coleta.table}",
      );
      if (result.isNotEmpty) {
        return result.map((e) => ColetaModel.fromMap(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveColeta({required ColetaModel coleta}) async {
    try {
      await _database.insertOrUpdate(
          tableEnum: DatabaseTablesEnum.coleta, elements: [coleta]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> reset() async {
    try {
      await Future.wait([
        _database.delete(tableEnum: DatabaseTablesEnum.coleta),
      ]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteColeta({required ColetaModel coleta}) async {
    try {
      await Future.wait([
        _database.delete(
            tableEnum: DatabaseTablesEnum.coleta,
            where: "coletaId = ?",
            whereArgs: [coleta.coletaId]),
      ]);
    } catch (e) {
      rethrow;
    }
  }
}
