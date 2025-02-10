import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/auth/auth_bloc.dart';
import 'package:projet_esgix/blocs/post_list/post_list_bloc.dart';
import 'package:projet_esgix/models/post_model.dart';
import 'package:projet_esgix/repositories/auth_repository.dart';
import 'package:projet_esgix/repositories/post_repository.dart';
import 'package:projet_esgix/screens/home_screen.dart';
import 'package:projet_esgix/screens/login_screen.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<bool> loadCurrentUser() async => true;

  @override
  Future<void> logOut() async {}

  @override
  Future<void> register(String email, String password, String username, String avatar) async {}
}

class FakePostRepository implements PostRepository {
  @override
  Future<List<Post>> getPosts({int offset = 0, int page = 1}) async {
    return [
      Post(
        id: "1",
        content: "Premier post de test",
        author: Author(id: "1", username: "TestUser", avatar: ""),
        likesCount: 10,
        commentsCount: 2,
        likedByUser: false,
      ),
    ];
  }

  @override
  Future<bool> deletePostById(String postId) async => true;

  @override
  Future<bool> likePost(String postId) async => true;

  @override
  Future<Post> getPostById(String postId) async {
    return Post(
      id: postId,
      content: "Contenu du post",
      author: Author(id: "1", username: "TestUser", avatar: ""),
      likesCount: 10,
      commentsCount: 2,
      likedByUser: false,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}


void main() {
  late AuthBloc authBloc;
  late PostListBloc postListBloc;

  setUp(() {
    authBloc = AuthBloc(FakeAuthRepository());
    postListBloc = PostListBloc(repository: FakePostRepository());
  });

  testWidgets('Affichage du HomeScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(create: (_) => authBloc),
            BlocProvider<PostListBloc>(create: (_) => postListBloc),
          ],
          child: const HomeScreen(),
        ),
      ),
    );

    expect(find.text('Home Page'), findsOneWidget);

    expect(find.byIcon(Icons.exit_to_app), findsOneWidget);
    expect(find.byIcon(Icons.change_circle_rounded), findsOneWidget);

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Affichage du message Aucun post disponible', (WidgetTester tester) async {
    postListBloc.emit(PostListState(status: PostListStatus.empty));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PostListBloc>(
          create: (_) => postListBloc,
          child: const HomeScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Aucun post disponible.'), findsOneWidget);
  });

  testWidgets('Affichage des posts sur HomeScreen', (WidgetTester tester) async {
    postListBloc.emit(PostListState(
      status: PostListStatus.success,
      posts: [
        Post(
          id: "1",
          content: "Premier post de test",
          author: Author(id: "1", username: "TestUser", avatar: ""),
          likesCount: 10,
          commentsCount: 2,
          likedByUser: false,
        ),
      ],
    ));

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<PostListBloc>(create: (_) => postListBloc),
            BlocProvider<AuthBloc>(create: (_) => authBloc),
          ],
          child: const HomeScreen(),
        ),
      ),
    );

    await tester.pump(); // Attendre que l'UI se mette à jour

    expect(find.text('Premier post de test'), findsOneWidget);
    expect(find.text('TestUser'), findsOneWidget);
  });


  testWidgets('Appui sur le bouton de création de post', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PostListBloc>(
          create: (_) => postListBloc,
          child: const HomeScreen(),
        ),
      ),
    );

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

  });

  testWidgets('Appui sur le bouton de déconnexion', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(create: (_) => authBloc),
            BlocProvider<PostListBloc>(create: (_) => postListBloc),
          ],
          child: const HomeScreen(),
        ),
      ),
    );

    expect(find.byIcon(Icons.exit_to_app), findsOneWidget);

    await tester.tap(find.byIcon(Icons.exit_to_app));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
