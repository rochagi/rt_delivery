import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/presenter/login/cubits/cubit/auth_cubit.dart';
import 'package:rt_flash/app/presenter/login/cubits/master_key/master_key_cubit.dart';
import 'package:rt_flash/app/presenter/login/widgets/auth_form.dart';
import 'package:rt_flash/app/presenter/login/widgets/master_key_form.dart';
import 'package:rt_flash/config/dependency_injection.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late MasterKeyCubit _masterKeyCubit;
  late AuthCubit _authCubit;
  @override
  void initState() {
    _masterKeyCubit = injection.get<MasterKeyCubit>();
    _authCubit = injection.get<AuthCubit>();
    _masterKeyCubit.checkMasterKeyOnPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RT'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MultiBlocProvider(
              providers: [
                BlocProvider<MasterKeyCubit>(
                  create: (context) => _masterKeyCubit,
                ),
                BlocProvider<AuthCubit>(
                  create: (context) => _authCubit,
                ),
              ],
              child: BlocBuilder<MasterKeyCubit, MasterKeyState>(
                bloc: _masterKeyCubit,
                builder: (context, state) {
                  if (state is MasterKeySuccess) {
                    return state.hasKey
                        ? const AuthForm()
                        : const MasterKeyForm();
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
