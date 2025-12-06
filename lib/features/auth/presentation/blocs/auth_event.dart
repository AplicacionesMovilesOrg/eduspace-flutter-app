import 'package:eduspace_flutter_app/features/auth/domain/user.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final User user;

  LoggedIn(this.user);
}

class LoggedOut extends AuthEvent {}
