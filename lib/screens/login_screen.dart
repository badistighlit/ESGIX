import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/post_list/post_list_bloc.dart';
import 'package:projet_esgix/repositories/post_repository.dart';
import 'package:projet_esgix/screens/home_screen.dart';
import 'package:projet_esgix/screens/register_screen.dart';
import 'package:projet_esgix/services/api_service.dat.dart';
import 'package:projet_esgix/blocs/auth/auth_bloc.dart';
import 'package:projet_esgix/blocs/auth/auth_event.dart';
import 'package:projet_esgix/blocs/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          _navigateToHomePage();
        } else if (state.status == AuthStatus.loginFailure) {
          _showErrorDialog();
        }
      },
      child: _showLoginPage(),
    );
  }

  Widget _showLoginPage() => Scaffold(
    appBar: AppBar(
      title: Text('Connexion'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Émail',
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
            ),
            obscureText: true,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _navigateToRegistrationScreen();
                },
                child: Text('S\'enregistrer'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                      Login(email: _usernameController.text, password: _passwordController.text)
                  );
                },
                child: Text('Se connecter'),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  void _showErrorDialog() => showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Erreur de Connexion'),
        content: Text('Erreur de Connexion'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ));

  void _navigateToHomePage() {
    final screen = RepositoryProvider(
      create: (context) => PostRepository(apiService: ApiService.instance!),
      child: BlocProvider(
        create: (context) => PostListBloc(repository: context.read<PostRepository>()),
        child: HomeScreen(),
      ),
    );
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => screen)
    );
  }

  void _navigateToRegistrationScreen() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
}
