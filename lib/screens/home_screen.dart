import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/auth/auth_event.dart';
import 'package:projet_esgix/blocs/comment_list/comment_list_bloc.dart';
import 'package:projet_esgix/blocs/comment_modifier/comment_modifier_bloc.dart';
import 'package:projet_esgix/blocs/post/post_bloc.dart';
import 'package:projet_esgix/blocs/post_list/post_list_bloc.dart';
import 'package:projet_esgix/exceptions/global/app_exception.dart';
import 'package:projet_esgix/screens/post_detail_screen.dart';
import 'package:projet_esgix/services/api_service.dat.dart';
import 'package:projet_esgix/widgets/post_card.dart';
import 'package:projet_esgix/blocs/auth/auth_bloc.dart';
import 'package:projet_esgix/models/post_model.dart';
import 'package:projet_esgix/repositories/post_repository.dart';
import 'create_or_edit_post_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

    _fetchAllPosts();
  }

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(LogOut());

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  void _navigateToCreatePostScreen() async {
    final bool? postCreated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePostScreen(postRepository: context.read<PostRepository>())),
    );

    if (postCreated == true) {
      setState(() {
        _fetchAllPosts();
      });
    }
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
      body: BlocBuilder<PostListBloc, PostListState>(
        builder: (context, state) {
          return switch (state.status) {
            PostListStatus.loading => _showLoading(),
            PostListStatus.success => _showSuccess(state.posts),
            PostListStatus.failure => _showFailure(state.exception!),
            PostListStatus.empty => _showEmpty()
          };
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

  Widget _showLoading() => const Center(child: CircularProgressIndicator());

  Widget _showSuccess(List<Post> posts) => ListView.builder(
    padding: const EdgeInsets.all(8.0),
    itemCount: posts.length,
    itemBuilder: (context, index) {
      return BlocProvider<PostBloc>(
        create: (context) => PostBloc(repository: context.read<PostRepository>()),
        child: PostCard(
            post: posts[index],
            postDetailsNavigator : _navigateToPostDetailScreen
        ),
      );
    },
  );

  Widget _showFailure(AppException error) => Center(child: Text("Erreur : $error"));

  Widget _showEmpty() => const Center(child: Text("Aucun post disponible."));

  void _fetchAllPosts() => context.read<PostListBloc>().add(GetAllPosts());

  void _reloadPosts() => _fetchAllPosts();

  void _navigateToPostDetailScreen(String postId) async {
    final bool? postUpdated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepositoryProvider<PostRepository>(
          create: (context) => PostRepository(apiService: ApiService.instance!),
          child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => CommentListBloc(repository: context.read<PostRepository>())),
                BlocProvider(create: (context) => PostBloc(repository: context.read<PostRepository>())),
                BlocProvider(create: (context) => CommentModifierBloc(repository: context.read<PostRepository>())),
              ],
              child: PostDetailScreen(postId: postId)
          ),
        ),
      ),
    );

    if (postUpdated == true) {
      _reloadPosts();
    }
  }
}
