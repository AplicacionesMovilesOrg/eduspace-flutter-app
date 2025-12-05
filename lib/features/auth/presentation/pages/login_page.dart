import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/core/enums/status.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/login_bloc.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/login_event.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const Color eduBlue = Color(0xFF1E88E5);
  static const Color eduLightBlue = Color(0xFF64B5F6);

  void _handleLoginSuccess(BuildContext context, LoginState state) {
    if (state.user != null) {
      context.read<AuthBloc>().add(LoggedIn(state.user!));
    }
  }

  void _handleLoginFailure(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Error de autenticación'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == Status.success) {
            _handleLoginSuccess(context, state);
          } else if (state.status == Status.failure) {
            _handleLoginFailure(context, state.message);
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.school_rounded,
                      size: 90,
                      color: eduBlue,
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'EduSpace',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: eduBlue,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Teacher Portal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 48),
                const _UsernameField(primaryColor: eduBlue),
                const SizedBox(height: 20),
                const _PasswordField(primaryColor: eduBlue),
                const SizedBox(height: 32),
                const _LoginButton(btnColor: eduBlue),
                const SizedBox(height: 48),
                Text(
                  '© 2025 EduSpace Platform',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UsernameField extends StatelessWidget {
  final Color primaryColor;
  const _UsernameField({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => context.read<LoginBloc>().add(
        OnUsernameChanged(username: value),
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: 'Usuario',
        hintText: 'Ej. jperez',
        prefixIcon: Icon(Icons.person_outline, color: Colors.grey.shade500),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        floatingLabelStyle: TextStyle(color: primaryColor),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final Color primaryColor;
  const _PasswordField({required this.primaryColor});

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
          obscureText: !state.isPasswordVisible,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => context.read<LoginBloc>().add(const Login()),
          style: const TextStyle(fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            labelText: 'Contraseña',
            hintText: '••••••',
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade500),
            suffixIcon: IconButton(
              icon: Icon(
                state.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey.shade500,
              ),
              onPressed: () => context.read<LoginBloc>().add(
                const TogglePasswordVisibility(),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            floatingLabelStyle: TextStyle(color: primaryColor),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  final Color btnColor;
  const _LoginButton({required this.btnColor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status == Status.loading) {
          return Center(
            child: CircularProgressIndicator(color: btnColor),
          );
        }
        return SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () => context.read<LoginBloc>().add(const Login()),
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'INGRESAR',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
        );
      },
    );
  }
}
