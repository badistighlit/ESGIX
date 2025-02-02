import 'package:projet_esgix/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dat.dart';



abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<Register> register(String email, String password, String username, String avatar);
  Future<User?> getCurrentUser();
  Future<void> logout();
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

  @override
  Future<User?> getCurrentUser() async {
    // Récupérer le token stocké
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    if (token != null && userId != null) {
      // Mettre à jour le token dans l'ApiService
      apiService.setToken(token);
      // Retourner les informations de l'utilisateur
      try {
        final user = await apiService.getUserInfo(userId);
        return user;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    apiService.setToken('');
  }
}
