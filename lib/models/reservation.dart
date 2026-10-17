class Reservation {
  final int id;
  final String propertyTitle;
  final String checkIn;
  final String checkOut;
  final double totalPrice;
  final String status;

  Reservation({
    required this.id,
    required this.propertyTitle,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? 0,
      propertyTitle: json['property']?['title'] ?? json['property_title'] ?? 'Logement',
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out'] ?? '',
      totalPrice: double.parse((json['total_price'] ?? 0).toString()),
      status: json['status'] ?? 'En attente',
    );
  }
}