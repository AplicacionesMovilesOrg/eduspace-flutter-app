import 'package:eduspace_flutter_app/core/enums/status.dart';
import 'package:eduspace_flutter_app/features/auth/domain/user.dart';

class LoginState {
  final Status status;
  final String username;
  final String password;
  final bool isPasswordVisible;
  final String? message;
  final User? user;

  const LoginState({
    this.status = Status.initial,
    this.username = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.message,
    this.user,
  });

  LoginState copyWith({
    Status? status,
    String? username,
    String? password,
    bool? isPasswordVisible,
    String? message,
    User? user,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }
}
