import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/infra/session/datasource/remote/session_api_auth.dart';
import 'package:rt_flash/app/shared/preferences/i_preferences.dart';
import 'package:rt_flash/app/shared/utils/app_exceptions.dart';

import '../../../../shared/preferences/preferences_enum.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ISessionApiAuth _sessionApiAuth;
  final IPreferences _preferences;

  AuthCubit(
      {required ISessionApiAuth sessionApiAuth,
      required IPreferences preferences})
      : _sessionApiAuth = sessionApiAuth,
        _preferences = preferences,
        super(AuthInitial());

  Future<void> auth(
      {required String host,
      required String identification,
      required String login,
      required String password}) async {
    try {
      await _sessionApiAuth.auth(
        host: host,
        identification: identification,
        login: login,
        password: password,
      );
      await _preferences.save(
          type: PreferencesType.string,
          data: {
            'host': host,
            'login': login,
            'password': password,
          },
          key: PrefencesKeyEnum.session);

      emit(AuthSuccess());
    } on ApiDataException {
      emit(const AuthError(
          message: 'Dados de acesso incorretos, favor revisar'));
    } catch (e) {
      emit(const AuthError(message: 'Erro ao tentar acesso'));
    }
  }
}
