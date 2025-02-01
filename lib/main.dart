import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/repositories/auth_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authRepository),
      child: MaterialApp(
        title: 'Projet Esgix',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoginScreen(),
      ),
    );
  }
}
