import 'package:rt_flash/app/infra/images/model/images.dart';

import '../../../../shared/database/database_tables_enum.dart';
import '../../../../shared/database/i_database_operations.dart';

abstract interface class IImagesLocalDatasource {
  Future<void> saveImages({required List<Images> images});

  Future<List<Images>> getimages();

  Future<void> reset();
}

final class ImagesLocalDatasource implements IImagesLocalDatasource {
  final IDatabaseOperations _database;

  ImagesLocalDatasource({required IDatabaseOperations database})
      : _database = database;

  @override
  Future<List<Images>> getimages() async {
    try {
      final result = await _database.read(
        query: "SELECT * FROM ${DatabaseTablesEnum.images.table}",
      );
      if (result.isNotEmpty) {
        return result.map((e) => Images.fromMap(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveImages({required List<Images> images}) async {
    try {
      await _database.insertOrUpdate(
          tableEnum: DatabaseTablesEnum.images, elements: images);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> reset() async {
    try {
      await Future.wait([
        _database.delete(tableEnum: DatabaseTablesEnum.images),
      ]);
    } catch (e) {
      rethrow;
    }
  }
}
