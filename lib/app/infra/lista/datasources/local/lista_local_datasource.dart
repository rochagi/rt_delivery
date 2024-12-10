import 'package:rt_flash/app/infra/lista/models/hawb_model.dart';
import 'package:rt_flash/app/infra/lista/models/finalizar_hawb_model.dart';
import 'package:rt_flash/app/infra/lista/models/lista_model.dart';

import '../../../../shared/database/database_tables_enum.dart';
import '../../../../shared/database/i_database_operations.dart';

abstract interface class IListaLocalDatasource {
  Future<void> saveLista({required ListaModel lista});
  Future<void> saveHawbs({required List<HawbModel> hawbs});
  Future<void> saveHawbFinish({required FinalizarHawbModel hawbFinish});

  Future<ListaModel?> getlista();
  Future<List<HawbModel>> gethawbs();
  Future<List<FinalizarHawbModel>> getHawbsFinish();

  Future<void> reset();
}

final class ListaLocalDatasource implements IListaLocalDatasource {
  final IDatabaseOperations _database;

  ListaLocalDatasource({required IDatabaseOperations database})
      : _database = database;

  @override
  Future<ListaModel?> getlista() async {
    try {
      ListaModel? lista;

      final result = await _database.read(
        query: "SELECT * FROM ${DatabaseTablesEnum.lista.table}",
      );
      if (result.isNotEmpty) {
        lista = ListaModel.fromMap(result.first);
        List<HawbModel> hawbs = [];
        if (lista.lista != null) {
          hawbs.addAll(await gethawbs());
        }
        lista.documentos = hawbs;
      }
      return lista;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveLista({required ListaModel lista}) async {
    try {
      await _database.delete(
        tableEnum: DatabaseTablesEnum.lista,
      );
      await _database.delete(
        tableEnum: DatabaseTablesEnum.hawb,
      );

      await saveHawbs(hawbs: lista.documentos ?? []);

      await _database.insertOrUpdate(
          tableEnum: DatabaseTablesEnum.lista, elements: [lista]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveHawbs({required List<HawbModel> hawbs}) async {
    try {
      await _database.insertOrUpdate(
          tableEnum: DatabaseTablesEnum.hawb, elements: hawbs);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HawbModel>> gethawbs() async {
    try {
      final hawbResult = await _database.read(
        query: "SELECT * FROM ${DatabaseTablesEnum.hawb.table}",
      );
      if (hawbResult.isNotEmpty) {
        return hawbResult.map((e) => HawbModel.fromMap(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveHawbFinish({required FinalizarHawbModel hawbFinish}) async {
    try {
      await _database.insertOrUpdate(
          tableEnum: DatabaseTablesEnum.hawbFinalizada, elements: [hawbFinish]);
    } catch (e) {
      await _database.delete(
        tableEnum: DatabaseTablesEnum.hawb,
        where: 'hawbId = ?',
        whereArgs: [hawbFinish.codHawb],
      );

      rethrow;
    }
  }

  @override
  Future<List<FinalizarHawbModel>> getHawbsFinish() async {
    try {
      final hawbResult = await _database.read(
        query: "SELECT * FROM ${DatabaseTablesEnum.hawbFinalizada.table}",
      );
      if (hawbResult.isNotEmpty) {
        return hawbResult.map((e) => FinalizarHawbModel.fromMap(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> reset() async {
    try {
      await Future.wait([
        _database.delete(tableEnum: DatabaseTablesEnum.hawbFinalizada),
        _database.delete(tableEnum: DatabaseTablesEnum.lista),
        _database.delete(tableEnum: DatabaseTablesEnum.hawb),
      ]);
    } catch (e) {
      rethrow;
    }
  }
}
