class Evento {
  final int id;
  final String title;
  final DateTime startTime;
  final String imageUrl;
  final String category;

  Evento({
    required this.id,
    required this.title,
    required this.startTime,
    required this.imageUrl,
    required this.category,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      title: json['title'],
      startTime: DateTime.parse(json['start_time']),
      imageUrl: json['image_url'],
      category: json['category'],
    );
  }
}
