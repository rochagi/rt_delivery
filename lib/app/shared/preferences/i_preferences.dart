import 'preferences.dart';
import 'preferences_enum.dart';

abstract interface class IPreferences {
  Future<void> save<T>(
      {required PreferencesType type,
      required T data,
      required PrefencesKeyEnum key});
  T? get<T>({required PreferencesType type, required PrefencesKeyEnum key});
  bool checkIfExists({required PrefencesKeyEnum key});

  Future<void> delete({required PrefencesKeyEnum key});
  Future<void> deleteAll();
}
