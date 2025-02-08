import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/screens/post_detail_screen.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../models/auth_user_model.dart';
import '../models/post_model.dart';
import '../repositories/post_repository.dart';
import '../services/api_service.dat.dart';
import '../widgets/post_list_screen.dart';
import 'CreatePostScreen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PostRepository postRepository;
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    final apiService = ApiService(baseUrl: 'https://esgix.tech');
    postRepository = PostRepository(apiService: apiService);
    _postsFuture = postRepository.getPosts();
  }

  void _logout(BuildContext context) {
    AuthUser.clearCurrentInstance();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  void _navigateToCreatePostScreen() async {
    final bool? postCreated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePostScreen(postRepository: postRepository)),
    );

    if (postCreated == true) {
      setState(() {
        _postsFuture = postRepository.getPosts();
      });
    }
  }

  void _navigateToPostDetailScreen(String postId) async {
    final bool? postUpdated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(postId: postId),
      ),
    );

    if (postUpdated == true) {
      _reloadPosts();
    }
  }

  void _reloadPosts() {
    setState(() {
      _postsFuture = postRepository.getPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          ),
          IconButton(
            icon: const Icon(Icons.change_circle_rounded),
            onPressed: () => _reloadPosts(),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return FutureBuilder<List<Post>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Aucun post disponible."));
                } else {
                  return PostList(
                      posts: snapshot.data!,
                      postRepository: postRepository,
                      onPostDeleted: _reloadPosts,
                      backFromDetails: _navigateToPostDetailScreen
                  );
                }
              },
            );
          } else {
            return const Center(child: Text("Vous n'êtes pas connecté."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePostScreen,
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {

              },
            ),
          ],
        ),
      ),
    );
  }
}