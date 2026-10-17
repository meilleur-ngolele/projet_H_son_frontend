import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class AuthService {
  // 1. Connexion utilisateur
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/login'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        final token = data['token'] ?? data['access_token'] ?? '';
        if (token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          if (data['user'] != null) {
            await prefs.setString('user_name', data['user']['name'] ?? 'Utilisateur');
            await prefs.setString('user_email', data['user']['email'] ?? '');
          }
        }
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Erreur de connexion'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur réseau : $e'};
    }
  }

  // 2. Inscription d'un nouvel utilisateur
  static Future<Map<String, dynamic>> register(
      String name,
      String email,
      String phone,
      String password,
      String passwordConfirmation,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/register'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = data['token'] ?? data['access_token'] ?? '';
        if (token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString('user_name', name);
          await prefs.setString('user_email', email);
        }
        return {'success': true, 'data': data};
      } else {
        String message = data['message'] ?? 'Erreur lors de l\'inscription';
        if (data['errors'] != null && data['errors'] is Map) {
          final Map errors = data['errors'];
          message = errors.values.first[0].toString();
        }
        return {'success': false, 'message': message};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur réseau : $e'};
    }
  }

  // 3. Récupérer le profil de l'utilisateur connecté via /api/user
  static Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        return null;
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final name = data['name'] ?? 'Utilisateur';
        final email = data['email'] ?? '';
        await prefs.setString('user_name', name);
        await prefs.setString('user_email', email);
        return data;
      } else if (response.statusCode == 401) {
        // Token expiré ou invalide -> Nettoyage
        await prefs.remove('auth_token');
        await prefs.remove('user_name');
        await prefs.remove('user_email');
        return null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // 4. Déconnexion propre
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
  }
}