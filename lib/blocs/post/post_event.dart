import 'package:equatable/equatable.dart';

abstract class PostEvent {}

class FetchPosts extends PostEvent {
  final int page;
  final int offset;

  FetchPosts({this.page = 0, this.offset = 10});
}