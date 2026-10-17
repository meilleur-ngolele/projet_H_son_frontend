import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message_model.dart';
import 'api_config.dart';

class MessageService {
  static Future<List<MessageItem>> fetchUserMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/messages'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic body = json.decode(response.body);
        List data = [];
        if (body is List) {
          data = body;
        } else if (body is Map && body.containsKey('data')) {
          data = body['data'] ?? [];
        }
        return data.map((item) => MessageItem.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}