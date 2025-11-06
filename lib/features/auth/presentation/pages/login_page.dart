import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/core/enums/status.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/login_bloc.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/login_event.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.status == Status.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login exitoso')),
                );
              } else if (state.status == Status.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message ?? 'Error en el login')),
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return TextField(
                      onChanged: (value) {
                        context
                            .read<LoginBloc>()
                            .add(OnUsernameChanged(username: value));
                      },
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return TextField(
                      onChanged: (value) {
                        context
                            .read<LoginBloc>()
                            .add(OnPasswordChanged(password: value));
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            context
                                .read<LoginBloc>()
                                .add(const TogglePasswordVisibility());
                          },
                        ),
                      ),
                      obscureText: !state.isPasswordVisible,
                    );
                  },
                ),
                const SizedBox(height: 32),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    if (state.status == Status.loading) {
                      return const CircularProgressIndicator();
                    }
                    return FilledButton(
                      onPressed: () {
                        context.read<LoginBloc>().add(const Login());
                      },
                      child: const Text('Ingresar'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
