import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/post_list/post_list_bloc.dart';
import 'package:projet_esgix/blocs/user/user_bloc.dart';
import 'package:projet_esgix/models/user_model.dart';
import 'package:projet_esgix/repositories/post_repository.dart';
import 'package:projet_esgix/services/api_service.dat.dart';
import 'package:projet_esgix/widgets/multi_list_widget.dart';
import 'package:readmore/readmore.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isCollapsed = true;
  final ValueNotifier<bool> isCollapsedValueNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    isCollapsedValueNotifier.addListener(() {
      setState(() {
        isCollapsed = ! isCollapsed;
      });
    });

    _fetchUser(widget.userId);
  }

  @override
  void dispose() {
    isCollapsedValueNotifier.dispose(); // Clean up the listener to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Icon(Icons.mode_edit),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        return Container (
          child: switch (state.status) {
            UserStateStatus.loading => _showLoading(),
            UserStateStatus.success => _showDetails(state.user!),
            UserStateStatus.failure => _showFailure(),
          },
        );
      }),
    );
  }

  Widget _showLoading() {
    return CircularProgressIndicator();
  }
  Widget _showDetails(User user) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: isCollapsed ? 3 : 4,
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.network(
                          user.avatar!,
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '@${user.username!}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Align(
                      alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 15),
                          child: ReadMoreText(
                            user.description!,
                            trimMode: TrimMode.Line,
                            trimLines: 2,
                            trimExpandedText: ' show less',
                            style: TextStyle(fontSize: 13),
                            isCollapsed: isCollapsedValueNotifier,
                          )
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: isCollapsed ? 7 : 6,
            child: BlocProvider(
              create: (context) => PostListBloc(repository: PostRepository(apiService: ApiService.instance!)),
              child: MultiListWidget(userId: widget.userId),
            ),
          ),
        ],
      ),
    );
  }
  Widget _showFailure() => Center(child: Text('Failed to fetch user info'));

  void _fetchUser(String userId) {
    context.read<UserBloc>().add(GetUser(userId));
  }
}
