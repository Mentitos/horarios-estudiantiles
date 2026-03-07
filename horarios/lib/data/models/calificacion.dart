class Calificacion {
  final String id;
  final String titulo;
  final String materiaId;
  final String nombreMateria;
  final DateTime fecha;
  final String tipoEvaluacion;
  final double valorPorcentual;
  final String nota;
  final String sistemaCalificacion;

  Calificacion({
    required this.id,
    required this.titulo,
    required this.materiaId,
    required this.nombreMateria,
    required this.fecha,
    required this.tipoEvaluacion,
    required this.valorPorcentual,
    required this.nota,
    required this.sistemaCalificacion,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'materiaId': materiaId,
      'nombreMateria': nombreMateria,
      'fecha': fecha.toIso8601String(),
      'tipoEvaluacion': tipoEvaluacion,
      'valorPorcentual': valorPorcentual,
      'nota': nota,
      'sistemaCalificacion': sistemaCalificacion,
    };
  }

  factory Calificacion.fromJson(Map<String, dynamic> json) {
    return Calificacion(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      materiaId: json['materiaId'] as String,
      nombreMateria: json['nombreMateria'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      tipoEvaluacion: json['tipoEvaluacion'] as String,
      valorPorcentual: (json['valorPorcentual'] as num).toDouble(),
      nota: json['nota'] as String,
      sistemaCalificacion: json['sistemaCalificacion'] as String,
    );
  }
}
