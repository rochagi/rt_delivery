import 'package:sqflite/sqflite.dart';

import '../utils/app_exceptions.dart';
import 'database_tables_enum.dart';
import 'i_database_operations.dart';

final class DatabaseOperationsImpl implements IDatabaseOperations {
  final Database _database;

  DatabaseOperationsImpl({required Database database}) : _database = database;

  @override
  Future<List<Map<String, Object?>>> read(
      {required String query, List<Object?>? arguments}) async {
    try {
      return await _database.rawQuery(query, arguments);
    } on Exception catch (e, s) {
      throw DBException(
        message: 'Erro ao recuperar dados',
        stackTrace: s,
        aditionalInfo: 'query: $query, arguments: $arguments',
      );
    }
  }

  @override
  Future<void> insertOrUpdate(
      {required DatabaseTablesEnum tableEnum,
      query,
      required List elements}) async {
    try {
      var batch = _database.batch();
      for (final element in elements) {
        batch.insert(
          tableEnum.table,
          element.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit();
    } on Exception catch (e, s) {
      throw DBException(
        message: 'Erro ao salvar',
        stackTrace: s,
        aditionalInfo: 'query: $query',
      );
    }
  }

  @override
  Future<void> delete(
      {required DatabaseTablesEnum tableEnum,
      String? where,
      List<Object?>? whereArgs}) async {
    try {
      await _database.delete(tableEnum.table,
          where: where, whereArgs: whereArgs);
    } on Exception catch (e, s) {
      throw DBException(
        message: 'Erro ao deletar',
        stackTrace: s,
        aditionalInfo: 'where: $where, whereArgs: $whereArgs',
      );
    }
  }

  @override
  Future<void> clearTables() async {
    try {
      for (final table in DatabaseTablesEnum.values) {
        await _database.delete(table.table);
      }
    } on Exception catch (e, s) {
      throw DBException(
        message: 'Erro ao deletar',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> rawUpdate(
      {required String query, List<Object?>? arguments}) async {
    try {
      await _database.rawUpdate(query, arguments);
    } on Exception catch (e, s) {
      throw DBException(
        message: 'Erro ao atualizar',
        stackTrace: s,
        aditionalInfo: 'query: $query, arguments: $arguments',
      );
    }
  }
}
