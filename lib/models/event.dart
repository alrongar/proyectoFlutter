class Evento {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final int? organizerId;
  final String? category;
  final int categoryid;
  final DateTime startTime;
  final DateTime? endTime;
  final String? location;
  final double price;
  final int deleted; // Hacer este campo opcional
  final double? latitude;
  final double? longitude;
  final String? latitudeString;
  final String? longitudeString;
  final int maxAttendees;

  Evento({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.organizerId,
    this.category,
    required this.categoryid,
    required this.startTime,
    this.endTime,
    this.location,
    required this.price,
    this.deleted = 0, // Valor predeterminado de 0
    this.latitude,
    this.longitude,
    this.latitudeString,
    this.longitudeString,
    this.maxAttendees = 0,
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
      endTime:
          json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      latitude: (json['latitude'] != null) ? double.tryParse(json['latitude'].toString()) : 0.0,
      longitude: (json['longitude'] != null) ? double.tryParse(json['longitude'].toString()) : 0.0,
      latitudeString: json['latitude']?.toString(),
      longitudeString: json['longitude']?.toString(),
      maxAttendees: json['max_attendees'] ?? 0,
      price: json['price'] != null ? json['price'].toDouble() : 0.0,
      deleted: json['deleted'] ?? 0, // Valor predeterminado de 0
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
      'latitude': latitude,
      'longitude': longitude,
      'latitude_string': latitudeString,
      'longitude_string': longitudeString,
      'max_attendees': maxAttendees,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'location': location,
      'price': price,
      'deleted': deleted, // Incluir el campo deleted
    };
  }
}
