import 'package:projet_esgix/models/user_model.dart';
import '../models/auth_user_model.dart';
import '../services/api_service.dat.dart';
import '../services/local_data_service.dart';

abstract class AuthRepository {
  Future<bool> loadCurrentUser();
  Future<void> logOut();
  Future<void> login(String email, String password);
  Future<void> register(String email, String password, String username, String avatar);
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;

  AuthRepositoryImpl(this.apiService);

  @override
  Future<bool> loadCurrentUser() async {
    String? token = await LocalDataService.getToken();
    String? authUserId = await LocalDataService.getAuthUserId();

    if (token != null && authUserId != null) {
      User user = await apiService.getUserById(authUserId, 'Bearer $token');
      AuthUser.fromUser(user, token);

      return true;
    }

    return false;
  }

  @override
  Future<void> logOut() async {
    await LocalDataService.clearAuthUserId();
    await LocalDataService.clearToken();
  }

  @override
  Future<void> login(String email, String password) async {
    await apiService.login(email, password);

    await LocalDataService.setAuthUserId(AuthUser.id!);
    await LocalDataService.setToken(AuthUser.bearerToken!);
  }

  @override
  Future<void> register(String email, String password, String username, String avatar) async {
    await apiService.register(email, password, username, avatar);
  }
}