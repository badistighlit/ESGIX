import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/user/user_bloc.dart';
import 'package:projet_esgix/models/user_model.dart';
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
            Status.loading => _showLoading(),
            Status.success => _showDetails(state.user!),
            // Status.failure => _showFailure(),
            Status.failure => _showDetails(state.user!),
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
      color: Colors.red,
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
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.network(
                          'https://static-00.iconduck.com/assets.00/avatar-icon-512x512-gu21ei4u.png',
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
          // Expanded(
          //   flex: 1,
          //     child: Container(
          //       height: 10,
          //     ),
          // ),
          Expanded(
            flex: isCollapsed ? 7 : 6,
            child: Container(
              width: double.infinity,
              color: Colors.blue,
            ),
            // child: Row(
            //   children: [
            //
            //   ],
            // ),
          ),
        ],
      ),
    );
  }
  // Widget _showFailure() {
  //
  // }

  void _fetchUser(String userId) {
    context.read<UserBloc>().add(GetUser(userId));
  }
}
