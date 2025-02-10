import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/auth/auth_bloc.dart';
import 'package:projet_esgix/repositories/auth_repository.dart';
import 'package:projet_esgix/screens/login_screen.dart';
import 'package:projet_esgix/screens/register_screen.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<void> login(String email, String password) async {
    if (email == "test@test.com" && password == "password") {
      return;
    }
    throw Exception("Login failed");
  }

  @override
  Future<bool> loadCurrentUser() async => false;

  @override
  Future<void> logOut() async {}

  @override
  Future<void> register(String email, String password, String username, String avatar) async {}
}

void main() {
  late AuthBloc authBloc;

  setUp(() {
    authBloc = AuthBloc(FakeAuthRepository());
  });

  testWidgets('Affichage du LoginScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>(
          create: (_) => authBloc,
          child: const LoginScreen(),
        ),
      ),
    );

    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Émail'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
    expect(find.text('S\'enregistrer'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });

  testWidgets('Connexion réussie avec de bonnes infos', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>(
          create: (_) => authBloc,
          child: const LoginScreen(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), "test@test.com");
    await tester.enterText(find.byType(TextField).at(1), "password");
    await tester.tap(find.text('Se connecter'));

    await tester.pumpAndSettle();
    expect(find.text('Erreur de Connexion'), findsNothing);
  });

  testWidgets('Redirection vers RegisterScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<AuthBloc>(
        create: (_) => authBloc,
        child: MaterialApp(
          home: const LoginScreen(),
        ),
      ),
    );

    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.tap(find.text("S'enregistrer"));
    await tester.pumpAndSettle(); // Attendre la fin de la navigation

    expect(find.byType(RegisterScreen), findsOneWidget);
  });
}
