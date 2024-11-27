class Evento {
  final int id;
  final String title;
  final String? description;
  final String? imageUrl;
  final int? organizerId;
  final String? category;
  final int? categoryid;
  final DateTime startTime;
  final DateTime? endTime;
  final String? location;

  Evento({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.organizerId,
    required this.category,
    required this.categoryid,
    required this.startTime,
    required this.endTime,
    required this.location,
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
      endTime: DateTime.parse(json['end_time']) ?? DateTime.now(),
      location: json['location'] ?? '',
    );
  }
}
