import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/auth/auth_event.dart';
import 'package:projet_esgix/blocs/auth/auth_state.dart';
import 'package:projet_esgix/repositories/auth_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:projet_esgix/screens/home_screen.dart';
import 'package:projet_esgix/services/api_service.dat.dart';
import 'blocs/auth/auth_bloc.dart';
import 'screens/login_screen.dart';

ApiService initApiService() {
  return ApiService(
      baseUrl: 'https://esgix.tech',
      defaultHeaders: {
        'x-api-key': dotenv.get('API_KEY'),
        'Content-Type': 'application/json'
      });
}

Future<void> main() async {
  await dotenv.load();
  final apiService = initApiService();
  final AuthRepository authRepository = AuthRepositoryImpl(apiService);

    runApp(BlocProvider(
        create: (context) => AuthBloc(AuthRepositoryImpl(apiService)),
        child: MyApp(authRepository: authRepository)
    ));
}

class MyApp extends StatefulWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return MaterialApp(
            title: 'Projet Esgix',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: _redirectToScreen(state)

          //   state is AuthSuccess
          //         ?
          //           BlocProvider(
          //           create: (context) => UserBloc(repository: UserRepository(ApiService.instance!)),
          //           child: UserProfileScreen(userId: AuthUser.id!),
          //         )
          //         HomeScreen()
          //         : LoginScreen(),
          );
    });
  }

  Widget _redirectToScreen(AuthState state) {
    if (state.status == AuthStatus.success) {
      return HomeScreen();
    }

    return BlocProvider(
        create: (context) => AuthBloc(widget.authRepository),
        child: LoginScreen()
    );
  }
}