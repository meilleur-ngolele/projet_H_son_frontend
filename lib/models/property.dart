class Property {
  final int id;
  final String title;
  final String description;
  final String type;
  final double pricePerNight;
  final String city;
  final String address;
  final double latitude;
  final double longitude;
  final bool isCertified;
  final bool isFeatured;
  final String imageUrl;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.pricePerNight,
    required this.city,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isCertified,
    required this.isFeatured,
    required this.imageUrl,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'hotel',
      pricePerNight: double.tryParse(json['price_per_night'].toString()) ?? 0.0,
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      isCertified: json['is_certified'] == 1 || json['is_certified'] == true,
      isFeatured: json['is_featured'] == 1 || json['is_featured'] == true,
      imageUrl: json['image_url'] ?? '',
    );
  }
}