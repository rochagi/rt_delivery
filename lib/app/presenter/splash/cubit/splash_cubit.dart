import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/shared/preferences/i_preferences.dart';

import '../../../shared/preferences/preferences_enum.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final IPreferences _preferences;

  SplashCubit({required IPreferences preferences})
      : _preferences = preferences,
        super(SplashInitial());

  Future<void> checkSession() async {
    try {
      final session = _preferences.get<String?>(
          type: PreferencesType.string, key: PrefencesKeyEnum.session);

      emit(SplashSuccess(hasSession: session != null));
      log("✅ Successo ao verificar sessão, existe sessão: ${session != null}");
    } catch (e) {
      emit(const SplashError(message: 'Erro ao recuperar sessão'));
      log("💩 Erro ao verificar sessão");
    }
  }
}
