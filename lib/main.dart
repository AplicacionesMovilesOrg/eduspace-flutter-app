import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:eduspace_flutter_app/core/services/storage_service.dart';
import 'package:eduspace_flutter_app/features/auth/data/auth_service.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/login_bloc.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/pages/login_page.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/pages/welcome_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final storageService = StorageService();
  final authBloc = AuthBloc(storageService: storageService);
  authBloc.add(AppStarted());

  runApp(MainApp(authBloc: authBloc));
}

class MainApp extends StatelessWidget {
  final AuthBloc authBloc;

  const MainApp({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authBloc,
      child: MaterialApp(
        title: 'Eduspace Teacher',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is Authenticated) {
              return const WelcomePage();
            } else {
              return BlocProvider(
                create: (context) => LoginBloc(service: AuthService()),
                child: const LoginPage(),
              );
            }
          },
        ),
      ),
    );
  }
}
