import 'package:projet_esgix/models/user_model.dart';
import 'package:projet_esgix/repositories/contracts/user_repository_interface.dart';
import 'package:projet_esgix/services/api_service.dat.dart';

class UserRepository implements UserRepositoryInterface {
  final ApiService apiService;

  UserRepository(this.apiService);

  @override
  Future<User> getUserById(String id) async {
    return apiService.getUserById(id);
  }
}
