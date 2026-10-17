import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/property.dart';

class ApiService {
  // 10.0.2.2 pour l'émulateur Android, 127.0.0.1 pour Windows/iOS
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<List<Property>> fetchProperties() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/properties'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        // Gère le cas où Laravel renvoie un tableau direct ou une structure paginée/enveloppée
        final List data = decoded is List ? decoded : (decoded['data'] ?? decoded['properties'] ?? []);
        return data.map((json) => Property.fromJson(json)).toList();
      } else {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      // Retourne une liste vide en cas d'erreur de liaison réseau pour éviter le crash de l'UI
      print('Erreur API fetchProperties: $e');
      return [];
    }
  }
}