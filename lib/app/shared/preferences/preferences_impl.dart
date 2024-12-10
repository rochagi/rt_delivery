import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_exceptions.dart';
import 'preferences.dart';

final class PreferencesImpl implements IPreferences {
  final SharedPreferences _preferences;

  PreferencesImpl({required SharedPreferences preferences})
      : _preferences = preferences;

  @override
  Future<void> delete({required PrefencesKeyEnum key}) async {
    try {
      if (!await _preferences.remove(key.name)) {
        throw Exception();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      if (!await _preferences.clear()) {
        throw Exception();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  T? get<T>({required PrefencesKeyEnum key, required PreferencesType type}) {
    try {
      if (_preferences.containsKey(key.name)) {
        switch (type) {
          case PreferencesType.string:
            return _preferences.getString(key.name) as T;
          case PreferencesType.int:
            return _preferences.getInt(key.name) as T;
          case PreferencesType.double:
            return _preferences.getDouble(key.name) as T;
          case PreferencesType.bool:
            return _preferences.getBool(key.name) as T;
        }
      }
      return null;
    } on Exception catch (e, s) {
      throw PreferencesException(
          message: '', stackTrace: s, aditionalInfo: e.toString());
    }
  }

  @override
  Future<void> save<T>(
      {required T data,
      required PrefencesKeyEnum key,
      required PreferencesType type}) async {
    try {
      switch (type) {
        case PreferencesType.string:
          await _preferences.setString(key.name, data as String);
          break;
        case PreferencesType.int:
          await _preferences.setInt(key.name, data as int);
          break;
        case PreferencesType.double:
          await _preferences.setDouble(key.name, data as double);
          break;
        case PreferencesType.bool:
          await _preferences.setBool(key.name, data as bool);
          break;
      }
    } on Exception catch (e, s) {
      throw PreferencesException(
          message: '', stackTrace: s, aditionalInfo: e.toString());
    }
  }

  @override
  bool checkIfExists({required PrefencesKeyEnum key}) {
    try {
      return _preferences.containsKey(key.name);
    } on Exception catch (e, s) {
      throw PreferencesException(
          message: '', stackTrace: s, aditionalInfo: e.toString());
    }
  }
}
