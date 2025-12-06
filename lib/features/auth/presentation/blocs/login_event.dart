abstract class LoginEvent {
  const LoginEvent();
}

class Login extends LoginEvent {
  const Login();
}

class OnUsernameChanged extends LoginEvent {
  final String username;
  const OnUsernameChanged({required this.username});
}

class OnPasswordChanged extends LoginEvent {
  final String password;
  const OnPasswordChanged({required this.password});
}

class TogglePasswordVisibility extends LoginEvent {
  const TogglePasswordVisibility();
}
