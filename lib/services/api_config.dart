import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // URL pour le navigateur (Chrome / Web)
      return 'http://127.0.0.1:8000/api';
    } else {
      // URL pour l'émulateur Android (10.0.2.2)
      // Note: Si un jour tu testes sur un vrai téléphone physique via USB, remplace '10.0.2.2' par l'IP de ton PC (ex: 'http://192.168.1.15:8000/api')
      return 'http://10.0.2.2:8000/api';
    }
  }
}