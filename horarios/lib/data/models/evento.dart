class Evento {
  final String id;
  final String titulo;
  final DateTime fecha;
  final String materiaId;
  final String tipo;

  Evento({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.materiaId,
    required this.tipo,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'fecha': fecha.toIso8601String(),
    'materiaId': materiaId,
    'tipo': tipo,
  };

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
    id: json['id'],
    titulo: json['titulo'],
    fecha: DateTime.parse(json['fecha']),
    materiaId: json['materiaId'],
    tipo: json['tipo'],
  );
}
