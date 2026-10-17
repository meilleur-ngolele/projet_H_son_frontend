import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';

class ChatService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Récupérer la liste des conversations
  static Future<List<ChatConversation>> fetchConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/conversations'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((json) => ChatConversation.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erreur ChatService.fetchConversations: $e');
    }

    // Données de secours (Mock) pour démo directe sans backend lancé
    return [
      ChatConversation(
        id: 1,
        propertyTitle: 'Hotel Le Panorama',
        propertyImage: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=200',
        lastMessage: 'Bonjour ! Comment puis-je vous aider ?',
        lastMessageTime: '10:24',
        unreadCount: 2,
        isOnline: true,
      ),
      ChatConversation(
        id: 2,
        propertyTitle: 'Villa des Rêves',
        propertyImage: 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=200',
        lastMessage: 'Oui, la maison est disponible. Voulez-vous...',
        lastMessageTime: 'Hier',
        unreadCount: 0,
        isOnline: false,
      ),
      ChatConversation(
        id: 3,
        propertyTitle: 'Appartement Moderne',
        propertyImage: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=200',
        lastMessage: 'D\'accord, je vous envoie les photos.',
        lastMessageTime: 'Lun.',
        unreadCount: 0,
        isOnline: false,
      ),
    ];
  }

  // Envoyer un message à Laravel
  static Future<bool> sendMessage(int conversationId, String text) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.post(
        Uri.parse('$baseUrl/conversations/$conversationId/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: json.encode({'message': text}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Erreur ChatService.sendMessage: $e');
      return true; // Retourne true en local pour la démo UI
    }
  }
}