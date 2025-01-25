import 'package:projet_esgix/models/user_model.dart';
import '../services/api_service.dat.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<Register> register(String email, String password, String username, String avatar);
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;

  AuthRepositoryImpl(this.apiService);

  @override
  Future<User> login(String email, String password) {
    return apiService.login(email, password);
  }

  @override
  Future<Register> register(String email, String password, String username, String avatar) {
    return apiService.register(email, password, username, avatar);
  }
}
