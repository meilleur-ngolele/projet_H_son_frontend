class Review {
  final int id;
  final String propertyTitle;
  final int rating;
  final String comment;

  Review({
    required this.id,
    required this.propertyTitle,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      propertyTitle: json['property_title'] ?? 'Logement',
      rating: json['rating'] ?? 5,
      comment: json['comment'] ?? '',
    );
  }
}