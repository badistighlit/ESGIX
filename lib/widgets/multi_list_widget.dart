import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/post/post_bloc.dart';
import 'package:projet_esgix/blocs/post_list/post_list_bloc.dart';
import 'package:projet_esgix/exceptions/global/app_exception.dart';
import 'package:projet_esgix/models/post_model.dart';
import 'package:projet_esgix/repositories/post_repository.dart';
import 'package:projet_esgix/services/api_service.dat.dart';
import 'package:projet_esgix/widgets/post_card.dart';

class MultiListWidget extends StatefulWidget {
  const MultiListWidget({super.key, required this.userId});

  final String userId;

  @override
  State<MultiListWidget> createState() => _MultiListWidgetState();
}

class _MultiListWidgetState extends State<MultiListWidget> {
  bool leftTabSelected = true;

  @override
  void initState() {
    super.initState();

    _getUserPosts(context, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        leftTabSelected = true;
                        _getUserPosts(context, widget.userId);
                      });
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Posts',
                          style: TextStyle(
                            fontSize: 20,
                            color: leftTabSelected ? Colors.blue : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        leftTabSelected = false;
                        _getUserLikedPosts(context, widget.userId);
                      });
                    },
                    child: Center(
                      child: Text(
                        'Liked Posts',
                        style: TextStyle(
                          fontSize: 20,
                          color: leftTabSelected ? Colors.black : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
          Expanded(
            flex: 9,
            child: BlocBuilder<PostListBloc, PostListState>(builder: (context, state) {
              return switch(state.status) {
                PostListStatus.loading => _onLoading(),
                PostListStatus.empty => _onEmptySuccess(),
                PostListStatus.success => _onSuccess(state.posts),
                PostListStatus.failure => _onFailure(state.exception!),
              };
            }),
          ),
        ],
      );
  }

  Widget _onLoading() => CircularProgressIndicator();

  Widget _onSuccess(List<Post> posts) => Center(
    child: ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return RepositoryProvider<PostRepository>(
          create: (context) => PostRepository(apiService: ApiService.instance!),
          child: BlocProvider<PostBloc>(
            create: (context) => PostBloc(repository: context.read<PostRepository>()),
            child: PostCard(
                post: posts[index],
            ),
          ),
        );
      }
    ),
  );

  Widget _onFailure(AppException exception) => Center(child: Text("Failed to fetch posts"));

  Widget _onEmptySuccess() => Center(child: Text('No Posts to show yet!', style: TextStyle(fontSize: 20),));

  void _getUserPosts(BuildContext context, String userId) => context.read<PostListBloc>().add(GetUserPosts(userId: userId, likedPosts: ! leftTabSelected));

  void _getUserLikedPosts(BuildContext context, String userId) => context.read<PostListBloc>().add(GetUserPosts(userId: userId, likedPosts: ! leftTabSelected));
}
