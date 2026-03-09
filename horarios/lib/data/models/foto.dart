class Foto {
  final String id;
  final String pathArchivo;
  final DateTime fecha;
  final String? nombre;
  final String? materiaId;

  Foto({
    required this.id,
    required this.pathArchivo,
    required this.fecha,
    this.nombre,
    this.materiaId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pathArchivo': pathArchivo,
      'fecha': fecha.toIso8601String(),
      'nombre': nombre,
      'materiaId': materiaId,
    };
  }

  factory Foto.fromJson(Map<String, dynamic> json) {
    return Foto(
      id: json['id'] as String,
      pathArchivo: json['pathArchivo'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      nombre: json['nombre'] as String?,
      materiaId: json['materiaId'] as String?,
    );
  }
}
