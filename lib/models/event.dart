class Evento {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final int? organizerId;
  final String? category;
  final int? categoryid;
  final DateTime startTime;
  final DateTime? endTime;
  final String? location;
  final double price; // Añadir este campo

  Evento({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.organizerId,
    this.category,
    this.categoryid,
    required this.startTime,
    this.endTime,
    this.location,
    required this.price, // Añadir este campo
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'] ?? 0,
      title: json['title'],
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      organizerId: json['organizer_id'] ?? 0,
      category: json['category'] ?? '',
      categoryid: json['category_id'] ?? 0,
      startTime: DateTime.parse(json['start_time']),
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      location: json['location'] ?? '',
      price: json['price'] != null ? json['price'].toDouble() : 0.0, // Añadir este campo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'organizer_id': organizerId,
      'category': category,
      'category_id': categoryid,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'location': location,
      'price': price, // Añadir este campo
    };
  }
}
