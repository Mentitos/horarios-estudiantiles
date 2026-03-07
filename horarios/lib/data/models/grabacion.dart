class Grabacion {
  final String id;
  final String pathArchivo;
  final DateTime fecha;
  final Duration duracion;
  final String? nombre;
  final String? materiaId;

  Grabacion({
    required this.id,
    required this.pathArchivo,
    required this.fecha,
    required this.duracion,
    this.nombre,
    this.materiaId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pathArchivo': pathArchivo,
      'fecha': fecha.toIso8601String(),
      'duracionMilisegundos': duracion.inMilliseconds,
      'nombre': nombre,
      'materiaId': materiaId,
    };
  }

  factory Grabacion.fromJson(Map<String, dynamic> json) {
    return Grabacion(
      id: json['id'] as String,
      pathArchivo: json['pathArchivo'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      duracion: Duration(
        milliseconds: json['duracionMilisegundos'] as int? ?? 0,
      ),
      nombre: json['nombre'] as String?,
      materiaId: json['materiaId'] as String?,
    );
  }
}
