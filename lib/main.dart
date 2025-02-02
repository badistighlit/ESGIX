import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/repositories/auth_repository.dart';
import 'package:projet_esgix/repositories/post_repository.dart';
import 'package:projet_esgix/screens/login_screen.dart';
import 'package:projet_esgix/services/api_service.dat.dart';
import 'package:projet_esgix/widgets/post_card.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_state.dart';
import 'blocs/post/post_bloc.dart';
import 'blocs/post/post_event.dart';
import 'blocs/post/post_state.dart';

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ApiService apiService;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.apiService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiService>.value(value: apiService),
        RepositoryProvider<AuthRepository>.value(value: authRepository),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(authRepository)..add(AppStarted()),
        child: MaterialApp(
          title: 'Projet Esgix',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const AuthWrapper(),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthSuccess) {
          return HomeScreen();
        } else if (state is AuthFailure || state is AuthInitial) {
          return const LoginScreen();
        } else {
          return const Scaffold(
            body: Center(child: Text('Une erreur est survenue.')),
          );
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(
        repository: PostRepository(
          apiService: context.read<ApiService>(),
        ),
      )..add(FetchPosts()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Posts'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LoggedOut());
              },
            ),
          ],
        ),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PostBloc>().add(FetchPosts());
                },
                child: ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(post: state.posts[index]);
                  },
                ),
              );
            } else if (state is PostError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PostBloc>().add(FetchPosts());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('No posts available'));
          },
        ),
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final apiService = ApiService(
    baseUrl: 'https://esgix.tech',
    httpClient: http.Client(),
  );

  final authRepository = AuthRepositoryImpl(apiService);

  runApp(MyApp(
    authRepository: authRepository,
    apiService: apiService,
  ));
}