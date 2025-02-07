import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/user/user_bloc.dart';
import 'package:projet_esgix/models/auth_user_model.dart';
import 'package:projet_esgix/repositories/user_repository.dart';
import 'package:projet_esgix/screens/home_screen.dart';
import 'package:projet_esgix/screens/register_screen.dart';
import 'package:projet_esgix/screens/user_profile_screen.dart';
import 'package:projet_esgix/services/api_service.dat.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../main.dart';
import 'home_screen.dart';

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
        if (state is AuthSuccess) {
          Widget screen = BlocProvider(
            create: (context) => UserBloc(repository: UserRepository(ApiService.instance!)),
            child: UserProfileScreen(userId: AuthUser.id!),
          );

          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => screen));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
        } else if (state is AuthFailure) {
          showDialog(
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
            ),
          );
        }
      },
      child: Scaffold(
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
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(
                      Login(email: _usernameController.text, password: _passwordController.text)
                  );
                },
                child: Text('Se connecter'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
                },
                child: Text('S\'enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
