import 'database_tables_enum.dart';

abstract interface class IDatabaseOperations {
  Future<List<Map<String, Object?>>> read(
      {required String query, List<Object?>? arguments});

  Future<void> insertOrUpdate({
    required DatabaseTablesEnum tableEnum,
    query,
    required List elements,
  });

  Future<void> delete(
      {required DatabaseTablesEnum tableEnum,
      String? where,
      List<Object?>? whereArgs});

  Future<void> clearTables();
  Future<void> rawUpdate({required String query, List<Object?>? arguments});
}
