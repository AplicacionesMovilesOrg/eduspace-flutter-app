import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/core/services/storage_service.dart';
import 'package:eduspace_flutter_app/features/auth/domain/user.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final StorageService storageService;

  AuthBloc({required this.storageService}) : super(AuthLoading()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final token = await storageService.getToken();
    final userId = await storageService.getUserId();
    final username = await storageService.getUsername();
    final role = await storageService.getRole();

    if (token != null && userId != null && username != null && role != null) {
      final user = User(
        id: userId,
        username: username,
        role: role,
        token: token,
      );
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    await storageService.saveSession(
      token: event.user.token,
      userId: event.user.id,
      username: event.user.username,
      role: event.user.role,
    );
    emit(Authenticated(event.user));
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await storageService.deleteSession();
    emit(Unauthenticated());
  }
}
