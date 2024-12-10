import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/presenter/splash/cubit/splash_cubit.dart';
import 'package:rt_flash/config/app_routes.dart';
import 'package:rt_flash/config/dependency_injection.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = injection.get<SplashCubit>();
    Future.delayed(
      const Duration(seconds: 2),
      () => cubit.checkSession(),
    );
    return Material(
      child: BlocListener<SplashCubit, SplashState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is SplashSuccess) {
            state.hasSession
                ? Navigator.pushReplacementNamed(context, AppRoutes.home)
                : Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
          if (state is SplashError) {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        },
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
