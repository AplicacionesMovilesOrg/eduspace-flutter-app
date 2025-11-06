import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/core/enums/status.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/login_bloc.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/login_event.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/login_state.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/pages/welcome_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _handleLoginSuccess(BuildContext context, LoginState state) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => WelcomePage(
          username: state.user?.username ?? '',
          role: state.user?.role ?? '',
        ),
      ),
    );
  }

  void _handleLoginFailure(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Error en el login')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<LoginBloc, LoginState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status == Status.success) {
                _handleLoginSuccess(context, state);
              } else if (state.status == Status.failure) {
                _handleLoginFailure(context, state.message);
              }
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _UsernameField(),
                SizedBox(height: 16),
                _PasswordField(),
                SizedBox(height: 32),
                _LoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UsernameField extends StatelessWidget {
  const _UsernameField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => context.read<LoginBloc>().add(
        OnUsernameChanged(username: value),
      ),
      decoration: const InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
        previous.isPasswordVisible != current.isPasswordVisible,
      builder: (context, state) {
        return TextField(
          onChanged: (value) => context.read<LoginBloc>().add(
            OnPasswordChanged(password: value),
          ),
          decoration: InputDecoration(
            labelText: 'Password',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                state.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () => context.read<LoginBloc>().add(
                const TogglePasswordVisibility(),
              ),
            ),
          ),
          obscureText: !state.isPasswordVisible,
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status == Status.loading) {
          return const CircularProgressIndicator();
        }
        return FilledButton(
          onPressed: () => context.read<LoginBloc>().add(const Login()),
          child: const Text('Ingresar'),
        );
      },
    );
  }
}
