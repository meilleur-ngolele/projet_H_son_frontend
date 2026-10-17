import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/property.dart';
import 'api_config.dart';

class PropertyService {
  static Future<List<Property>> fetchProperties() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/properties'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List data = decoded is List ? decoded : (decoded['data'] ?? []);
      return data.map((json) => Property.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de charger les propriétés (${response.statusCode})');
    }
  }

  static Future<bool> createProperty({
    required String title,
    required String description,
    required String type,
    required double pricePerNight,
    required String city,
    required String address,
    required String imageUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/properties'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'title': title,
        'description': description,
        'type': type,
        'price_per_night': pricePerNight,
        'city': city,
        'address': address,
        'image_url': imageUrl,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<List<Property>> fetchFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/favorites'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List data = decoded is List ? decoded : (decoded['data'] ?? []);
      return data.map((json) => Property.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de charger les favoris');
    }
  }

  static Future<bool> toggleFavorite(int propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/favorites/toggle'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'property_id': propertyId}),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}