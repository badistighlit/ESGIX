import 'package:projet_esgix/models/user_model.dart';

abstract class UserRepositoryInterface {
  Future<User> getUserById(String id);
}