class Evento {
  final String id;
  final String nombre;
  final String tipo;
  final String imagen;
  final DateTime startTime;
  final String descripcion;

  Evento({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.imagen,
    required this.startTime,
    this.descripcion = '',
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id']?.toString() ?? '', // Convertir a String y manejar null
      nombre: json['title'] ?? 'Sin título', // Manejar null
      tipo: json['category'] ?? 'Sin categoría', // Manejar null
      imagen: json['image_url'] ?? '', // Manejar null
      startTime: DateTime.parse(json['start_time']),
      descripcion: json['descripcion'] ?? '', // Manejar null
    );
  }
}
