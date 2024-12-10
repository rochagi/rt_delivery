import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/presenter/login/cubits/cubit/auth_cubit.dart';
import 'package:rt_flash/config/app_routes.dart';

import '../../../shared/widgets/buttons/custom_elevated_button.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  late final TextEditingController _host;
  late final TextEditingController _identification;
  late final TextEditingController _login;
  late final TextEditingController _password;
  late final GlobalKey<FormState> _formKey;
  bool _buttonActive = false;
  bool obscurePass = true;

  @override
  void initState() {
    _host = TextEditingController();
    _identification = TextEditingController();
    _login = TextEditingController();
    _password = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              "Configurar",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 40),
            TextFormField(
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              controller: _host,
              onChanged: (value) => _changeButtonStatus(),
              decoration: const InputDecoration(labelText: 'Host Servidor'),
              validator: (value) {
                if ((value ?? '').length < 3) {
                  return 'Preencha o host corretamente';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              controller: _identification,
              onChanged: (value) => _changeButtonStatus(),
              decoration: const InputDecoration(labelText: 'Identificação'),
              validator: (value) {
                if ((value ?? '').isEmpty) {
                  return 'Preencha a identificação corretamente';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              controller: _login,
              onChanged: (value) => _changeButtonStatus(),
              decoration: const InputDecoration(labelText: 'Login'),
              validator: (value) {
                if ((value ?? '').length < 3) {
                  return 'Preencha o login corretamente';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              controller: _password,
              onChanged: (value) => _changeButtonStatus(),
              obscureText: obscurePass,
              decoration: InputDecoration(
                labelText: 'Senha',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePass = !obscurePass;
                    });
                  },
                  icon: Icon(
                      obscurePass ? Icons.visibility : Icons.visibility_off),
                ),
              ),
              validator: (value) {
                if ((value ?? '').length < 2) {
                  return 'Preencha a senha corretamente';
                }
                return null;
              },
            ),
            const SizedBox(height: 40),
            BlocBuilder<AuthCubit, AuthState>(
              bloc: context.read<AuthCubit>(),
              builder: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }

                if (state is AuthSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  });
                }

                return SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    title: "Entrar",
                    onTap: _buttonActive || state is! AuthLoading
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().auth(
                                  host: _host.text,
                                  identification: _identification.text,
                                  login: _login.text,
                                  password: _password.text);
                            }
                          }
                        : null,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  _changeButtonStatus() {
    setState(() {
      _buttonActive = _host.text.isNotEmpty &&
          _identification.text.isNotEmpty &&
          _login.text.isNotEmpty &&
          _password.text.isNotEmpty;
    });
  }
}
