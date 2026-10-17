import 'package:flutter/material.dart';
import '../models/property.dart';
import '../services/property_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Property>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    _favoritesFuture = PropertyService.fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mes favoris', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Property>>(
                  future: _favoritesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF00A86B)));
                    }
                    final favorites = snapshot.data ?? [];
                    if (favorites.isEmpty) {
                      return const Center(child: Text('Aucun favori enregistré.'));
                    }
                    return ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final property = favorites[index];
                        return ListTile(
                          title: Text(property.title),
                          subtitle: Text('${property.pricePerNight} FCFA'),
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            onPressed: () async {
                              await PropertyService.toggleFavorite(property.id);
                              setState(() => _loadFavorites());
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}