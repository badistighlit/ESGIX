import '../services/api_service.dat.dart';

abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> register(String email, String password, String username, String avatar);
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;

  AuthRepositoryImpl(this.apiService);

  @override
  Future<void> login(String email, String password) async {
    await apiService.login(email, password);
  }

  @override
  Future<void> register(String email, String password, String username, String avatar) async {
    await apiService.register(email, password, username, avatar);
  }
}
