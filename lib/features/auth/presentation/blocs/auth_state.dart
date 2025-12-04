import 'package:eduspace_flutter_app/features/auth/domain/user.dart';

abstract class AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}
