import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/property.dart';
import '../services/property_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Centre initial ajusté sur Brazzaville (-4.2634, 15.2429)
  final LatLng _brazzavilleCenter = const LatLng(-4.2634, 15.2429);
  late Future<List<Property>> _propertiesFuture;

  @override
  void initState() {
    super.initState();
    _propertiesFuture = PropertyService.fetchProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<List<Property>>(
            future: _propertiesFuture,
            builder: (context, snapshot) {
              List<Marker> markers = [];
              if (snapshot.hasData) {
                markers = snapshot.data!.map((property) {
                  // Si les coordonnées de la propriété sont valides, on les utilise, sinon Brazzaville par défaut
                  final lat = property.latitude != 0.0 ? property.latitude : -4.2634;
                  final lng = property.longitude != 0.0 ? property.longitude : 15.2429;

                  return Marker(
                    width: 95,
                    height: 38,
                    point: LatLng(lat, lng),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A86B),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${property.pricePerNight.toStringAsFixed(0)} F',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }).toList();
              }

              return FlutterMap(
                options: MapOptions(
                  initialCenter: _brazzavilleCenter,
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.h_mobile',
                  ),
                  MarkerLayer(markers: markers),
                ],
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFF00A86B)),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Rechercher un logement à Brazzaville...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}