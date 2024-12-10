import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/shared/preferences/i_preferences.dart';
import 'package:rt_flash/app/shared/preferences/preferences_enum.dart';

part 'master_key_state.dart';

class MasterKeyCubit extends Cubit<MasterKeyState> {
  final IPreferences _preferences;

  MasterKeyCubit({required IPreferences preferences})
      : _preferences = preferences,
        super(MasterKeyInitial());

  Future<void> checkMasterKeyOnPreferences() async {
    try {
      emit(MasterKeyLoading());

      emit(MasterKeySuccess(
          hasKey: _preferences.checkIfExists(key: PrefencesKeyEnum.masterKey)));
    } catch (e) {
      emit(const MasterKeyError(message: 'Erro ao verificar chave mestre'));
    }
  }

  Future<void> checkMasterKey({required String masterKey}) async {
    try {
      emit(MasterKeyLoading());
      final isTheSameMasterKey = masterKey == 'tbmvc';

      if (isTheSameMasterKey) {
        await _preferences.save(
            type: PreferencesType.bool,
            data: isTheSameMasterKey,
            key: PrefencesKeyEnum.masterKey);
        emit(MasterKeySuccess(hasKey: isTheSameMasterKey));
        return;
      }

      emit(const MasterKeyError(message: 'Chave incorreta, verifique!'));
    } catch (e) {
      emit(const MasterKeyError(message: 'Erro ao verificar chave mestre'));
    }
  }
}
