import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reservation.dart';
import 'api_config.dart';

class ReservationService {
  static Future<List<Reservation>> fetchUserBookings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/reservations'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((item) => Reservation.fromJson(item)).toList();
      } else {
        throw Exception('Erreur lors du chargement des réservations');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }
}